import 'package:dx/core/api/endpoints.dart';

class UserCompleteProfileModel {
  final String userName;
  final String firstName;
  final String lastName;
  final String phone;
  final String bio;
  final String gender;
  final String baseUserId;
  final String profileImageUrl;
  final String id;
  final String isVerified;
  final String status;
  final String createdAt;
  final String updatedAt;

  UserCompleteProfileModel({
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.bio,
    required this.gender,
    required this.baseUserId,
    required this.profileImageUrl,
    required this.id,
    required this.isVerified,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserCompleteProfileModel.fromJson(Map<String, dynamic> jsonData) {
    return UserCompleteProfileModel(
      userName: jsonData[ApiKey.userName],
      firstName: jsonData[ApiKey.firstName],
      lastName: jsonData[ApiKey.lastName],
      phone: jsonData[ApiKey.phoneNumber],
      bio: jsonData[ApiKey.description],
      gender: jsonData[ApiKey.gender],
      baseUserId: jsonData[ApiKey.baseUserId],
      profileImageUrl: jsonData[ApiKey.profileImageUrl] ?? "",
      id: jsonData[ApiKey.id],
      isVerified: jsonData[ApiKey.isVerified],
      status: jsonData[ApiKey.status],
      createdAt: jsonData[ApiKey.createdAt],
      updatedAt: jsonData[ApiKey.updatedAt],
    );
  }
}
