// api exceptions

import 'package:dio/dio.dart';
import 'package:dx/core/errors/errormodel.dart';

class ServerException implements Exception {
  final Errormodel errormodel;

  ServerException({required this.errormodel});
}

void handleDioException(DioException e) {
  switch (e.type) {
    // Error => the request desnot arrive to database
    // send the error data that is formated (JSON) to the Errormodel
    case DioExceptionType.connectionTimeout:
      throw ServerException(errormodel: Errormodel.fromJson(e.response!.data));
    case DioExceptionType.sendTimeout:
      throw ServerException(errormodel: Errormodel.fromJson(e.response!.data));
    case DioExceptionType.receiveTimeout:
      throw ServerException(errormodel: Errormodel.fromJson(e.response!.data));
    case DioExceptionType.badCertificate:
      throw ServerException(errormodel: Errormodel.fromJson(e.response!.data));
    case DioExceptionType.cancel:
      throw ServerException(errormodel: Errormodel.fromJson(e.response!.data));
    case DioExceptionType.connectionError:
      throw ServerException(errormodel: Errormodel.fromJson(e.response!.data));
    case DioExceptionType.unknown:
      throw ServerException(errormodel: Errormodel.fromJson(e.response!.data));

    // specail Error =>(the request send successfully but have wrong data)
    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400: // BadResponse
          throw ServerException(
            errormodel: Errormodel.fromJson(e.response!.data),
          );
        case 401: // unAuthorized
          throw ServerException(
            errormodel: Errormodel.fromJson(e.response!.data),
          );
        case 403: // Forbidden
          throw ServerException(
            errormodel: Errormodel.fromJson(e.response!.data),
          );
        case 404: // NotFound
          throw ServerException(
            errormodel: Errormodel.fromJson(e.response!.data),
          );
        case 409: // cofficient
          throw ServerException(
            errormodel: Errormodel.fromJson(e.response!.data),
          );
        case 422: // un processable entity
          throw ServerException(
            errormodel: Errormodel.fromJson(e.response!.data),
          );
        case 504: // Server exception
          throw ServerException(
            errormodel: Errormodel.fromJson(e.response!.data),
          );
      }
  }
}
