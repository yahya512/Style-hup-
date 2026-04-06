import 'package:dx/Authentication/Regestration/login.dart';
import 'package:dx/Authentication/models/reset_password_model.dart';
import 'package:dx/Widgets/password_confirm_field.dart';
import 'package:dx/Widgets/password_form_field.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/core/errors/exceptions.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetpassordThree extends StatefulWidget {
  final String otpCode;
  const ForgetpassordThree({super.key, required this.otpCode});
  @override
  State<StatefulWidget> createState() {
    return _ForgetpasswordTwoState();
  }
}

class _ForgetpasswordTwoState extends State<ForgetpassordThree> {
  // password Form key
  late final GlobalKey<FormState> _passwordFormKey;

  // controllers
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  // password visiability
  bool _visiblePassword = false;
  bool _visibleConfirmPassword = false;

  //API
  final respository = getIt<UserRepository>();
  ResetPasswordModel? resetPasswordModel;

  @override
  void initState() {
    _passwordFormKey = GlobalKey();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            spacing: 15.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Forget password ?", style: AppStyles.mainTitleStyle),
              Text(
                "Please Enter your New password",
                style: AppStyles.subTitleStyle,
              ),
              SizedBox(height: 25),
              Form(
                key: _passwordFormKey,
                child: Column(
                  spacing: 20.h,
                  children: [
                    passwordField(
                      _passwordController,
                      TextInputType.text,
                      "Enter Your New password",
                      _visiblePassword,
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _visiblePassword = !_visiblePassword;
                          });
                        },
                        icon: _visiblePassword
                            ? Icon(Icons.visibility_off_outlined)
                            : Icon(Icons.visibility_outlined),
                      ),
                    ),
                    // confirm password
                    passwordConfirmField(
                      _passwordController, // Checker
                      _confirmPasswordController,
                      TextInputType.text,
                      "Enter Your Confirm password",
                      _visibleConfirmPassword,
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _visibleConfirmPassword = !_visibleConfirmPassword;
                          });
                        },
                        icon: _visibleConfirmPassword
                            ? Icon(Icons.visibility_off_outlined)
                            : Icon(Icons.visibility_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 85.h),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    // valdation check
                    if (_passwordFormKey.currentState!.validate()) {
                      //API of reset password
                      try {
                        final response = await respository.resetPassword(
                          CacheHelper()
                              .getDataString(key: ApiKey.role)
                              .toString(),
                          CacheHelper()
                              .getDataString(key: ApiKey.email)
                              .toString(),
                          widget.otpCode,
                          _passwordController.text,
                          _confirmPasswordController.text,
                        );

                        resetPasswordModel = response;
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text(
                              resetPasswordModel!.message,
                              style: AppStyles.snackBarStyle,
                            ),
                          ),
                        );
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LogIn()),
                          (route) => false,
                        );
                      } on ServerException catch (e) {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text(
                              e.errormodel.message,
                              style: AppStyles.snackBarStyle,
                            ),
                          ),
                        );
                      }
                    }
                  },
                  child: Text("Confirm", style: AppStyles.whiteTextButtonStyle),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
