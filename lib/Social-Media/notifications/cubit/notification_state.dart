import 'package:equatable/equatable.dart';
import 'package:dx/Social-Media/notifications/models/notification_model.dart';

enum NotificationStatus { initial, loading, loadingMore, success, failure }

// Sentinel so copyWith can explicitly clear bannerNotification to null.
const _absent = _Absent();

final class _Absent {
  const _Absent();
}

class NotificationState extends Equatable {
  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.unreadCount = 0,
    this.hasMore = true,
    this.offset = 0,
    this.error,
    this.bannerNotification,
  });

  final NotificationStatus status;
  final List<NotificationModel> notifications;
  final int unreadCount;
  final bool hasMore;
  final int offset;
  final String? error;

  /// Non-null when a real-time push arrives; cleared after banner dismisses.
  final NotificationModel? bannerNotification;

  bool get isInitialLoading =>
      status == NotificationStatus.loading && notifications.isEmpty;

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationModel>? notifications,
    int? unreadCount,
    bool? hasMore,
    int? offset,
    String? error,
    Object? bannerNotification = _absent,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      error: error ?? this.error,
      bannerNotification: identical(bannerNotification, _absent)
          ? this.bannerNotification
          : bannerNotification as NotificationModel?,
    );
  }

  @override
  List<Object?> get props =>
      [status, notifications, unreadCount, hasMore, offset, error, bannerNotification];
}
