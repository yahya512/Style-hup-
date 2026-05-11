import 'package:dx/Authentication/Regestration/brand_complete_profile.dart';
import 'package:dx/Authentication/Regestration/signup.dart';

import 'package:dx/Authentication/Regestration/user_complete_profile.dart';
import 'package:dx/Social-Media/shared/screens/main_layout.dart';
import 'package:dx/Widgets/email_form_field.dart';
import 'package:dx/Widgets/password_form_field.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/core/errors/exceptions.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/Authentication/models/loginmodel.dart';
import 'package:dx/Authentication/models/user_date_model.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dx/Authentication/ForgetPsssword/forgetpasswordone.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});
  @override
  State<LogIn> createState() {
    return _LogInState();
  }
}

class _LogInState extends State<LogIn> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late GlobalKey<FormState> _formKey;
  final repository = getIt<UserRepository>();
  LoginModel? _userLogIn; // receive the response

  // receive userdata[email , id , isProfileComplete]
  Usermodel? userData;
  bool _visiblePassword = false;
  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _formKey = GlobalKey();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF800020),
      body: Column(
        children: [
          // ── Dark header ──
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(vertical: 32.h),
              child: Column(
                children: [
                  Image.asset(
                    "images/Dx_logo.png",
                    width: 64.w,
                    height: 64.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "StyleHub",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "login.welcome_back".tr(),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── White form card ──
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
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 24.w,
                  vertical: 32.h,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "login.login".tr(),
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF800020),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "login.dont_have_account".tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                      SizedBox(height: 28.h),

                      // Email
                      emailFormField(emailController),
                      SizedBox(height: 16.h),

                      // Password
                      passwordField(
                        passwordController,
                        _visiblePassword,
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _visiblePassword = !_visiblePassword;
                            });
                          },
                          icon: Icon(
                            _visiblePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20.r,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),

                      // Forgot password
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ForgetpasswordOne(),
                              ),
                            );
                          },
                          child: Text(
                            "login.forget_password".tr(),
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF800020),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Login button
                      _isloading
                          ? Center(
                              child: SizedBox(
                                width: 40.w,
                                height: 40.h,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Color(0xFF800020),
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => _isloading = true);
                                  try {
                                    final response = await repository.login(
                                      emailController.text,
                                      passwordController.text,
                                    );
                                    _userLogIn = response;

                                    CacheHelper().saveData(
                                      key: ApiKey.accessToken,
                                      value: _userLogIn!.accessToken,
                                    );
                                    CacheHelper().saveData(
                                      key: ApiKey.refreshToken,
                                      value: _userLogIn!.refreshToken,
                                    );

                                    userData = Usermodel.fromJson(
                                      _userLogIn?.user ?? {},
                                    );
                                    if (userData != null) {
                                      CacheHelper().saveData(
                                        key: ApiKey.role,
                                        value: userData!.role,
                                      );
                                      CacheHelper().saveData(
                                        key: ApiKey.email,
                                        value: userData!.email,
                                      );
                                      CacheHelper().saveData(
                                        key: ApiKey.userId,
                                        value: userData!.id,
                                      );
                                    }

                                    if (!context.mounted) return;
                                    setState(() => _isloading = false);

                                    if (userData?.isProfileComplete == true) {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MainLayout(),
                                        ),
                                        (_) => false,
                                      );
                                    } else if (userData?.role == "USER") {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              UserCompleteProfile(),
                                        ),
                                      );
                                    } else {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BrandCompleteProfile(),
                                        ),
                                      );
                                    }
                                  } on ServerException catch (e) {
                                    if (!context.mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          e.errormodel.message,
                                          style: AppStyles.snackBarStyle,
                                        ),
                                      ),
                                    );
                                    setState(() {
                                      _isloading = false;
                                      if (kDebugMode) {
                                        print(
                                          "message: ${e.errormodel.message}",
                                        );
                                        print("error: ${e.errormodel.error}");
                                        print("status: ${e.errormodel.status}");
                                      }
                                    });
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 56.h),
                                backgroundColor: const Color(0xFF800020),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                "login.login".tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                      SizedBox(height: 24.h),

                      // Sign up row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "login.dont_have_account".tr(),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsetsDirectional.symmetric(
                                horizontal: 4.w,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Signup(),
                                ),
                              );
                            },
                            child: Text(
                              "login.signup".tr(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF800020),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
