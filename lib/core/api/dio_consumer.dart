import 'package:dio/dio.dart';
import 'package:dx/core/api/api_consumer.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/core/api/interceptors.dart';
import 'package:dx/core/errors/exceptions.dart';
import 'package:flutter/foundation.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;
  DioConsumer({required this.dio}) {
    dio.options.baseUrl = Endpoints.baseUrl;

    // interceptors is observers of request and response
    dio.interceptors.add(ApiInterceptors(retryDio: Dio()));
    // print reguest and response
    // if we ae in debug mode not release mode
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryparametar,
  }) async {
    try {
      final response = await dio.get(
        path,
        data: data,
        queryParameters: queryparametar,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryparametar,
    isFormdata = false,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: isFormdata ? FormData.fromMap(data) : data,
        queryParameters: queryparametar,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryparametar,
    isFormdata = false,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: isFormdata ? FormData.fromMap(data) : data,
        queryParameters: queryparametar,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryparametar,
    isFormdata = false,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: isFormdata ? FormData.fromMap(data) : data,
        queryParameters: queryparametar,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}
