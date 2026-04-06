import 'package:dx/core/api/endpoints.dart';

// receive successful response from Api
class LoginModel {
  final String accessToken;
  final String refreshToken;
  final Map<String, dynamic> user;

  LoginModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginModel.fromJson(Map<String, dynamic> jsonData) {
    // final rawUser = jsonData[ApiKey.user];
    return LoginModel(
      accessToken: jsonData[ApiKey.accessToken],
      refreshToken: jsonData[ApiKey.refreshToken],
      user: jsonData[ApiKey.userinfo],
    );
  }
}

//if value1 is Exited use it else use value2 instead
// value1 ?? value2
