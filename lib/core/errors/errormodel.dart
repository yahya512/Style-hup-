// it was made for receive json when errors happen

import 'package:dx/core/api/endpoints.dart';

class Errormodel {
  final String message;
  final String error;
  final int status;

  Errormodel({
    required this.message,
    required this.error,
    required this.status,
  });

  factory Errormodel.fromJson(Map<String, dynamic> jsonData) {
    return Errormodel(
      message: jsonData[ApiKey.message],
      error: jsonData[ApiKey.error],
      status: jsonData[ApiKey.statusCode],
    );
  }
}
