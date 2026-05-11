import 'package:dx/Authentication/Regestration/login.dart';
import 'package:dx/Widgets/email_form_field.dart';
import 'package:dx/Widgets/password_confirm_field.dart';
import 'package:dx/Widgets/password_form_field.dart';
import 'package:dx/core/errors/exceptions.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/Authentication/models/signupmodel.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() {
    return _SignupState();
  }
}

class _SignupState extends State<Signup> with TickerProviderStateMixin {
  late TabController tabController;
  int userType = 0;
  String _selectedRole = "USER";

  late final TextEditingController _signUpUserEmail;
  late final TextEditingController _signUpOnwerEmail;
  late final TextEditingController _userPassword;
  late final TextEditingController _userConfirmPassword;
  late final TextEditingController _ownerPaswword;
  late final TextEditingController _ownerConfirmPassword;

  final GlobalKey<FormState> _singUpFormKeyNormalUser = GlobalKey();
  final GlobalKey<FormState> _ownerFormKey = GlobalKey();

  final repository = getIt<UserRepository>();
  Signupmodel? _userSignup;

  bool _visiblePassword = false;
  bool _visibleconfirmPassword = false;
  bool _isloading = false;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {
        userType = tabController.index;
      });
      _selectedRole = userType == 0 ? "USER" : "BRAND";
    });

    _signUpUserEmail = TextEditingController();
    _userPassword = TextEditingController();
    _userConfirmPassword = TextEditingController();
    _signUpOnwerEmail = TextEditingController();
    _ownerPaswword = TextEditingController();
    _ownerConfirmPassword = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    _signUpUserEmail.dispose();
    _userPassword.dispose();
    _userConfirmPassword.dispose();
    _signUpOnwerEmail.dispose();
    _ownerPaswword.dispose();
    _ownerConfirmPassword.dispose();
    super.dispose();
  }

  Widget _buildEyeIcon(bool visible, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: 20.r,
        color: Colors.grey[500],
      ),
    );
  }

  Widget _buildSignupButton(VoidCallback onPressed) {
    return _isloading
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
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 56.h),
              backgroundColor: const Color(0xFF800020),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              elevation: 0,
            ),
            child: Text(
              "signup.signup".tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
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
              padding: EdgeInsetsDirectional.symmetric(vertical: 24.h),
              child: Column(
                children: [
                  Image.asset(
                    "images/Dx_logo.png",
                    width: 56.w,
                    height: 56.h,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "StyleHub",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "signup.sign_up".tr(),
                    style: TextStyle(
                      color: Colors.grey[400],
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
              child: Column(
                children: [
                  // Modern TabBar inside the white card
                  Padding(
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 24.w,
                      vertical: 20.h,
                    ),
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: TabBar(
                        controller: tabController,
                        indicator: BoxDecoration(
                          color: const Color(0xFF800020),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey[600],
                        labelStyle: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: TextStyle(fontSize: 14.sp),
                        tabs: [
                          Tab(text: "signup.user".tr()),
                          Tab(text: "signup.brand".tr()),
                        ],
                      ),
                    ),
                  ),

                  // Forms
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        // ── User tab ──
                        SingleChildScrollView(
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: 24.w,
                            vertical: 8.h,
                          ),
                          child: Form(
                            key: _singUpFormKeyNormalUser,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                emailFormField(_signUpUserEmail),
                                SizedBox(height: 16.h),
                                passwordField(
                                  _userPassword,
                                  _visiblePassword,
                                  _buildEyeIcon(_visiblePassword, () {
                                    setState(() {
                                      _visiblePassword = !_visiblePassword;
                                    });
                                  }),
                                ),
                                SizedBox(height: 16.h),
                                passwordConfirmField(
                                  _userPassword,
                                  _userConfirmPassword,
                                  _visibleconfirmPassword,
                                  _buildEyeIcon(_visibleconfirmPassword, () {
                                    setState(() {
                                      _visibleconfirmPassword =
                                          !_visibleconfirmPassword;
                                    });
                                  }),
                                ),
                                SizedBox(height: 28.h),
                                _buildSignupButton(() async {
                                  setState(() => _isloading = true);
                                  if (_singUpFormKeyNormalUser.currentState!
                                      .validate()) {
                                    try {
                                      final response = await repository.signup(
                                        _selectedRole,
                                        _signUpUserEmail.text,
                                        _userPassword.text,
                                        _userConfirmPassword.text,
                                      );
                                      _userSignup = response;
                                      if (!context.mounted) return;
                                      setState(() => _isloading = false);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: const Duration(seconds: 3),
                                          content: Text(
                                            _userSignup!.message,
                                            style: AppStyles.snackBarStyle,
                                          ),
                                        ),
                                      );
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => LogIn(),
                                        ),
                                        (route) => false,
                                      );
                                    } on ServerException catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration:
                                                const Duration(seconds: 3),
                                            content: Text(
                                              e.errormodel.message,
                                              style: AppStyles.snackBarStyle,
                                            ),
                                          ),
                                        );
                                      }
                                      setState(() => _isloading = false);
                                    }
                                  } else {
                                    setState(() => _isloading = false);
                                  }
                                }),
                                SizedBox(height: 20.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "login.login".tr(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding:
                                            EdgeInsetsDirectional.symmetric(
                                              horizontal: 4.w,
                                            ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) => LogIn(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      child: Text(
                                        "login.login".tr(),
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

                        // ── Brand tab ──
                        SingleChildScrollView(
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: 24.w,
                            vertical: 8.h,
                          ),
                          child: Form(
                            key: _ownerFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                emailFormField(_signUpOnwerEmail),
                                SizedBox(height: 16.h),
                                passwordField(
                                  _ownerPaswword,
                                  _visiblePassword,
                                  _buildEyeIcon(_visiblePassword, () {
                                    setState(() {
                                      _visiblePassword = !_visiblePassword;
                                    });
                                  }),
                                ),
                                SizedBox(height: 16.h),
                                passwordConfirmField(
                                  _ownerPaswword,
                                  _ownerConfirmPassword,
                                  _visibleconfirmPassword,
                                  _buildEyeIcon(_visibleconfirmPassword, () {
                                    setState(() {
                                      _visibleconfirmPassword =
                                          !_visibleconfirmPassword;
                                    });
                                  }),
                                ),
                                SizedBox(height: 28.h),
                                _buildSignupButton(() async {
                                  if (_ownerFormKey.currentState!.validate()) {
                                    try {
                                      final response = await repository.signup(
                                        _selectedRole,
                                        _signUpOnwerEmail.text,
                                        _ownerPaswword.text,
                                        _ownerConfirmPassword.text,
                                      );
                                      _userSignup = response;
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: const Duration(seconds: 3),
                                          content: Text(
                                            _userSignup!.message,
                                            style: AppStyles.snackBarStyle,
                                          ),
                                        ),
                                      );
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => LogIn(),
                                        ),
                                        (route) => false,
                                      );
                                    } on ServerException catch (e) {
                                      setState(() => _isloading = false);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            duration:
                                                const Duration(seconds: 3),
                                            content: Text(
                                              e.errormodel.message,
                                              style: AppStyles.snackBarStyle,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                }),
                                SizedBox(height: 20.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "login.login".tr(),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding:
                                            EdgeInsetsDirectional.symmetric(
                                              horizontal: 4.w,
                                            ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) => LogIn(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      child: Text(
                                        "login.login".tr(),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
