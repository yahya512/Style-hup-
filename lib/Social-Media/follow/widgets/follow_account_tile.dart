import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/follow/models/follow_account.dart';

class FollowAccountTile extends StatelessWidget {
  const FollowAccountTile({
    super.key,
    required this.account,
    required this.onTap,
  });

  final FollowAccount account;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 22.r,
        backgroundColor: Colors.grey[200],
        backgroundImage: account.profileImageUrl != null
            ? NetworkImage(account.profileImageUrl!)
            : null,
        child: account.profileImageUrl == null
            ? Text(
                account.displayName[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              )
            : null,
      ),
      title: Text(
        account.displayName,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
      ),
      subtitle: account.username != null
          ? Text(
              '@${account.username}',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
            )
          : null,
    );
  }
}
