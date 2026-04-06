// ignore_for_file: avoid_print

import 'package:dx/Authentication/Regestration/brand_complete_profile.dart';
import 'package:dx/Authentication/Regestration/signup.dart';
import 'package:dx/Authentication/Regestration/user_complete_profile.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 20.w),
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
              Text("Login", style: AppStyles.mainTitleStyle),
              SizedBox(height: 10.h),
              Text("Welcome back!", style: AppStyles.mainTitleStyle),
              SizedBox(height: 10.h),
              Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 32.h),
                  padding: EdgeInsets.all(15.r),
                  child: Column(
                    children: [
                      DropdownButtonFormField(
                        hint: Text(
                          "select Your Role",
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
                          DropdownMenuItem(value: "USER", child: Text("User")),
                          DropdownMenuItem(
                            value: "BRAND",
                            child: Text("Brand"),
                          ),
                        ],
                        onChanged: (value) {
                          _selectRole = value;
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Required field Please select your gender ";
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
                        TextInputType.visiblePassword,
                        "Enter Your Password",
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
                          "Forget Password?",
                          style: AppStyles.normalTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                                if (userData?.isProfileComplete == false) {
                                  if (userData?.role == "USER") {
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
                                }

                                setState(() {
                                  _isloading = false;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text(
                                      "Validated data",
                                      style: AppStyles.snackBarStyle,
                                    ),
                                  ),
                                );
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
                                  print(
                                    "message FromAPI  : ${e.errormodel.message}",
                                  );
                                  print(
                                    "error FromAPI : ${e.errormodel.error}",
                                  );
                                  print(
                                    "Status FromAPI : ${e.errormodel.status}",
                                  );
                                });
                              }
                            }
                          },
                          style: AppStyles.elevatedButtonStyle,
                          child: Text(
                            "Login",
                            style: AppStyles.whiteTextButtonStyle,
                          ),
                        ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 15.sp),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Signup()),
                        );
                      },
                      child: Text("Signup", style: AppStyles.normalTextStyle),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
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
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        "Or",
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Image.asset(
                            alignment: Alignment.centerLeft,
                            "images/google logo.png",
                            width: 30.w,
                            height: 30.h,
                          ),
                          style: AppStyles.googleElevatedButtonStyle,
                          label: Text(
                            "Login with Google",
                            maxLines: 1,
                            style: AppStyles.greyTextButtonStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
