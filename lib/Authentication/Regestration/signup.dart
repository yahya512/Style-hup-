import 'package:dx/Authentication/Regestration/login.dart';
import 'package:dx/Widgets/email_form_field.dart';
import 'package:dx/Widgets/login_with_google.dart';
import 'package:dx/Widgets/password_confirm_field.dart';
import 'package:dx/Widgets/password_form_field.dart';
import 'package:dx/core/errors/exceptions.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/Authentication/models/signupmodel.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});
  @override
  State<Signup> createState() {
    return _SignupState();
  }
}

// TickerProviderStateMixin => for use tabController for tabBar (User , Brand)
class _SignupState extends State<Signup> with TickerProviderStateMixin {
  // for tabviewr
  late TabController tabController;
  // manage user role
  int userType = 0;
  String _selectedRole = "USER";

  //for email field
  late final TextEditingController _signUpUserEmail;
  late final TextEditingController _signUpOnwerEmail;

  // for password field
  late final TextEditingController _userPassword;
  late final TextEditingController _userConfirmPassword;
  late final TextEditingController _ownerPaswword;
  late final TextEditingController _ownerConfirmPassword;

  // private for this form
  final GlobalKey<FormState> _singUpFormKeyNormalUser = GlobalKey();
  final GlobalKey<FormState> _ownerFormKey = GlobalKey();

  //API
  final repository = getIt<UserRepository>();
  Signupmodel? _userSignup;

  //Passwords
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

    //User
    _signUpUserEmail = TextEditingController();
    _userPassword = TextEditingController();
    _userConfirmPassword = TextEditingController();

