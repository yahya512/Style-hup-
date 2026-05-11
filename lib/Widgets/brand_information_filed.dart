import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget brandInfo(
  TextEditingController brandController,
  String hintText, {
  int? maxLines,
  TextInputType? keyboardType,
  IconData prefixIconData = Icons.edit_outlined,
}) {
  return TextFormField(
    onTapOutside: (event) {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    controller: brandController,
    maxLines: maxLines ?? 1,
    textInputAction: TextInputAction.next,
    keyboardType: keyboardType ?? TextInputType.text,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
      prefixIcon: Icon(prefixIconData, color: Colors.grey[500], size: 20.r),
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding: EdgeInsetsDirectional.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: Colors.black, width: 1.5.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: Colors.red, width: 1.5.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: Colors.red, width: 1.5.w),
      ),
    ),
    validator: (String? value) {
      if (value!.isEmpty) {
        return "Please enter $hintText";
      }
      return null;
    },
  );
}
