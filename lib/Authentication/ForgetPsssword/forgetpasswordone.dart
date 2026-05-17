import 'package:dx/Authentication/ForgetPsssword/forgetpassordtwo.dart';
import 'package:dx/Authentication/models/forget_password_model.dart';
import 'package:dx/Widgets/email_form_field.dart';
import 'package:dx/core/errors/exceptions.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const _primary = Color(0xFF800020);

class ForgetpasswordOne extends StatefulWidget {
  const ForgetpasswordOne({super.key});
  @override
  State<ForgetpasswordOne> createState() => _ForgetpasswordOneState();
}

class _ForgetpasswordOneState extends State<ForgetpasswordOne> {
  late final GlobalKey<FormState> _emailFormKey;
  late TextEditingController userEmail;
  final repository = getIt<UserRepository>();
  ForgetPasswordModel? forgetPasswordModel;
  bool _isLoading = false;

  @override
  void initState() {
    _emailFormKey = GlobalKey();
    userEmail = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    userEmail.dispose();
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
                    "forget_password.subtitle".tr(),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13.sp,
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
                  key: _emailFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "forget_password.title".tr(),
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: _primary,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      emailFormField(userEmail),
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
                                  if (_emailFormKey.currentState!.validate()) {
                                    _emailFormKey.currentState!.save();
                                    setState(() => _isLoading = true);
                                    try {
                                      final response =
                                          await repository.forgetPassword(
                                        userEmail.text.trim(),
                                      );
                                      forgetPasswordModel = response;
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            forgetPasswordModel!.message,
                                            style: AppStyles.snackBarStyle,
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ForgetpassordTwo(
                                            emailUser: userEmail.text.trim(),
                                          ),
                                        ),
                                      );
                                    } on ServerException catch (e) {
                                      if (context.mounted) {
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
                                      }
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
                                  "forget_password.send_code".tr(),
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
