import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget passwordConfirmField(
  TextEditingController passChecker,
  TextEditingController passwordController,
  bool visiable,
  Widget eyeicone,
) {
  return TextFormField(
    onTapOutside: (event) {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    controller: passwordController,
    keyboardType: TextInputType.visiblePassword,
    obscureText: visiable,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      hintText: "auth.confirm_password".tr(),
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
      prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[500], size: 20.r),
      suffixIcon: eyeicone,
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
    validator: (value) {
      if (value!.isEmpty) {
        return "auth.confirm_password_required".tr();
      }
      if (kDebugMode) {
        print("VALUE : $value\n PASSWORD : ${passwordController.text}");
      }
      if (value != passChecker.text) {
        return "auth.passwords_not_match".tr();
      }
      return null;
    },
  );
}
