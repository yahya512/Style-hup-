import 'package:dx/core/api/endpoints.dart';

class ForgetPasswordModel {
  final String message;

  ForgetPasswordModel({required this.message});

  factory ForgetPasswordModel.fromJson(Map<String, dynamic> jsonData) {
    return ForgetPasswordModel(message: jsonData[ApiKey.message]);
  }
}
