import 'package:dx/core/api/endpoints.dart';

class RefreshTokenModel {
  final String refreshToken;
  final String accessToken;
  final String user;

  RefreshTokenModel({
    required this.refreshToken,
    required this.accessToken,
    required this.user,
  });

  factory RefreshTokenModel.fromJson(Map<String, dynamic> jsonData) {
    return RefreshTokenModel(
      refreshToken: jsonData[ApiKey.refreshToken],
      accessToken: jsonData[ApiKey.accessToken],
      user: jsonData[ApiKey.userinfo],
    );
  }
}
