import 'package:dx/Authentication/Regestration/brand_complete_profile.dart';
import 'package:dx/Authentication/Regestration/signup.dart';
import 'package:dx/Authentication/Regestration/user_complete_profile.dart';
import 'package:dx/Social-Media/shared/screens/main_layout.dart';
import 'package:dx/Widgets/email_form_field.dart';
import 'package:dx/Widgets/login_with_google.dart';
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

  // receive userdata[role , email , id , isProfileComplete]
  Usermodel? userData;
  String? _selectRole;
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
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
            child: Image.asset(
              width: 50.w,
              height: 50.h,
              "images/Dx_logo.png",
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text("login.login".tr(), style: AppStyles.mainTitleStyle),
              SizedBox(height: 10.h),
              Text("login.welcome_back".tr(), style: AppStyles.mainTitleStyle),
              SizedBox(height: 10.h),
              Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsetsDirectional.symmetric(vertical: 32.h),
                  padding: EdgeInsetsDirectional.all(15.r),
                  child: Column(
                    children: [
                      DropdownButtonFormField(
                        hint: Text(
                          "login.select_your_role".tr(),
                          style: AppStyles.labelTextStyle,
                        ),
                        decoration: InputDecoration(
                          border: AppStyles.outlineInputBorderstyle,
                          focusedBorder: AppStyles.foucasedoutlineInputBorder,
                          errorBorder: AppStyles.errorBorder,
                          focusedErrorBorder: AppStyles.errorBorder,
                        ),
                        initialValue: _selectRole,
                        items: [
                          DropdownMenuItem(
                            value: "USER",
                            child: Text("login.user".tr()),
                          ),
                          DropdownMenuItem(
                            value: "BRAND",
                            child: Text("login.brand".tr()),
                          ),
                        ],
                        onChanged: (value) {
                          _selectRole = value;
                        },
                        validator: (value) {
                          if (value == null) {
                            return "login.required_field_gender".tr();
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),

                      // email address
                      emailFormField(emailController),

                      SizedBox(height: 20.h),

                      // PassWord
                      passwordField(
                        passwordController,
                        _visiblePassword,
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _visiblePassword = !_visiblePassword;
                            });
                          },
                          icon: _visiblePassword
                              ? Icon(Icons.visibility_off_outlined, size: 24.r)
                              : Icon(Icons.visibility_outlined, size: 24.r),
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ForgetpasswordOne(),
                            ),
                          );
                        },
                        child: Text(
                          "login.forget_password".tr(),
                          style: AppStyles.normalTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                child: SizedBox(
                  width: double.infinity,
                  child: _isloading
                      ? Center(
                          child: SizedBox(
                            width: 40.w,
                            height: 40.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isloading = true;
                              });

                              // API Log in
                              try {
                                final response = await repository.login(
                                  _selectRole,
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

                                // receive userinfo
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
                                }

                                if (!context.mounted) return;
                                setState(() {
                                  _isloading = false;
                                });

<<<<<<< HEAD
                                if (userData?.isProfileComplete == true) {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const MainLayout(),
=======
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text(
                                      "login.validated_data".tr(),
                                      style: AppStyles.snackBarStyle,
>>>>>>> 6d4e055 (Apply En - Ar language , add Setting screen in Ecommerce UI)
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
                                      "message FromAPI  : ${e.errormodel.message}",
                                    );
                                    print(
                                      "error FromAPI : ${e.errormodel.error}",
                                    );
                                    print(
                                      "Status FromAPI : ${e.errormodel.status}",
                                    );
                                  }
                                });
                              }
                            }
                          },
                          style: AppStyles.elevatedButtonStyle,
                          child: Text(
                            "login.login".tr(),
                            style: AppStyles.whiteTextButtonStyle,
                          ),
                        ),
                ),
              ),
              Container(
                margin: EdgeInsetsDirectional.symmetric(vertical: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "login.dont_have_account".tr(),
                      style: TextStyle(fontSize: 15.sp),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 2.w,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Signup()),
                        );
                      },
                      child: Text(
                        "login.signup".tr(),
                        style: AppStyles.normalTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 20.w,
                  vertical: 15.h,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1.h,
                        height: 60.h,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 10.w,
                      ),
                      child: Text(
                        "login.or".tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.black, thickness: 1.h),
                    ),
                  ],
                ),
              ),

              // Login with Google
              gooleLogIn(),
            ],
          ),
        ),
      ),
    );
  }
}
