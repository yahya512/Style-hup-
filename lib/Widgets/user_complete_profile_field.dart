import 'package:dx/core/theme/appstyles.dart';
import 'package:flutter/material.dart';

Widget userCompleteProfile(
  String lable,
  TextInputType keyboardType,
  TextEditingController fieldController,
) {
  return TextFormField(
    onTapOutside: (event) {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    controller: fieldController,
    textInputAction: TextInputAction.next,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      label: Text("Enter Your $lable", style: AppStyles.labelTextStyle),
      enabledBorder: AppStyles.outlineInputBorderstyle,
      focusedBorder: AppStyles.foucasedoutlineInputBorder,
      errorBorder: AppStyles.errorBorder,
      focusedErrorBorder: AppStyles.errorBorder,
    ),
    validator: (String? value) {
      if (value!.isEmpty) {
        return "Required field please Enter Your ${lable.toLowerCase()}";
      }
      return null;
    },
  );
}
