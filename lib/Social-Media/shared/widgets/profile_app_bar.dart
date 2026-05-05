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

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.add_box_outlined, color: Colors.black, size: 26.r),
        onPressed: () {},
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            username,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.black, size: 20.r),
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
                color: Color(0xFF32DBE6),
              ),
            ),
          )
        else
          IconButton(
            icon: Icon(Icons.edit_outlined, color: Colors.black, size: 22.r),
            onPressed: onEdit,
          ),
        IconButton(
          icon: Icon(Icons.menu, color: Colors.black, size: 26.r),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
