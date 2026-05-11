import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/brand/cubit/brand_profile_cubit.dart';
import 'package:dx/Social-Media/brand/models/brand_profile_model.dart';
class BrandEditBottomSheet extends StatefulWidget {
  const BrandEditBottomSheet({super.key, required this.profile});

  final BrandProfileModel profile;

  @override
  State<BrandEditBottomSheet> createState() => _BrandEditBottomSheetState();
}

class _BrandEditBottomSheetState extends State<BrandEditBottomSheet> {
  late final TextEditingController _brandNameCtrl;
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _websiteCtrl;

  @override
  void initState() {
    super.initState();
    _brandNameCtrl = TextEditingController(text: widget.profile.brandName);
    _usernameCtrl = TextEditingController(text: widget.profile.username);
    _bioCtrl = TextEditingController(text: widget.profile.bio ?? '');
    _phoneCtrl = TextEditingController(text: widget.profile.phoneNumber ?? '');
    _websiteCtrl = TextEditingController(text: widget.profile.websiteUrl ?? '');
  }

  @override
  void dispose() {
    _brandNameCtrl.dispose();
    _usernameCtrl.dispose();
    _bioCtrl.dispose();
    _phoneCtrl.dispose();
    _websiteCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final updates = <String, dynamic>{};
    if (_brandNameCtrl.text.trim().isNotEmpty) {
      updates['brandName'] = _brandNameCtrl.text.trim();
    }
    if (_usernameCtrl.text.trim().isNotEmpty) {
      updates['username'] = _usernameCtrl.text.trim();
    }
    if (_bioCtrl.text.trim().isNotEmpty) {
      updates['bio'] = _bioCtrl.text.trim();
    }
    if (_phoneCtrl.text.trim().isNotEmpty) {
      updates['phoneNumber'] = _phoneCtrl.text.trim();
    }
    if (_websiteCtrl.text.trim().isNotEmpty) {
      updates['websiteUrl'] = _websiteCtrl.text.trim();
    }
    if (updates.isNotEmpty) {
      context.read<BrandProfileCubit>().updateProfile(updates);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Edit Brand Profile',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.h),
            _field('Brand Name', _brandNameCtrl,
                prefixIcon: Icons.storefront_outlined),
            SizedBox(height: 12.h),
            _field('Username', _usernameCtrl,
                prefixIcon: Icons.alternate_email),
            SizedBox(height: 12.h),
            _field('Bio', _bioCtrl,
                maxLines: 3, prefixIcon: Icons.notes_outlined),
            SizedBox(height: 12.h),
            _field('Phone Number', _phoneCtrl,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined),
            SizedBox(height: 12.h),
            _field('Website URL', _websiteCtrl,
                keyboardType: TextInputType.url,
                prefixIcon: Icons.language_outlined),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 52.h),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r)),
                elevation: 0,
              ),
              child: Text(
                'Save',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    IconData prefixIcon = Icons.edit_outlined,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
        prefixIcon: Icon(prefixIcon, color: Colors.grey[500], size: 20.r),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding:
            EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14.r),
            borderSide: BorderSide(color: Colors.black, width: 1.5.w)),
      ),
    );
  }
}
