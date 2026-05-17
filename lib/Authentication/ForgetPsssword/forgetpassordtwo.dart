import 'package:dx/Authentication/ForgetPsssword/forgetpasswordthree.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

const _primary = Color(0xFF800020);

class ForgetpassordTwo extends StatefulWidget {
  final String emailUser;
  const ForgetpassordTwo({super.key, required this.emailUser});
  @override
  State<StatefulWidget> createState() => _ForgetpasswordTwoState();
}

class _ForgetpasswordTwoState extends State<ForgetpassordTwo> {
  late final GlobalKey<FormState> _otpFormKey = GlobalKey();
  late final TextEditingController _otpController;

  @override
  void initState() {
    _otpController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primary,
      body: Column(
        children: [
          // ── Maroon header ──
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 20),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "forget_password.title".tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "forget_password.enter_code_sent_to".tr(),
                          style: TextStyle(
                              color: Colors.white70, fontSize: 13.sp),
                        ),
                        TextSpan(
                          text: widget.emailUser,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── White card ──
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.r),
                  topRight: Radius.circular(32.r),
                ),
              ),
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: 24.w, vertical: 36.h),
                child: Form(
                  key: _otpFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "forget_password.submit_code".tr(),
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: _primary,
                        ),
                      ),
                      SizedBox(height: 28.h),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12.r),
                          fieldHeight: 55.h,
                          fieldWidth: 45.w,
                          activeColor: _primary,
                          selectedColor: _primary,
                          inactiveColor: Colors.grey[300]!,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "forget_password.code_required".tr();
                          }
                          if (value.length < 6) {
                            return "forget_password.code_length".tr();
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 36.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: () {
                            if (_otpFormKey.currentState!.validate()) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ForgetpassordThree(
                                    otpCode: _otpController.text,
                                    emailUser: widget.emailUser,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "forget_password.submit_code".tr(),
                            style: AppStyles.whiteTextButtonStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
