import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/user/cubit/user_profile_cubit.dart';
import 'package:dx/Social-Media/user/models/user_profile_model.dart';

class UserEditBottomSheet extends StatefulWidget {
  const UserEditBottomSheet({super.key, required this.profile});

  final UserProfileModel profile;

  @override
  State<UserEditBottomSheet> createState() => _UserEditBottomSheetState();
}

class _UserEditBottomSheetState extends State<UserEditBottomSheet> {
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _phoneCtrl;
  String? _selectedGender;

  static const _genders = ['MALE', 'FEMALE', 'OTHER'];

  @override
  void initState() {
    super.initState();
    _usernameCtrl = TextEditingController(text: widget.profile.username);
    _firstNameCtrl = TextEditingController(text: widget.profile.firstName ?? '');
    _lastNameCtrl = TextEditingController(text: widget.profile.lastName ?? '');
    _bioCtrl = TextEditingController(text: widget.profile.bio ?? '');
    _phoneCtrl = TextEditingController(text: widget.profile.phoneNumber ?? '');
    _selectedGender = widget.profile.gender;
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _bioCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final updates = <String, dynamic>{};
    if (_usernameCtrl.text.trim().isNotEmpty) {
      updates['username'] = _usernameCtrl.text.trim();
    }
    if (_firstNameCtrl.text.trim().isNotEmpty) {
      updates['firstName'] = _firstNameCtrl.text.trim();
    }
    if (_lastNameCtrl.text.trim().isNotEmpty) {
      updates['lastName'] = _lastNameCtrl.text.trim();
    }
    if (_bioCtrl.text.trim().isNotEmpty) {
      updates['bio'] = _bioCtrl.text.trim();
    }
    if (_phoneCtrl.text.trim().isNotEmpty) {
      updates['phoneNumber'] = _phoneCtrl.text.trim();
    }
    if (_selectedGender != null) {
      updates['gender'] = _selectedGender;
    }
    if (updates.isNotEmpty) {
      context.read<UserProfileCubit>().updateProfile(updates);
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
              'Edit Profile',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20.h),
            _field('Username', _usernameCtrl,
                prefixIcon: Icons.alternate_email),
            SizedBox(height: 12.h),
            _field('First Name', _firstNameCtrl,
                prefixIcon: Icons.person_outline),
            SizedBox(height: 12.h),
            _field('Last Name', _lastNameCtrl,
                prefixIcon: Icons.person_outline),
            SizedBox(height: 12.h),
            _field('Bio', _bioCtrl,
                maxLines: 3, prefixIcon: Icons.notes_outlined),
            SizedBox(height: 12.h),
            _field('Phone Number', _phoneCtrl,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined),
            SizedBox(height: 12.h),
            DropdownButtonFormField<String>(
              initialValue: _selectedGender,
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey[500]),
              borderRadius: BorderRadius.circular(14.r),
              decoration: InputDecoration(
                hintText: 'Gender',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
                prefixIcon:
                    Icon(Icons.wc_outlined, color: Colors.grey[500], size: 20.r),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                contentPadding: EdgeInsetsDirectional.symmetric(
                    horizontal: 16.w, vertical: 16.h),
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
              items: _genders
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedGender = v),
            ),
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
