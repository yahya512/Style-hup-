import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/core/theme/appstyles.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.dynamic_feed_outlined,
            size: 64.r,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'Your feed is empty',
            style: AppStyles.subTitleStyle,
          ),
          SizedBox(height: 8.h),
          Text(
            'Follow people to see their posts here.',
            style: AppStyles.labelTextStyle,
          ),
        ],
      ),
    );
  }
}