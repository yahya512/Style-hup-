import 'package:dx/core/theme/appstyles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
      label: Text("auth.confirm_password".tr(), style: AppStyles.labelTextStyle),
      suffixIcon: eyeicone,
      border: AppStyles.outlineInputBorderstyle,
      focusedBorder: AppStyles.foucasedoutlineInputBorder,
      errorBorder: AppStyles.errorBorder,
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
