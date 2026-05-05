import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/user/cubit/user_profile_cubit.dart';
import 'package:dx/Social-Media/user/models/user_profile_model.dart';
import 'package:dx/core/theme/appstyles.dart';

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
            Text('Edit Profile', style: AppStyles.mainTitleStyle),
            SizedBox(height: 20.h),
            _field('Username', _usernameCtrl),
            SizedBox(height: 12.h),
            _field('First Name', _firstNameCtrl),
            SizedBox(height: 12.h),
            _field('Last Name', _lastNameCtrl),
            SizedBox(height: 12.h),
            _field('Bio', _bioCtrl, maxLines: 3),
            SizedBox(height: 12.h),
            _field('Phone Number', _phoneCtrl,
                keyboardType: TextInputType.phone),
            SizedBox(height: 12.h),
            DropdownButtonFormField<String>(
              initialValue: _selectedGender,
              decoration: InputDecoration(
                labelText: 'Gender',
                labelStyle: AppStyles.labelTextStyle,
                border: AppStyles.outlineInputBorderstyle,
                focusedBorder: AppStyles.foucasedoutlineInputBorder,
              ),
              items: _genders
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedGender = v),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: AppStyles.elevatedButtonStyle,
                child: Text('Save', style: AppStyles.whiteTextButtonStyle),
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
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppStyles.labelTextStyle,
        border: AppStyles.outlineInputBorderstyle,
        focusedBorder: AppStyles.foucasedoutlineInputBorder,
      ),
    );
  }
}
