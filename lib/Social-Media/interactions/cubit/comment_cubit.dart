import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dx/Social-Media/interactions/cubit/comment_state.dart';
import 'package:dx/Social-Media/interactions/services/interaction_service.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit({
    required InteractionService service,
    required String postId,
    required void Function(int delta) onCountChanged,
  })  : _service = service,
        _postId = postId,
        _onCountChanged = onCountChanged,
        super(const CommentState());

  final InteractionService _service;
  final String _postId;
  final void Function(int delta) _onCountChanged;
  static const int _limit = 10;

  Future<void> loadComments() async {
    if (state.status == CommentStatus.loading) {
      return;
    }
    emit(state.copyWith(
      status: CommentStatus.loading,
      comments: [],
      offset: 0,
      hasMore: true,
    ));
    await _fetchPage(offset: 0, append: false);
  }

  Future<void> loadMoreComments() async {
    if (!state.hasMore) return;
    if (state.status == CommentStatus.loadingMore ||
        state.status == CommentStatus.loading) {
      return;
    }
    emit(state.copyWith(status: CommentStatus.loadingMore));
    await _fetchPage(offset: state.offset, append: true);
  }

  Future<void> addComment(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty || trimmed.length > 1000) return;
    emit(state.copyWith(status: CommentStatus.submitting));
    try {
      await _service.addComment(
        postId: _postId,
        content: trimmed,
      );
      _onCountChanged(1);
      // Reload to get full author data (name + image) from the server.
      await loadComments();
    } catch (_) {
      emit(state.copyWith(
        status: CommentStatus.failure,
        errorMessage: 'Failed to post comment.',
        errorCount: state.errorCount + 1,
      ));
    }
  }

  Future<void> editComment(String commentId, String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty || trimmed.length > 1000) return;
    try {
      final updated = await _service.editComment(
        commentId: commentId,
        content: trimmed,
      );
      final updatedList = state.comments
          .map((c) => c.id == commentId ? updated : c)
          .toList();
      emit(state.copyWith(
        status: CommentStatus.success,
        comments: updatedList,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: CommentStatus.failure,
        errorMessage: 'Failed to update comment.',
        errorCount: state.errorCount + 1,
      ));
    }
  }

  Future<void> deleteComment(String commentId) async {
    try {
      await _service.deleteComment(commentId);
      final updatedList =
          state.comments.where((c) => c.id != commentId).toList();
      emit(state.copyWith(
        status: CommentStatus.success,
        comments: updatedList,
        offset: (state.offset - 1).clamp(0, 999999),
      ));
      _onCountChanged(-1);
    } catch (_) {
      emit(state.copyWith(
        status: CommentStatus.failure,
        errorMessage: 'Failed to delete comment.',
        errorCount: state.errorCount + 1,
      ));
    }
  }

  Future<void> _fetchPage({
    required int offset,
    required bool append,
  }) async {
    try {
      final page =
          await _service.getComments(_postId, offset: offset, limit: _limit);
      emit(state.copyWith(
        status: CommentStatus.success,
        comments: append ? [...state.comments, ...page.items] : page.items,
        hasMore: page.hasMore,
        offset: offset + page.items.length,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: append ? CommentStatus.success : CommentStatus.failure,
        errorMessage: 'Failed to load comments.',
        errorCount: state.errorCount + 1,
      ));
    }
  }
}
