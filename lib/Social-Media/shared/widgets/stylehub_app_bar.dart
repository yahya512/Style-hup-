import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/feed/screens/create_post_screen.dart';
import 'package:dx/Social-Media/feed/cubit/feed_cubit.dart';
import 'package:dx/Social-Media/notifications/widgets/notification_bell.dart';
import 'package:dx/Social-Media/profile_posts/cubit/my_posts_cubit.dart';
import 'package:dx/Social-Media/user/cubit/user_profile_cubit.dart';

class StyleHubAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StyleHubAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF800020),
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.add, color: Colors.white, size: 28.r),
        onPressed: () async {
          final posted = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const CreatePostScreen()),
          );
          if (posted == true && context.mounted) {
            context.read<FeedCubit>().refreshFeed();
            context.read<MyPostsCubit>().refreshPosts();
            context.read<UserProfileCubit>().silentRefresh();
          }
        },
      ),
      title: Text(
        'StyleHub',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        const NotificationBell(),
        SizedBox(width: 8.w),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}