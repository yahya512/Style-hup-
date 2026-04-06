import 'dart:io';
import 'package:dx/Authentication/models/brand_complete_profile_model.dart';
import 'package:dx/Widgets/brand_information_filed.dart';
import 'package:dx/core/errors/exceptions.dart';
import 'package:dx/core/functions/upload_image_to_api.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class BrandCompleteProfile extends StatefulWidget {
  const BrandCompleteProfile({super.key});
  @override
  State<BrandCompleteProfile> createState() {
    return _BrandCompelteProfileState();
  }
}

class _BrandCompelteProfileState extends State<BrandCompleteProfile> {
  // private for this form
  final GlobalKey<FormState> _brandFormKey = GlobalKey();
  //barnd Data
  late final TextEditingController _brandUserName;
  late final TextEditingController _brandphone;
  late final TextEditingController _brandName;
  late final TextEditingController _brandDomain;
  late final TextEditingController _brandDescription;

  // for brand Image
  XFile? _selectedImage;

  //API
  final repository = getIt<UserRepository>();
  // ignore: unused_field
  BrandCompleteProfileModel? _brandCompleteProfile;

  @override
  void initState() {
    //brand
    _brandUserName = TextEditingController();
    _brandphone = TextEditingController();
    _brandName = TextEditingController();
    _brandDomain = TextEditingController();
    _brandDescription = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    //brand
    _brandUserName.dispose();
    _brandphone.dispose();
    _brandName.dispose();
    _brandDomain.dispose();
    _brandDescription.dispose();
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.all(20.dg),
          child: Center(
            child: Form(
              key: _brandFormKey,
              child: Column(
                spacing: 30.h,
                children: [
                  Text(
                    "Brand Complete Profile",
                    style: AppStyles.subTitleStyle,
                  ),
                  // Photo upload
                  GestureDetector(
                    onTap: () async {
                      _selectedImage = await pickImage(context);
                      setState(() {
                        // _selectedImage;
                      });
                    },
                    child: Container(
                      height: 150.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: _selectedImage == null
                          // if no photo selected
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    "Enter to Choose Photo",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          //if there photo selected
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.file(
                                File(_selectedImage!.path),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                    ),
                  ),

                  //brand user Name
                  brandInfo(
                    _brandUserName,
                    "Enter Your user name",
                    keyboardType: TextInputType.name,
                  ),

                  //phone number
                  brandInfo(
                    _brandphone,
                    "Enter your phone number",
                    keyboardType: TextInputType.phone,
                  ),

                  // Brand Name
                  brandInfo(
                    _brandName,
                    "Enter Your Brand name",
                    keyboardType: TextInputType.name,
                  ),

                  //Brand Domain
                  brandInfo(
                    _brandDomain,
                    "Enter Your Brand Domain",
                    keyboardType: TextInputType.name,
                  ),

                  //Brand Description
                  brandInfo(
                    _brandDescription,
                    "Enter Your Description",
                    keyboardType: TextInputType.text,
                    maxLines: 2,
                  ),

                  // confirm Button
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 14.w),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_brandFormKey.currentState!.validate()) {
                            if (_selectedImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 2),
                                  dismissDirection: DismissDirection.horizontal,
                                  content: Text(
                                    "You Must Choose a Photo to Complete Info",
                                    style: AppStyles.snackBarStyle,
                                  ),
                                ),
                              );
                              return;
                            }
                            try {
                              await repository.imageupload(_selectedImage);
                              final response = await repository
                                  .brandCompleteProfile(
                                    _brandUserName.text,
                                    _brandphone.text,
                                    _brandName.text,
                                    _brandDomain.text,
                                    _brandDescription.text,
                                  );
                              _brandCompleteProfile = response;
                            } on ServerException catch (e) {
                              if (context.mounted) {
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
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 1),
                                content: Text(
                                  "Validated data",
                                  style: AppStyles.snackBarStyle,
                                ),
                              ),
                            );
                          }
                        },
                        style: AppStyles.elevatedButtonStyle,
                        child: Text(
                          "Confirm",
                          style: AppStyles.whiteTextButtonStyle,
                        ),
                      ),
                    ),
                  ),

                  // Login with Google
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: Image.asset(
                                "images/google logo.png",
                                width: 30.w,
                                height: 30.h,
                              ),
                              style: AppStyles.googleElevatedButtonStyle,
                              label: Text(
                                "Login with Google",
                                style: AppStyles.greyTextButtonStyle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(height: 10.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
