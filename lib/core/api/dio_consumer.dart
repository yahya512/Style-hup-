import 'package:dio/dio.dart';
import 'package:dx/core/api/api_consumer.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/core/api/interceptors.dart';
import 'package:dx/core/errors/exceptions.dart';
import 'package:flutter/foundation.dart';

enum RequestType { auth, social, ecommerce }

class DioConsumer extends ApiConsumer {
  final Dio dio;
  DioConsumer({required this.dio}) {
    dio.options.baseUrl = Endpoints.baseUrl;

    // interceptors is observers of request and response
    dio.interceptors.add(ApiInterceptors());
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
          requestUrl: true,
          responseUrl: true,
        ),
      );
    }
  }

  /// Determines the [RequestType] based on the path.
  /// Scalable logic to categorize requests internally.
  RequestType _getRequestType(String path) {
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    if (cleanPath.contains('auth/')) {
      return RequestType.auth;
    } else if (cleanPath.startsWith("customer/")) {
      return RequestType.ecommerce;
    }

    return RequestType.social;
  }

  /// Maps [RequestType] to the appropriate base URL from [Endpoints].
  String _getBaseUrl(RequestType type) {
    switch (type) {
      case RequestType.ecommerce:
        return Endpoints.commerceBaseUrl;
      case RequestType.auth:
        return Endpoints.baseUrl;
      case RequestType.social:
        return Endpoints.baseUrl;
    }
  }

  /// Resolves the full absolute URL for the request.
  String _getResolvedUrl(String path) {
    if (path.startsWith('http')) return path;

    final type = _getRequestType(path);
    final baseUrl = _getBaseUrl(type);

    final cleanBase = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;

    return '$cleanBase$cleanPath';
  }

  @override
  Future<dynamic> get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryparametars,
    isFormdata = false,
  }) async {
    try {
      final response = await dio.get(
        _getResolvedUrl(path),
        data: data,
        queryParameters: queryparametars,
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
    Map<String, dynamic>? queryparametars,
    isFormdata = false,
  }) async {
    try {
      final response = await dio.patch(
        _getResolvedUrl(path),
        data: isFormdata ? FormData.fromMap(data) : data,
        queryParameters: queryparametars,
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
    Map<String, dynamic>? queryparametars,
    isFormdata = false,
  }) async {
    try {
      final response = await dio.post(
        _getResolvedUrl(path),
        data: isFormdata ? FormData.fromMap(data) : data,
        queryParameters: queryparametars,
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
    Map<String, dynamic>? queryparametars,
    isFormdata = false,
  }) async {
    try {
      final response = await dio.delete(
        _getResolvedUrl(path),
        data: isFormdata ? FormData.fromMap(data) : data,
        queryParameters: queryparametars,
      );
      return response.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }
}
