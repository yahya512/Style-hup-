import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/core/theme/appstyles.dart';

class ProfileBio extends StatelessWidget {
  final String name;
  final String? bio;

  const ProfileBio({super.key, required this.name, this.bio});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: AppStyles.normalTextStyle),
          if (bio != null)
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Text(bio!, style: TextStyle(fontSize: 16.sp, color: Colors.black, height: 1.3)),
            ),
        ],
      ),
    );
  }
}

