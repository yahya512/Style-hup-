import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/shared/widgets/profile_avatar.dart';
import 'package:dx/Social-Media/shared/widgets/profile_stat_item.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({
    super.key,
    this.profileImageUrl,
    required this.posts,
    required this.followers,
    required this.following,
    this.onAddImage,
    this.onFollowersTap,
    this.onFollowingTap,
  });

  final String? profileImageUrl;
  final int posts;
  final int followers;
  final int following;
  final VoidCallback? onAddImage;
  final VoidCallback? onFollowersTap;
  final VoidCallback? onFollowingTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
      child: Row(
        children: [
          ProfileAvatar(imageUrl: profileImageUrl, onTap: onAddImage),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ProfileStatItem(count: posts, label: 'Posts'),
                GestureDetector(
                  onTap: onFollowersTap,
                  child: ProfileStatItem(count: followers, label: 'Followers'),
                ),
                GestureDetector(
                  onTap: onFollowingTap,
                  child: ProfileStatItem(count: following, label: 'Following'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
