import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/core/validators/password_validator.dart';
import 'package:flutter/material.dart';

Widget passwordField(
  TextEditingController passswordController,
  bool visiable,
  Widget eyeicone,
) {
  return TextFormField(
    onTapOutside: (event) {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    controller: passswordController,
    keyboardType: TextInputType.visiblePassword,
    obscureText: visiable,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      label: Text("Enter Your Password", style: AppStyles.labelTextStyle),
      suffixIcon: eyeicone,
      border: AppStyles.outlineInputBorderstyle,
      focusedBorder: AppStyles.foucasedoutlineInputBorder,
      errorBorder: AppStyles.errorBorder,
    ),
    validator: (value) => PasswordValidator.passwordChecker(value!),
  );
}