    //Owner
    _signUpOnwerEmail = TextEditingController();
    _ownerPaswword = TextEditingController();
    _ownerConfirmPassword = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    //user
    _signUpUserEmail.dispose();
    _userPassword.dispose();
    _userConfirmPassword.dispose();
    //owner
    _signUpOnwerEmail.dispose();
    _ownerPaswword.dispose();
    _ownerConfirmPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w),
            child: Image.asset(
              width: 50.w,
              height: 50.h,
              "images/Dx_logo.png",
              fit: BoxFit.cover,
            ),
          ),
        ],
        bottom: TabBar(
          indicatorPadding: EdgeInsetsGeometry.symmetric(horizontal: 0.h),
          indicatorColor: Colors.black,
          onTap: (value) {},
          labelColor: Colors.white,
          controller: tabController,
          tabs: [
            Tab(child: Text("User", style: AppStyles.mainTitleStyle)),
            Tab(child: Text("Brand", style: AppStyles.mainTitleStyle)),
          ],
        ),
      ),

      body: Container(
        padding: EdgeInsets.all(10.dg),
        child: TabBarView(
          controller: tabController,
          children: [
            // User
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20.dg),
                child: Center(
                  child: Form(
                    //Form Key
                    key: _singUpFormKeyNormalUser,
                    child: Column(
                      spacing: 50.h,
                      children: [
                        Text("Sign up", style: AppStyles.subTitleStyle),

                        //Email Field
                        emailFormField(_signUpUserEmail),

                        // Password Field
                        passwordField(
                          _userPassword,
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

                        // Confirm Password
                        passwordConfirmField(
                          _userPassword, //Checker
                          _userConfirmPassword,
                          _visibleconfirmPassword,
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _visibleconfirmPassword =
                                    !_visibleconfirmPassword;
                              });
                            },
                            icon: _visibleconfirmPassword
                                ? Icon(Icons.visibility_off_outlined)
                                : Icon(Icons.visibility_outlined),
                          ),
                        ),

                        // Sign UP Button
                        SizedBox(
                          width: double.infinity,
                          child: _isloading
                              ? Center(
                                  child: SizedBox(
                                    width: 40.w,
                                    height: 40.h,
                                    child: CircularProgressIndicator(
                                      color: Colors.blue,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isloading = true;
                                    });
                                    // print("UserRoleType :$userType");
                                    // print("Role : $_selectedRole");
                                    // print("$_checkPassword \n $_confirmPassword");
                                    if (_singUpFormKeyNormalUser.currentState!
                                        .validate()) {
                                      try {
                                        final response = await repository
                                            .signup(
                                              _selectedRole,
                                              _signUpUserEmail.text,
                                              _userPassword.text,
                                              _userConfirmPassword.text,
                                            );
                                        _userSignup = response;
                                        if (!context.mounted) return;

                                        setState(() {
                                          _isloading = false;
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            duration: Duration(seconds: 3),
                                            content: Text(
                                              _userSignup!.message,
                                              style: AppStyles.snackBarStyle,
                                            ),
                                          ),
                                        );
                                        // print(
                                        //   "***********  Before Navigator ************",
                                        // );
                                        Navigator.of(
                                          context,
                                        ).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) => LogIn(),
                                          ),
                                          (route) => false,
                                        );
                                      } on ServerException catch (e) {
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              duration: Duration(seconds: 3),
                                              content: Text(
                                                e.errormodel.message,
                                                style: AppStyles.snackBarStyle,
                                              ),
                                            ),
                                          );
                                        }
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
                                    } else {
                                      setState(() {
                                        _isloading = false;
                                      });
                                    }
                                  },
                                  style: AppStyles.elevatedButtonStyle,
                                  child: Text(
                                    "Signup",
                                    style: AppStyles.whiteTextButtonStyle,
                                  ),
                                ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Text(
                                  "Or",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // login with Google
                        gooleLogIn(),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            //===============================================  Brand Sign UP  ===========================================

            //OWNER INFO
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20.dg),
                child: Center(
                  child: Form(
                    //Form Key
                    key: _ownerFormKey,
                    child: Column(
                      spacing: 50.h,
                      children: [
                        Text("Sign up", style: AppStyles.subTitleStyle),

                        //Owner Email Field
                        emailFormField(_signUpOnwerEmail),

                        passwordField(
                          _ownerPaswword,
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

                        //Owner Confirm Password
                        passwordConfirmField(
                          _ownerPaswword,
                          _ownerConfirmPassword,
                          _visibleconfirmPassword,
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _visibleconfirmPassword =
                                    !_visibleconfirmPassword;
                              });
                            },
                            icon: _visibleconfirmPassword
                                ? Icon(Icons.visibility_off_outlined)
                                : Icon(Icons.visibility_outlined),
                          ),
                        ),

                        SizedBox(
                          width: double.infinity,
                          child: _isloading
                              ? Center(
                                  child: SizedBox(
                                    width: 40.w,
                                    height: 40.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.blue,
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    // print("BrandRoleType :$userType");
                                    // print("Role : $_selectedRole");
                                    // print("$_checkPassword \n $_confirmPassword");
                                    if (_ownerFormKey.currentState!
                                        .validate()) {
                                      try {
                                        final response = await repository
                                            .signup(
                                              _selectedRole,
                                              _signUpOnwerEmail.text,
                                              _ownerPaswword.text,
                                              _ownerConfirmPassword.text,
                                            );
                                        _userSignup = response;
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            duration: Duration(seconds: 3),
                                            content: Text(
                                              _userSignup!.message,
                                              style: AppStyles.snackBarStyle,
                                            ),
                                          ),
                                        );

                                        Navigator.of(
                                          context,
                                        ).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) => LogIn(),
                                          ),
                                          (route) => false,
                                        );
                                      } on ServerException catch (e) {
                                        setState(() {
                                          _isloading = false;
                                        });
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
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
                                    }
                                  },
                                  style: AppStyles.elevatedButtonStyle,
                                  child: Text(
                                    "Sign Up",
                                    style: AppStyles.whiteTextButtonStyle,
                                  ),
                                ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Text(
                                  "Or",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Login with Google
                        gooleLogIn(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
