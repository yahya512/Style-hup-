import 'package:dx/Authentication/ForgetPsssword/forgetpasswordthree.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgetpassordTwo extends StatefulWidget {
  final String emailUser;
  const ForgetpassordTwo({super.key, required this.emailUser});
  @override
  State<StatefulWidget> createState() {
    return _ForgetpasswordTwoState();
  }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          spacing: 15.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Forget password ?", style: AppStyles.mainTitleStyle),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Enter the code that send to ",
                    style: TextStyle(color: Colors.black, fontSize: 20.sp),
                  ),
                  TextSpan(
                    text: widget.emailUser,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.lightBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25.h),
            Form(
              key: _otpFormKey,
              child: PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _otpController,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(20.r),
                  fieldHeight: 55.h,
                  fieldWidth: 45.w,
                  activeColor: Colors.blue,
                  selectedColor: Colors.blue,
                  inactiveColor: Colors.grey,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter the code that was sent";
                  }
                  if (value.length < 6) {
                    return "code must be 6 character";
                  }

                  return null;
                },
              ),
            ),
            SizedBox(height: 85.h),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  // valdation check
                  if (_otpFormKey.currentState!.validate()) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ForgetpassordThree(otpCode: _otpController.text),
                      ),
                    );
                  }
                },
                child: Text(
                  "Submit Code",
                  style: AppStyles.whiteTextButtonStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
