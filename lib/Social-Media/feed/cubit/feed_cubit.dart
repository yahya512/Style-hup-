import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dx/Social-Media/feed/cubit/feed_state.dart';
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

      emit(state.copyWith(
        status: FeedStatus.success,
        items: append ? [...state.items, ...page.items] : page.items,
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
      status: append ? FeedStatus.success : FeedStatus.failure,
      errorMessage: message,
      errorCount: state.errorCount + 1,
    ));
  }
}
