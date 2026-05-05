import 'package:dx/core/theme/appstyles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget gooleLogIn() {
  return Padding(
    padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SizedBox(
            width: 400.w,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Image.asset(
                "images/google logo.png",
                width: 30.w,
                height: 30.h,
              ),
              style: AppStyles.googleElevatedButtonStyle,
              label: Text(
                maxLines: 1,
                "auth.login_google".tr(),
                style: AppStyles.googleTextButtonStyle,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
