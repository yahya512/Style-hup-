import 'package:dx/core/theme/appstyles.dart';
import 'package:flutter/material.dart';

Widget emailFormField(TextEditingController emailController) {
  return TextFormField(
    onTapOutside: (event) {
      // click outside to cancel typing
      FocusManager.instance.primaryFocus?.unfocus();
    },
    controller: emailController,
    textInputAction: TextInputAction.next,
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
      label: Text("Enter Your email", style: AppStyles.labelTextStyle),
      enabledBorder: AppStyles.outlineInputBorderstyle,
      focusedBorder: AppStyles.foucasedoutlineInputBorder,
      errorBorder: AppStyles.errorBorder,
      focusedErrorBorder: AppStyles.errorBorder,
    ),
    validator: (String? value) {
      if (value!.isEmpty) {
        return "Required field please Enter Your Email";
      }
      return null;
    },
  );
}
