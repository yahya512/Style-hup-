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

  // API
  final repository = getIt<UserRepository>();
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
          padding: EdgeInsets.all(20.dg),
          child: Center(
            child: Form(
              key: userCompleteForm,
              child: Column(
                spacing: 30.h,
                children: [
                  Text("User Complete Profile", style: AppStyles.subTitleStyle),

                  // userName
                  userCompleteProfile(
                    "User name ",
                    TextInputType.name,
                    _userName,
                  ),

                  //  FirstName
                  userCompleteProfile(
                    "First name",
                    TextInputType.name,
                    _firstName,
                  ),

                  //Last Name
                  userCompleteProfile(
                    "Last name",
                    TextInputType.name,
                    _lastName,
                  ),

                  //phone
                  userCompleteProfile(
                    "Phone number",
                    TextInputType.number,
                    _phone,
                  ),

                  //bio
                  userCompleteProfile("Bio", TextInputType.text, _bio),
                  // Select Gender
                  //  DropdownButtonFormField
                  SizedBox(
                    width:
                        MediaQuery.of(context).size.width *
                        0.99, //99% of screen
                    child: DropdownButtonFormField<String>(
                      hint: Text(
                        "Select Your gender",
                        style: AppStyles.labelTextStyle,
                      ),
                      decoration: InputDecoration(
                        border: AppStyles.outlineInputBorderstyle,
                        focusedBorder: AppStyles.foucasedoutlineInputBorder,
                        errorBorder: AppStyles.errorBorder,
                        focusedErrorBorder: AppStyles.errorBorder,
                      ),
                      initialValue: _selectgender,
                      items: [
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
                        setState(() {
                          _selectgender = newvalue;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return "Required field Please select your gender ";
                        }
                        return null;
                      },
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      if (userCompleteForm.currentState!.validate()) {
                        //we need a Token here to excute the API
                        try {
                          repository.userCompleteProfile(
                            _userName.text,
                            _firstName.text,
                            _lastName.text,
                            _phone.text,
                            _bio.text,
                            _selectgender!,
                          );
                        } on ServerException catch (e) {
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
