import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePostsGrid extends StatelessWidget {
  final List<Map<String, dynamic>> posts;

  const ProfilePostsGrid({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const ProfileEmptyState(icon: Icons.camera_alt_outlined, label: "No Posts Yet");
    }

    return GridView.builder(
      padding: const EdgeInsets.all(1),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1.5,
        mainAxisSpacing: 1.5,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final imageUrl = (posts[index]['images'] as List?)?.firstOrNull;
        return Container(
          color: Colors.grey[100],
          child: imageUrl != null 
              ? Image.network(imageUrl, fit: BoxFit.cover) 
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
class ProfileEmptyState extends StatelessWidget {
  final IconData icon;
  final String label;

  const ProfileEmptyState({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60.r, color: Colors.grey[300]),
          SizedBox(height: 12.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}