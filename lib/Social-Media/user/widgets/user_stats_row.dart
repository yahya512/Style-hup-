import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserStatsRow extends StatelessWidget {
  const UserStatsRow({
    super.key,
    required this.posts,
    required this.followers,
    required this.following,
  });

  final int posts;
  final int followers;
  final int following;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StatItem(label: 'Posts', count: posts),
        const SizedBox(width: 16),
        StatItem(label: 'Followers', count: followers),
        const SizedBox(width: 16),
        StatItem(label: 'Following', count: following),
      ],
    );
  }
}

// lib/Social-Media/user/widgets/stat_item.dart

class StatItem extends StatelessWidget {
  final int count;
  final String label;

  const StatItem({super.key, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 17.sp, // Slightly smaller for better fit
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 2.h), // Add a small gap here
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp, 
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}