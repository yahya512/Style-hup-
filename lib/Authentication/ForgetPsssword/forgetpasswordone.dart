import 'package:dx/Authentication/ForgetPsssword/forgetpassordtwo.dart';
import 'package:dx/Authentication/models/forget_password_model.dart';
import 'package:dx/Widgets/email_form_field.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/core/errors/exceptions.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetpasswordOne extends StatefulWidget {
  const ForgetpasswordOne({super.key});
  @override
  State<ForgetpasswordOne> createState() {
    return _ForgetpasswordOneState();
  }
}

class _ForgetpasswordOneState extends State<ForgetpasswordOne> {
  // Email FormKey
  late final GlobalKey<FormState> _emailFormKey;
  //  email controller
  late TextEditingController userEmail;
  // API
  final repository = getIt<UserRepository>();
  ForgetPasswordModel? forgetPasswordModel;
  @override
  void initState() {
    _emailFormKey = GlobalKey();
    userEmail = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    userEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Forget password ?", style: AppStyles.mainTitleStyle),
              Text(
                "Please Enter your email to receive a confirmation code to reset your password",
                style: AppStyles.subTitleStyle,
              ),
              SizedBox(height: 25.h),
              Form(key: _emailFormKey, child: emailFormField(userEmail)),

              SizedBox(height: 85.h),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),

                  onPressed: () async {
                    // valdation check
                    if (_emailFormKey.currentState!.validate()) {
                      _emailFormKey.currentState!.save();
                      try {
                        final response = await repository.forgetPassword(
                          CacheHelper().getData(key: ApiKey.role).toString(),
                          CacheHelper().getData(key: ApiKey.email).toString(),
                        );
                        forgetPasswordModel = response;
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              forgetPasswordModel!.message,
                              style: AppStyles.snackBarStyle,
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ForgetpassordTwo(emailUser: userEmail.text),
                          ),
                        );
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
                    }
                  },
                  child: Text(
                    "Send Code",
                    style: AppStyles.whiteTextButtonStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
