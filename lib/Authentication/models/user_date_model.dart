import 'package:dx/core/api/endpoints.dart';

// ecryption user{id , role , email , isProfileComplete }
class Usermodel {
  final String id;
  final String role;
  final String email;
  final bool isProfileComplete;

  Usermodel({
    required this.id,
    required this.role,
    required this.email,
    required this.isProfileComplete,
  });

  factory Usermodel.fromJson(Map<String, dynamic> jsonData) {
    return Usermodel(
      id: jsonData[ApiKey.id],
      role: jsonData[ApiKey.role],
      email: jsonData[ApiKey.email],
      isProfileComplete: jsonData[ApiKey.isProfileComplete],
    );
  }
}
