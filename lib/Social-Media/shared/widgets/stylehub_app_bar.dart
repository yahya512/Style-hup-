import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/feed/screens/create_post_screen.dart';
import 'package:dx/Social-Media/feed/cubit/feed_cubit.dart';

class StyleHubAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StyleHubAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.add, color: Colors.black, size: 28.r),
        onPressed: () async {
          final posted = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const CreatePostScreen()),
          );
          if (posted == true && context.mounted) {
            context.read<FeedCubit>().refreshFeed();
          }
        },
      ),
      title: Text(
        'StyleHub',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Badge(
            label: const Text('3'),
            backgroundColor: Colors.red,
            child: Icon(Icons.favorite_border, color: Colors.black, size: 26.r),
          ),
          onPressed: () {
            // TODO: Navigate to Notifications/Activity Screen
          },
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}