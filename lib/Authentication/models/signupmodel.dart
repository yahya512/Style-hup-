import 'package:dx/core/api/endpoints.dart';

class Signupmodel {
  final String message;

  Signupmodel({required this.message});

  factory Signupmodel.fromJson(Map<String, dynamic> jsonData) {
    return Signupmodel(message: jsonData[ApiKey.message]);
  }
}
