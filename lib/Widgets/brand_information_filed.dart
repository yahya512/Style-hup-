import 'package:dx/core/theme/appstyles.dart';
import 'package:flutter/material.dart';

Widget brandInfo(
  TextEditingController brandController,
  String lableText, {
  int? maxLines,
  TextInputType? keyboardType,
}) {
  return TextFormField(
    onTapOutside: (event) {
      // click outside to cancel typing
      FocusManager.instance.primaryFocus?.unfocus();
    },
    controller: brandController,
    maxLines: maxLines,
    textInputAction: TextInputAction.next,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      label: SizedBox(
        child: Text(lableText, style: TextStyle(color: Colors.blueGrey[600])),
      ),
      enabledBorder: AppStyles.outlineInputBorderstyle,
      focusedBorder: AppStyles.foucasedoutlineInputBorder,
      errorBorder: AppStyles.errorBorder,
      focusedErrorBorder: AppStyles.errorBorder,
    ),

    validator: (String? value) {
      if (value!.isEmpty) {
        return "Required field please Enter Your Description";
      }
      return null;
    },
  );
}
