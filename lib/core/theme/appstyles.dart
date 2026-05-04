import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppStyles {
  // Text Styles
  static TextStyle labelTextStyle = TextStyle(
    color: Colors.blueGrey[600],
    fontSize: 18.sp,
    decoration: TextDecoration.none,
  );

  static TextStyle mainTitleStyle = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    decoration: TextDecoration.none,
  );

  static TextStyle subTitleStyle = TextStyle(
    fontSize: 24.sp,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
  );

  static TextStyle normalTextStyle = TextStyle(
    fontSize: 18.sp,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
  );

  static TextStyle whiteTextButtonStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 24.sp,
    decoration: TextDecoration.none,
  );
  static TextStyle googleTextButtonStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.grey[800],
    fontSize: 22.sp,
    decoration: TextDecoration.none,
  );

  static TextStyle snackBarStyle = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
  );

  // Form Field Border Styles
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

  static ButtonStyle commerceButton = ElevatedButton.styleFrom(
    minimumSize: Size(double.infinity, 70.h),
    backgroundColor: Color(0xFF32DBE6),
    padding: EdgeInsets.all(10.dg),
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
