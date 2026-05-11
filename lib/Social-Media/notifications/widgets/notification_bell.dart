import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/notifications/cubit/notification_cubit.dart';
import 'package:dx/Social-Media/notifications/cubit/notification_state.dart';
import 'package:dx/core/navigation/tab_notifier.dart';

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      buildWhen: (prev, curr) => prev.unreadCount != curr.unreadCount,
      builder: (context, state) {
        final count = state.unreadCount;
        return IconButton(
          icon: Badge(
            isLabelVisible: count > 0,
            label: Text(count > 99 ? '99+' : '$count'),
            backgroundColor: Colors.red,
            child: Icon(
              Icons.favorite_border,
              color: Colors.white,
              size: 26.r,
            ),
          ),
          onPressed: () => appTabNotifier.value = 5,
        );
      },
    );
  }
}
