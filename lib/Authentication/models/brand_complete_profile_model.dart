// import 'package:dx/core/api/endpoints.dart';

import 'package:dx/core/api/endpoints.dart';

class BrandCompleteProfileModel {
  final String brandName;
  final String username;
  final String websiteUrl;
  final String bio;
  final String phoneNumber;
  final String baseUserId;
  final String profileImageUrl;
  final String id;
  final bool isVerified;
  final String status;
  final String createdAt;
  final String updatedAt;

  BrandCompleteProfileModel({
    required this.brandName,
    required this.username,
    required this.websiteUrl,
    required this.bio,
    required this.phoneNumber,
    required this.baseUserId,
    required this.profileImageUrl,
    required this.id,
    required this.isVerified,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BrandCompleteProfileModel.fromJson(Map<String, dynamic> jsonData) {
    return BrandCompleteProfileModel(
      brandName: jsonData[ApiKey.brandName],
      username: jsonData[ApiKey.userName],
      websiteUrl: jsonData[ApiKey.brandDomain],
      bio: jsonData[ApiKey.description],
      phoneNumber: jsonData[ApiKey.phoneNumber],
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
