import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  // Text Styles
  static TextStyle labelTextStyle = TextStyle(color: Colors.blueGrey[600]);

  static TextStyle mainTitleStyle = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle subTitleStyle = TextStyle(
    fontSize: 24.sp,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static TextStyle normalTextStyle = TextStyle(
    fontSize: 15.sp,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static TextStyle whiteTextButtonStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 24.sp,
  );
  static TextStyle greyTextButtonStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.grey[800],
    fontSize: 22.sp,
  );

  static TextStyle snackBarStyle = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
  );

  // Border Styles
  static OutlineInputBorder outlineInputBorderstyle = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black),
  );

  static OutlineInputBorder foucasedoutlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.w),
  );

  static OutlineInputBorder errorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 1.5.w),
  );

  // Buttons style
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    minimumSize: Size(double.infinity, 48.h),
    backgroundColor: Colors.black,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(25.r),
    ),
  );

  static ButtonStyle googleElevatedButtonStyle = ElevatedButton.styleFrom(
    minimumSize: Size(double.infinity, 48.h),
    backgroundColor: Colors.grey[400],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
  );
}
