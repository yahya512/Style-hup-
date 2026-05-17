import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/core/validators/text_validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditCardInfoScreen extends StatefulWidget {
  final String brandId;
  final String cartId;
  const EditCardInfoScreen({super.key, required this.brandId, required this.cartId});
  @override
  State<EditCardInfoScreen> createState() {
    return _EditCardInfoScreenState();
  }
}

class _EditCardInfoScreenState extends State<EditCardInfoScreen> {
  //formkey
  late final GlobalKey<FormState> _addCardKey;
  //controllers
  late TextEditingController _cardHolder;
  late TextEditingController _cardNumber;
  late TextEditingController _cardCvv;
  late TextEditingController _cardValid;
  @override
  void initState() {
    _addCardKey = GlobalKey();
    _cardHolder = TextEditingController();
    _cardNumber = TextEditingController();
    _cardValid = TextEditingController();
    _cardCvv = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _cardHolder.dispose();
    _cardNumber.dispose();
    _cardValid.dispose();
    _cardCvv.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("card.edit_card_title".tr(), style: AppStyles.mainTitleStyle.copyWith(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF800020),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _addCardKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsDirectional.all(24.dg),
            child: SizedBox(
              child: Column(
                spacing: 50.h,
                children: [
                  TextFormField(
                    controller: _cardHolder,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      label: Text(
                        "card.holder".tr(),
                        style: AppStyles.labelTextStyle,
                      ),
                      enabledBorder: AppStyles.outlineInputBorderstyle,
                      focusedBorder: AppStyles.foucasedoutlineInputBorder,
                      errorBorder: AppStyles.errorBorder,
                      focusedErrorBorder: AppStyles.errorBorder,
                    ),
                    validator: (value) => TextValidation.textValidation(value!),
                  ),

                  TextFormField(
                    maxLength: 16,
                    controller: _cardNumber,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text(
                        "card.number".tr(),
                        style: AppStyles.labelTextStyle,
                      ),
                      enabledBorder: AppStyles.outlineInputBorderstyle,
                      focusedBorder: AppStyles.foucasedoutlineInputBorder,
                      errorBorder: AppStyles.errorBorder,
                      focusedErrorBorder: AppStyles.errorBorder,
                    ),
                    validator: (value) {
                      if (value!.length < 16) {
                        return "card.invalid_number".tr();
                      }
                      TextValidation.textValidation(value);
                      return null;
                    },
                  ),
                  Row(
                    spacing: 10.w,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cardValid,
                          keyboardType: TextInputType.datetime,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            label: Text(
                              "card.expiry_hint".tr(),
                              style: AppStyles.labelTextStyle,
                            ),
                            enabledBorder: AppStyles.outlineInputBorderstyle,
                            focusedBorder: AppStyles.foucasedoutlineInputBorder,
                            errorBorder: AppStyles.errorBorder,
                            focusedErrorBorder: AppStyles.errorBorder,
                          ),
                          validator: (value) =>
                              TextValidation.textValidation(value!),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _cardCvv,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            label: Text(
                              "card.cvv".tr(),
                              style: AppStyles.labelTextStyle,
                            ),
                            enabledBorder: AppStyles.outlineInputBorderstyle,
                            focusedBorder: AppStyles.foucasedoutlineInputBorder,
                            errorBorder: AppStyles.errorBorder,
                            focusedErrorBorder: AppStyles.errorBorder,
                          ),
                          validator: (value) =>
                              TextValidation.textValidation(value!),
                        ),
                      ),
                    ],
                  ),

                  //button save changes
                  ElevatedButton(
                    onPressed: () {
                      if (_addCardKey.currentState!.validate()) {
                        Navigator.of(context).pop<Map<String, String>>({
                          'holder': _cardHolder.text,
                          'number': _cardNumber.text,
                          'expiry': _cardValid.text,
                        });
                      }
                    },
                    style: AppStyles.commerceButton,
                    child: Text(
                      "card.save_changes".tr(),
                      style: AppStyles.whiteTextButtonStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
