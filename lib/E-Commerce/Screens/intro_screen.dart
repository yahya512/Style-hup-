import 'package:dx/E-Commerce/Screens/home_screen.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntroEcommerce extends StatelessWidget {
  const IntroEcommerce({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        spacing: 25.h,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF32DBE6),
              borderRadius: BorderRadiusDirectional.circular(80.r),
            ),
            child: Image.asset("images/DXlogo.png"),
          ),
          Text("intro.title".tr(), style: AppStyles.normalTextStyle),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 70.h),
                backgroundColor: const Color(0xFF800020),
                padding: EdgeInsetsDirectional.all(10.dg),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(25.r),
                ),
              ),
              child: Text(
                "intro.get_started".tr(),
                style: AppStyles.whiteTextButtonStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
