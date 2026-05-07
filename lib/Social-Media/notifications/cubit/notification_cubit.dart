import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dx/Social-Media/notifications/cubit/notification_state.dart';
import 'package:dx/Social-Media/notifications/models/notification_model.dart';
import 'package:dx/Social-Media/notifications/services/notification_service.dart';
import 'package:dx/Social-Media/notifications/services/socket_service.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({
    required NotificationService service,
    required SocketService socket,
  })  : _service = service,
        _socket = socket,
        super(const NotificationState());

  final NotificationService _service;
  final SocketService _socket;

  static const int _limit = NotificationService.defaultLimit;

  // ── WebSocket ──────────────────────────────────────────────────────────────

  /// Register the socket listener. Call after connect on login.
  void startListening() {
    _socket.onNotification((data) {
      if (isClosed) return;
      final incoming = NotificationModel.fromJson(data);
      emit(state.copyWith(
        notifications: [incoming, ...state.notifications],
        unreadCount: state.unreadCount + 1,
        bannerNotification: incoming,
      ));
    });
  }

  /// Called by the banner widget after it finishes dismissing.
  void clearBanner() {
    if (isClosed) return;
    emit(state.copyWith(bannerNotification: null));
  }

  /// Remove the socket listener. Call on logout.
  void stopListening() {
    _socket.offNotification();
  }

  // ── REST ───────────────────────────────────────────────────────────────────

  /// Cold start: clears list and fetches page 0 + unread count in parallel.
  Future<void> loadInitial() async {
    if (state.status == NotificationStatus.loading) return;

    emit(state.copyWith(
      status: NotificationStatus.loading,
      notifications: [],
      offset: 0,
      hasMore: true,
      error: null,
    ));

    try {
      final results = await Future.wait([
        _service.fetchNotifications(limit: _limit, offset: 0),
        _service.fetchUnreadCount(),
      ]);

      final page = results[0] as NotificationPage;
      final count = results[1] as int;

      emit(state.copyWith(
        status: NotificationStatus.success,
        notifications: page.items,
        unreadCount: count,
        offset: page.items.length,
        hasMore: page.items.length < page.total,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: NotificationStatus.failure,
        error: e.message ?? 'Network error — please try again.',
      ));
    } catch (_) {
      emit(state.copyWith(
        status: NotificationStatus.failure,
        error: 'Something went wrong. Please try again.',
      ));
    }
  }

  /// Appends the next page. Guards prevent duplicate in-flight requests.
  Future<void> loadMore() async {
    if (!state.hasMore) return;
    if (state.status == NotificationStatus.loading ||
        state.status == NotificationStatus.loadingMore) {
      return;
    }

    emit(state.copyWith(status: NotificationStatus.loadingMore));

    try {
      final page = await _service.fetchNotifications(
        limit: _limit,
        offset: state.offset,
      );

      final merged = [...state.notifications, ...page.items];
      emit(state.copyWith(
        status: NotificationStatus.success,
        notifications: merged,
        offset: state.offset + page.items.length,
        hasMore: merged.length < page.total,
      ));
    } on DioException catch (e) {
      // Stay in success on pagination errors — list remains visible.
      emit(state.copyWith(
        status: NotificationStatus.success,
        error: e.message ?? 'Failed to load more.',
      ));
    } catch (_) {
      emit(state.copyWith(
        status: NotificationStatus.success,
        error: 'Failed to load more.',
      ));
    }
  }

  /// Optimistically marks one notification as read, reverts on failure.
  Future<void> markAsRead(String id) async {
    final previous = state.notifications;
    final optimistic = previous
        .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
        .toList();

    emit(state.copyWith(
      notifications: optimistic,
      unreadCount: (state.unreadCount - 1).clamp(0, state.unreadCount),
    ));

    try {
      final updated = await _service.markAsRead(id);
      emit(state.copyWith(
        notifications: state.notifications
            .map((n) => n.id == id ? updated : n)
            .toList(),
      ));
    } catch (_) {
      emit(state.copyWith(
        notifications: previous,
        unreadCount: state.unreadCount + 1,
        error: 'Failed to mark as read.',
      ));
    }
  }

  /// Marks all notifications as read with optimistic update.
  Future<void> markAllAsRead() async {
    final previous = state.notifications;
    final previousCount = state.unreadCount;

    emit(state.copyWith(
      notifications: previous
          .map((n) => n.copyWith(isRead: true, readAt: DateTime.now()))
          .toList(),
      unreadCount: 0,
    ));

    try {
      await _service.markAllAsRead();
    } catch (_) {
      emit(state.copyWith(
        notifications: previous,
        unreadCount: previousCount,
        error: 'Failed to mark all as read.',
      ));
    }
  }

  /// Re-fetches the unread count — call on app resume.
  Future<void> refreshUnreadCount() async {
    try {
      final count = await _service.fetchUnreadCount();
      emit(state.copyWith(unreadCount: count));
    } catch (_) {
      // Silently ignore — stale count is acceptable on resume.
    }
  }
}
