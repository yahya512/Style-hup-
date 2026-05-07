import 'package:dio/dio.dart';
import 'package:dx/Authentication/Regestration/login.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/core/api/jwt_helper.dart';
import 'package:dx/core/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

class ApiInterceptors extends QueuedInterceptor {
  final Dio retryDio;

  ApiInterceptors({required this.retryDio});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Never inject auth headers or attempt refresh for auth endpoints.
    final path = options.path;
    if (path.contains(Endpoints.logIn) ||
        path.contains(Endpoints.refreshToken)) {
      return handler.next(options);
    }

    var accessToken =
        CacheHelper().getData(key: ApiKey.accessToken) as String?;

    // Proactively refresh when the stored access token is expired so the
    // request never hits the server with a stale token.
    if (JwtHelper.isExpired(accessToken)) {
      final refreshToken =
          CacheHelper().getData(key: ApiKey.refreshToken) as String?;

      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          retryDio.options.baseUrl = Endpoints.baseUrl;
          final refreshResponse = await retryDio.post<Map<String, dynamic>>(
            Endpoints.refreshToken,
            data: {ApiKey.refreshToken: refreshToken},
          );
          final body = refreshResponse.data;
          final newAccessToken = body?[ApiKey.accessToken] as String?;
          final newRefreshToken = body?[ApiKey.refreshToken] as String?;

          if (newAccessToken != null && newRefreshToken != null) {
            await CacheHelper()
                .saveData(key: ApiKey.accessToken, value: newAccessToken);
            await CacheHelper()
                .saveData(key: ApiKey.refreshToken, value: newRefreshToken);
            accessToken = newAccessToken;
          } else {
            _navigateToLogin();
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'Session expired',
              ),
            );
          }
        } catch (e) {
          // Only clear session and redirect to login when the refresh endpoint
          // explicitly rejects the token (4xx response). A network/timeout
          // error during refresh is a transient failure — let it surface as a
          // regular network error instead of logging the user out.
          if (_isNetworkError(e)) {
            return handler.reject(
              DioException(
                requestOptions: options,
                type: e is DioException ? e.type : DioExceptionType.unknown,
                error: 'Network error',
              ),
            );
          }
          await CacheHelper().removeData(key: ApiKey.accessToken);
          await CacheHelper().removeData(key: ApiKey.refreshToken);
          _navigateToLogin();
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'Session expired',
            ),
          );
        }
      }
    }

    if (accessToken != null) {
      options.headers[ApiKey.authorization] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.requestOptions.path.contains(Endpoints.logIn)) {
      return handler.next(err);
    }

    if (err.requestOptions.path.contains(Endpoints.refreshToken)) {
      _handleSessionExpired(handler, err);
      return;
    }

    if (err.response?.statusCode == 401) {
      // QueuedInterceptor serialises onError calls, so by the time a second
      // 401 reaches here, the first may have already refreshed the token.
      // Compare the token that was on the failed request against the token
      // currently in cache: if they differ, refresh already happened — just
      // retry with the current token instead of refreshing again (which would
      // consume the already-rotated refresh token and could log the user out).
      final storedAccessToken =
          CacheHelper().getData(key: ApiKey.accessToken) as String?;
      final requestAuthHeader =
          err.requestOptions.headers[ApiKey.authorization] as String?;
      final storedAuthHeader =
          storedAccessToken != null ? 'Bearer $storedAccessToken' : null;

      if (storedAuthHeader != null && requestAuthHeader != storedAuthHeader) {
        // Token was already refreshed by a concurrent request — retry.
        err.requestOptions.headers[ApiKey.authorization] = storedAuthHeader;
        try {
          final response = await retryDio.fetch(err.requestOptions);
          return handler.resolve(response);
        } on DioException catch (retryErr) {
          return handler.next(retryErr);
        }
      }

      final refreshToken =
          CacheHelper().getData(key: ApiKey.refreshToken) as String?;
      if (refreshToken == null || refreshToken.isEmpty) {
        _handleSessionExpired(handler, err);
        return;
      }

      try {
        // Use retryDio directly to avoid re-entering the QueuedInterceptor
        // queue and causing a deadlock.
        retryDio.options.baseUrl = Endpoints.baseUrl;
        final refreshResponse = await retryDio.post<Map<String, dynamic>>(
          Endpoints.refreshToken,
          data: {ApiKey.refreshToken: refreshToken},
        );
        final body = refreshResponse.data;
        final newAccessToken = body?[ApiKey.accessToken] as String?;
        final newRefreshToken = body?[ApiKey.refreshToken] as String?;

        if (newAccessToken == null || newRefreshToken == null) {
          _handleSessionExpired(handler, err);
          return;
        }

        await CacheHelper().saveData(
          key: ApiKey.accessToken,
          value: newAccessToken,
        );
        await CacheHelper().saveData(
          key: ApiKey.refreshToken,
          value: newRefreshToken,
        );

        err.requestOptions.headers[ApiKey.authorization] =
            'Bearer $newAccessToken';
        final retryResponse = await retryDio.fetch(err.requestOptions);
        return handler.resolve(retryResponse);
      } catch (e) {
        if (_isNetworkError(e)) {
          return handler.next(
            DioException(
              requestOptions: err.requestOptions,
              type: e is DioException ? e.type : DioExceptionType.unknown,
              error: 'Network error',
            ),
          );
        }
        _handleSessionExpired(handler, err);
        return;
      }
    }

    return handler.next(err);
  }

  bool _isNetworkError(Object? e) {
    if (e is! DioException) return false;
    return e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.response == null;
  }

  void _navigateToLogin() {
    NavigationService.navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LogIn()),
      (route) => false,
    );
  }

  void _handleSessionExpired(
    ErrorInterceptorHandler handler,
    DioException err,
  ) {
    CacheHelper().removeData(key: ApiKey.accessToken);
    CacheHelper().removeData(key: ApiKey.refreshToken);
    _navigateToLogin();
    handler.next(err);
  }
}
