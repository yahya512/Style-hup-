import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dx/Social-Media/feed/cubit/feed_state.dart';
import 'package:dx/Social-Media/feed/models/post_model.dart';
import 'package:dx/Social-Media/feed/services/feed_service.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit({required FeedService feedService})
      : _feedService = feedService,
        super(const FeedState.initial());

  final FeedService _feedService;
  static const int _limit = FeedService.defaultLimit;

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Cold start: clears the list and loads from offset 0.
  Future<void> loadFeed() async {
    if (state.status == FeedStatus.loading) return;

    emit(state.copyWith(
      status: FeedStatus.loading,
      items: [],
      offset: 0,
      hasMore: true,
    ));

    await _fetchPage(offset: 0, append: false);
  }

  /// Pull-to-refresh: silently reloads from offset 0, old list stays visible.
  Future<void> refreshFeed() async {
    if (state.status == FeedStatus.refreshing) return;

    emit(state.copyWith(status: FeedStatus.refreshing));
    await _fetchPage(offset: 0, append: false);
  }

  /// Appends the next page. Guards prevent duplicate in-flight requests.
  Future<void> loadMoreFeed() async {
    if (!state.hasMore) return;
    if (state.status == FeedStatus.loadingMore ||
        state.status == FeedStatus.loading ||
        state.status == FeedStatus.refreshing) {
      return;
    }

    emit(state.copyWith(status: FeedStatus.loadingMore));
    await _fetchPage(offset: state.offset, append: true);
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  Future<void> _fetchPage({
    required int offset,
    required bool append,
  }) async {
    try {
      final page = await _feedService.getFeed(offset: offset, limit: _limit);

      final merged = append ? [...state.items, ...page.items] : page.items;
      final seen = <String>{};
      final deduped =
          merged.where((item) => seen.add(item.post.id)).toList();

      emit(state.copyWith(
        status: FeedStatus.success,
        items: deduped,
        hasMore: page.hasMore,
        offset: offset + page.items.length,
      ));
    } on DioException catch (e) {
      _handleError(
        e.message ?? 'Network error — please try again.',
        append: append,
      );
    } catch (_) {
      _handleError('Something went wrong. Please try again.', append: append);
    }
  }

  /// Optimistically removes the post from the feed, then calls the API.
  /// Reverts on failure.
  Future<void> removePost(String postId) async {
    final previous = state.items;
    final updated = previous.where((i) => i.post.id != postId).toList();
    emit(state.copyWith(items: updated));
    try {
      await _feedService.deletePost(postId);
    } catch (_) {
      emit(state.copyWith(
        items: previous,
        errorMessage: 'Failed to delete post.',
        errorCount: state.errorCount + 1,
      ));
    }
  }

  /// Optimistically updates content/visibility in the feed, then calls the API.
  /// Reverts on failure.
  Future<void> editPost(
    String postId, {
    String? content,
    PostVisibility? visibility,
  }) async {
    final previous = state.items;
    final index = previous.indexWhere((i) => i.post.id == postId);
    if (index == -1) return;

    final oldItem = previous[index];
    final updatedPost = oldItem.post.copyWith(
      content: content,
      visibility: visibility,
    );
    final updatedItem = FeedItemModel(
      id: oldItem.id,
      type: oldItem.type,
      createdAt: oldItem.createdAt,
      post: updatedPost,
    );
    final updated = List<FeedItemModel>.from(previous)..[index] = updatedItem;
    emit(state.copyWith(items: updated));

    try {
      await _feedService.updatePost(postId, content: content, visibility: visibility);
    } catch (_) {
      emit(state.copyWith(
        items: previous,
        errorMessage: 'Failed to update post.',
        errorCount: state.errorCount + 1,
      ));
    }
  }

  /// Pagination errors keep the existing list visible (stay in success).
  /// Full-load errors transition to failure so the error screen shows.
  void _handleError(String message, {required bool append}) {
    emit(state.copyWith(
      status: append ? FeedStatus.success : FeedStatus.failure,
      errorMessage: message,
      errorCount: state.errorCount + 1,
    ));
  }
}
