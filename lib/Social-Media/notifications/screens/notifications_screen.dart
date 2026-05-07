import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/notifications/cubit/notification_cubit.dart';
import 'package:dx/Social-Media/notifications/cubit/notification_state.dart';
import 'package:dx/Social-Media/notifications/models/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationCubit>().loadInitial();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            buildWhen: (prev, curr) => prev.unreadCount != curr.unreadCount,
            builder: (context, state) {
              if (state.unreadCount == 0) return const SizedBox.shrink();
              return TextButton(
                onPressed: () =>
                    context.read<NotificationCubit>().markAllAsRead(),
                child: Text(
                  'Mark all read',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.sp,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state.isInitialLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == NotificationStatus.failure &&
              state.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.error ?? 'Something went wrong.',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 12.h),
                  TextButton(
                    onPressed: () =>
                        context.read<NotificationCubit>().loadInitial(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.notifications.isEmpty) {
            return Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            controller: _scrollController,
            itemCount:
                state.notifications.length + (state.hasMore ? 1 : 0),
            separatorBuilder: (_, __) =>
                Divider(height: 1, color: Colors.grey.shade200),
            itemBuilder: (context, index) {
              if (index == state.notifications.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final notification = state.notifications[index];
              return _NotificationTile(
                notification: notification,
                onTap: () {
                  if (!notification.isRead) {
                    context
                        .read<NotificationCubit>()
                        .markAsRead(notification.id);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  final NotificationModel notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: notification.isRead ? Colors.white : Colors.blue.shade50,
      contentPadding:
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      leading: CircleAvatar(
        radius: 22.r,
        backgroundColor: Colors.grey[200],
        backgroundImage: notification.actorPhoto != null
            ? NetworkImage(notification.actorPhoto!)
            : null,
        child: notification.actorPhoto == null
            ? Icon(Icons.person, size: 22.r, color: Colors.grey[600])
            : null,
      ),
      title: Text(
        notification.displayText,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight:
              notification.isRead ? FontWeight.normal : FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: Text(
          _timeAgo(notification.createdAt),
          style: TextStyle(fontSize: 11.sp, color: Colors.grey),
        ),
      ),
      onTap: onTap,
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
