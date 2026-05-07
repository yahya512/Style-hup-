import 'package:dx/Authentication/Regestration/login.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shared AppBar used by both user and brand profile screens.
/// Shows an edit icon when [isUpdating] is false, or a loading spinner
/// when [isUpdating] is true (used by brand during profile save).
class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({
    super.key,
    required this.username,
    this.onEdit,
    this.isUpdating = false,
  });

  final String username;
  final VoidCallback? onEdit;

  /// When true, replaces the edit icon with a progress indicator.
  final bool isUpdating;

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 8.h),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                try {
                  await getIt<UserRepository>().logout();
                } catch (_) {}
                await CacheHelper.sharedPreferences.clear();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LogIn()),
                  (route) => false,
                );
              },
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF800020),
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            username,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.white70, size: 20.r),
        ],
      ),
      actions: [
        if (isUpdating)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          )
        else
          IconButton(
            icon: Icon(Icons.edit_outlined, color: Colors.white, size: 22.r),
            onPressed: onEdit,
          ),
        IconButton(
          icon: Icon(Icons.menu, color: Colors.white, size: 26.r),
          onPressed: () => _showMenu(context),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
