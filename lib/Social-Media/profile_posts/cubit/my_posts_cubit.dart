import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dx/Social-Media/profile_posts/cubit/my_posts_state.dart';
import 'package:dx/Social-Media/profile_posts/services/my_posts_service.dart';

class MyPostsCubit extends Cubit<MyPostsState> {
  MyPostsCubit({required MyPostsService service})
      : _service = service,
        super(const MyPostsState.initial());

  final MyPostsService _service;
  static const int _limit = MyPostsService.defaultLimit;

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Cold start: clears the list and loads from offset 0.
  Future<void> loadPosts() async {
    if (state.status == MyPostsStatus.loading) return;

    emit(state.copyWith(
      status: MyPostsStatus.loading,
      posts: [],
      offset: 0,
      hasMore: true,
    ));

    await _fetchPage(offset: 0, append: false);
  }

  /// Pull-to-refresh: silently reloads from offset 0, old list stays visible.
  Future<void> refreshPosts() async {
    if (state.status == MyPostsStatus.refreshing) return;

    emit(state.copyWith(status: MyPostsStatus.refreshing));
    await _fetchPage(offset: 0, append: false);
  }

  /// Appends the next page. Guards prevent duplicate in-flight requests.
  Future<void> loadMorePosts() async {
    if (!state.hasMore) return;
    if (state.status == MyPostsStatus.loadingMore ||
        state.status == MyPostsStatus.loading ||
        state.status == MyPostsStatus.refreshing) {
      return;
    }

    emit(state.copyWith(status: MyPostsStatus.loadingMore));
    await _fetchPage(offset: state.offset, append: true);
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  Future<void> _fetchPage({
    required int offset,
    required bool append,
  }) async {
    try {
      final page = await _service.getMyPosts(offset: offset, limit: _limit);

      emit(state.copyWith(
        status: MyPostsStatus.success,
        posts: append ? [...state.posts, ...page.items] : page.items,
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

  /// Pagination errors keep the existing list visible (stay in success).
  /// Full-load errors transition to failure so the error screen shows.
  void _handleError(String message, {required bool append}) {
    emit(state.copyWith(
      status: append ? MyPostsStatus.success : MyPostsStatus.failure,
      errorMessage: message,
      errorCount: state.errorCount + 1,
    ));
  }
}
