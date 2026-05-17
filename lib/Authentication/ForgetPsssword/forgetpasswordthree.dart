import 'package:dx/Authentication/Regestration/login.dart';
import 'package:dx/Authentication/models/reset_password_model.dart';
import 'package:dx/Widgets/password_confirm_field.dart';
import 'package:dx/Widgets/password_form_field.dart';
import 'package:dx/core/errors/exceptions.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _primary = Color(0xFF800020);

class ForgetpassordThree extends StatefulWidget {
  final String otpCode;
  final String emailUser;
  const ForgetpassordThree({
    super.key,
    required this.otpCode,
    required this.emailUser,
  });
  @override
  State<StatefulWidget> createState() => _ForgetpasswordThreeState();
}

class _ForgetpasswordThreeState extends State<ForgetpassordThree> {
  late final GlobalKey<FormState> _passwordFormKey;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _visiblePassword = false;
  bool _visibleConfirmPassword = false;
  bool _isLoading = false;

  final repository = getIt<UserRepository>();
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
                  Text(
                    "forget_password.enter_new_password".tr(),
                    style: TextStyle(color: Colors.white70, fontSize: 13.sp),
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
                  key: _passwordFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "forget_password.enter_new_password".tr(),
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: _primary,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      passwordField(
                        _passwordController,
                        _visiblePassword,
                        IconButton(
                          onPressed: () => setState(
                              () => _visiblePassword = !_visiblePassword),
                          icon: Icon(
                            _visiblePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      passwordConfirmField(
                        _passwordController,
                        _confirmPasswordController,
                        _visibleConfirmPassword,
                        IconButton(
                          onPressed: () => setState(() =>
                              _visibleConfirmPassword =
                                  !_visibleConfirmPassword),
                          icon: Icon(
                            _visibleConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
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
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (_passwordFormKey.currentState!
                                      .validate()) {
                                    setState(() => _isLoading = true);
                                    try {
                                      final response =
                                          await repository.resetPassword(
                                        widget.emailUser,
                                        widget.otpCode,
                                        _passwordController.text,
                                        _confirmPasswordController.text,
                                      );
                                      resetPasswordModel = response;
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 2),
                                          content: Text(
                                            resetPasswordModel!.message,
                                            style: AppStyles.snackBarStyle,
                                          ),
                                        ),
                                      );
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => LogIn()),
                                        (route) => false,
                                      );
                                    } on ServerException catch (e) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: Text(
                                            e.errormodel.message,
                                            style: AppStyles.snackBarStyle,
                                          ),
                                        ),
                                      );
                                    } finally {
                                      if (mounted) {
                                        setState(() => _isLoading = false);
                                      }
                                    }
                                  }
                                },
                          child: _isLoading
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "forget_password.confirm".tr(),
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
