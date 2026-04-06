import 'package:dx/core/theme/appstyles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget passwordConfirmField(
  TextEditingController passChecker,
  TextEditingController password,
  TextInputType keyboardType,
  String lable,
  bool visiable,
  Widget eyeicone,
) {
  return TextFormField(
    onTapOutside: (event) {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    controller: password,
    keyboardType: keyboardType,
    obscureText: visiable,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      label: Text(lable, style: AppStyles.labelTextStyle),
      suffixIcon: eyeicone,
      border: AppStyles.outlineInputBorderstyle,
      focusedBorder: AppStyles.foucasedoutlineInputBorder,
      errorBorder: AppStyles.errorBorder,
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return "Required field,Please enter your Password";
      }
      if (kDebugMode) {
        print("VALUE : $value\n PASSWORD : ${password.text}");
      }
      if (value != passChecker.text) {
        return "The passwords doesn't match";
      }
      return null;
    },
  );
}
