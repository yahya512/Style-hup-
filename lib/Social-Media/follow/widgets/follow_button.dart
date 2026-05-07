import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/follow/cubit/follow_button_cubit.dart';
import 'package:dx/Social-Media/follow/cubit/follow_button_state.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowButtonCubit, FollowButtonState>(
      builder: (context, state) {
        if (state.status == FollowButtonStatus.loading) {
          return SizedBox(
            width: 100.w,
            height: 34.h,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF32DBE6),
              ),
            ),
          );
        }

        final isFollowing = state.status == FollowButtonStatus.following;

        return OutlinedButton(
          onPressed: () => _handleTap(context, isFollowing),
          style: isFollowing
              ? OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  side: BorderSide(color: Colors.grey[400]!),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                )
              : OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF32DBE6),
                  side: BorderSide.none,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
          child: Text(
            isFollowing ? 'Unfollow' : 'Follow',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }

  Future<void> _handleTap(BuildContext context, bool isFollowing) async {
    if (isFollowing) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Unfollow?'),
          content: const Text('Are you sure you want to unfollow this user?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(
                'Unfollow',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    if (!context.mounted) return;
    try {
      await context.read<FollowButtonCubit>().toggle();
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final msg = switch (code) {
        400 => 'You cannot follow yourself',
        403 => 'Action not allowed',
        404 => 'User not found',
        409 => 'Already following',
        401 => 'Session expired, please login again',
        _ => 'Something went wrong. Try again.',
      };
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(msg)));
      }
    }
  }
}
