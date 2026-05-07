import 'package:dx/Social-Media/notifications/models/notification_model.dart';
import 'package:dx/core/api/api_client.dart';
import 'package:dx/core/api/endpoints.dart';

class NotificationPage {
  const NotificationPage({
    required this.items,
    required this.total,
  });

  final List<NotificationModel> items;
  final int total;
}

class NotificationService {
  static const int defaultLimit = 20;

  Future<NotificationPage> fetchNotifications({
    int limit = defaultLimit,
    int offset = 0,
  }) async {
    final response = await ApiClient.instance.get<Map<String, dynamic>>(
      Endpoints.notifications,
      queryParameters: {'limit': limit, 'offset': offset},
    );

    final body = response.data!;
    final raw = body['items'] as List<dynamic>? ?? const [];
    final meta = body['meta'] as Map<String, dynamic>?;
    final total = (meta?['total'] as num?)?.toInt() ?? raw.length;

    final items = raw
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return NotificationPage(items: items, total: total);
  }

  Future<int> fetchUnreadCount() async {
    final response = await ApiClient.instance
        .get<Map<String, dynamic>>(Endpoints.notificationsUnreadCount);
    return (response.data!['count'] as num).toInt();
  }

  Future<NotificationModel> markAsRead(String id) async {
    final response = await ApiClient.instance
        .patch<Map<String, dynamic>>(Endpoints.notificationRead(id));
    return NotificationModel.fromJson(response.data!);
  }

  Future<void> markAllAsRead() async {
    await ApiClient.instance.patch<dynamic>(Endpoints.notificationsReadAll);
  }
}
