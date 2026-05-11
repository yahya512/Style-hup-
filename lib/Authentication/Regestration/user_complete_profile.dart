import 'package:dx/Authentication/models/user_complete_profile_model.dart';
import 'package:dx/Social-Media/shared/screens/main_layout.dart';
import 'package:dx/Widgets/user_complete_profile_field.dart';
import 'package:dx/core/errors/exceptions.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserCompleteProfile extends StatefulWidget {
  const UserCompleteProfile({super.key});
  @override
  State<UserCompleteProfile> createState() {
    return _UserProfileState();
  }
}

class _UserProfileState extends State<UserCompleteProfile> {
  // form Key
  final GlobalKey<FormState> userCompleteForm = GlobalKey();
  // data fields
  late final TextEditingController _userName;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _phone;
  late final TextEditingController _bio;
  //gender
  String? _selectgender;

  bool _isLoading = false;

  // API
  final repository = getIt<UserRepository>();
  // ignore: unused_field
  UserCompleteProfileModel? _userRespone;
  @override
  void initState() {
    super.initState();
    _userName = TextEditingController();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _phone = TextEditingController();
    _bio = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _userName.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    _bio.dispose();
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      hintText: "Select your gender",
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
      prefixIcon: Icon(Icons.wc_outlined, color: Colors.grey[500], size: 20.r),
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding: EdgeInsetsDirectional.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: const Color(0xFF800020), width: 1.5.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: Colors.red, width: 1.5.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: Colors.red, width: 1.5.w),
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
                    "Complete Your Profile",
                    style: TextStyle(color: Colors.grey[400], fontSize: 13.sp),
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
                  vertical: 28.h,
                ),
                child: Form(
                  key: userCompleteForm,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "User Profile",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF800020),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Tell us a bit about yourself",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      userCompleteProfile(
                        "Username",
                        TextInputType.name,
                        _userName,
                        prefixIconData: Icons.alternate_email,
                      ),
                      SizedBox(height: 16.h),

                      userCompleteProfile(
                        "First name",
                        TextInputType.name,
                        _firstName,
                        prefixIconData: Icons.person_outline,
                      ),
                      SizedBox(height: 16.h),

                      userCompleteProfile(
                        "Last name",
                        TextInputType.name,
                        _lastName,
                        prefixIconData: Icons.person_outline,
                      ),
                      SizedBox(height: 16.h),

                      userCompleteProfile(
                        "Phone number",
                        TextInputType.phone,
                        _phone,
                        prefixIconData: Icons.phone_outlined,
                      ),
                      SizedBox(height: 16.h),

                      userCompleteProfile(
                        "Bio",
                        TextInputType.text,
                        _bio,
                        prefixIconData: Icons.notes_outlined,
                        maxLines: 3,
                      ),
                      SizedBox(height: 16.h),

                      DropdownButtonFormField<String>(
                        hint: Text(
                          "Select your gender",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14.sp,
                          ),
                        ),
                        decoration: _dropdownDecoration(),
                        initialValue: _selectgender,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey[500],
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                        items: const [
                          DropdownMenuItem<String>(
                            value: "MALE",
                            child: Text("Male"),
                          ),
                          DropdownMenuItem<String>(
                            value: "FEMALE",
                            child: Text("Female"),
                          ),
                        ],
                        onChanged: (newvalue) {
                          setState(() => _selectgender = newvalue);
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Please select your gender";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 28.h),

                      _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF800020),
                                strokeWidth: 3,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                if (userCompleteForm.currentState!.validate()) {
                                  setState(() => _isLoading = true);
                                  try {
                                    final response =
                                        await repository.userCompleteProfile(
                                      _userName.text,
                                      _firstName.text,
                                      _lastName.text,
                                      _phone.text,
                                      _bio.text,
                                      _selectgender!,
                                    );
                                    _userRespone = response;
                                    if (!context.mounted) return;
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (_) => const MainLayout(),
                                      ),
                                      (route) => false,
                                    );
                                  } on ServerException catch (e) {
                                    setState(() => _isLoading = false);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          duration: const Duration(seconds: 3),
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
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 56.h),
                                backgroundColor: const Color(0xFF800020),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                "Confirm",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                      SizedBox(height: 16.h),
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
