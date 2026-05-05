import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Circular profile avatar with a teal [+] button overlay.
/// Tap anywhere on the avatar to trigger [onTap] (e.g. open image picker).
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.onTap,
    this.defaultIcon = Icons.person,
  });

  final String? imageUrl;
  final VoidCallback? onTap;

  /// Icon shown when [imageUrl] is null.
  final IconData defaultIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 44.r,
            backgroundColor: Colors.grey[300],
            backgroundImage:
                imageUrl != null ? NetworkImage(imageUrl!) : null,
            child: imageUrl == null
                ? Icon(defaultIcon, size: 40.r, color: Colors.white)
                : null,
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Color(0xFF32DBE6),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: Colors.white, size: 14.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
