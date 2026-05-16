import 'dart:io';
import 'package:dx/Authentication/models/brand_complete_profile_model.dart';
import 'package:dx/Social-Media/shared/screens/main_layout.dart';
import 'package:dx/Widgets/brand_information_filed.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';
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
                    "Complete Your Brand Profile",
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
                  key: _brandFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Brand Profile",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF800020),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "Set up your brand presence",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // ── Photo picker ──
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            _selectedImage = await pickImage(context);
                            setState(() {});
                          },
                          child: Container(
                            width: 110.w,
                            height: 110.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1.5,
                              ),
                            ),
                            child: _selectedImage == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo_outlined,
                                        size: 32.r,
                                        color: Colors.grey[400],
                                      ),
                                      SizedBox(height: 6.h),
                                      Text(
                                        "Add Logo",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(18.r),
                                    child: Image.file(
                                      File(_selectedImage!.path),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      brandInfo(
                        _brandUserName,
                        "Username",
                        keyboardType: TextInputType.name,
                        prefixIconData: Icons.alternate_email,
                      ),
                      SizedBox(height: 16.h),

                      brandInfo(
                        _brandphone,
                        "Phone number",
                        keyboardType: TextInputType.phone,
                        prefixIconData: Icons.phone_outlined,
                      ),
                      SizedBox(height: 16.h),

                      brandInfo(
                        _brandName,
                        "Brand name",
                        keyboardType: TextInputType.name,
                        prefixIconData: Icons.storefront_outlined,
                      ),
                      SizedBox(height: 16.h),

                      brandInfo(
                        _brandDomain,
                        "Brand domain",
                        keyboardType: TextInputType.name,
                        prefixIconData: Icons.language_outlined,
                      ),
                      SizedBox(height: 16.h),

                      brandInfo(
                        _brandDescription,
                        "Brand description",
                        keyboardType: TextInputType.text,
                        prefixIconData: Icons.notes_outlined,
                        maxLines: 3,
                      ),
                      SizedBox(height: 28.h),

                      // ── Confirm button ──
                      ElevatedButton(
                        onPressed: () async {
                          if (_brandFormKey.currentState!.validate()) {
                            if (_selectedImage == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 2),
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
                              final response =
                                  await repository.brandCompleteProfile(
                                _brandUserName.text,
                                _brandphone.text,
                                _brandName.text,
                                _brandDomain.text,
                                _brandDescription.text,
                              );
                              _brandCompleteProfile = response;
                              CacheHelper().saveData(
                                  key: ApiKey.baseUserId,
                                  value: _brandCompleteProfile!.baseUserId);
                              try {
                                await repository.imageupload(_selectedImage);
                              } on ServerException catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 3),
                                    content: Text(
                                      e.errormodel.message,
                                      style: AppStyles.snackBarStyle,
                                    ),
                                  ),
                                );
                                return;
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 1),
                                    content: Text(
                                      "Image upload failed. Please try again.",
                                      style: AppStyles.snackBarStyle,
                                    ),
                                  ),
                                );
                                return;
                              }
                              if (!context.mounted) return;
                              CacheHelper().saveData(
                                key: ApiKey.id,
                                value: _brandCompleteProfile!.baseUserId,
                              );
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const MainLayout(),
                                ),
                                (route) => false,
                              );
                            } on ServerException catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
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
