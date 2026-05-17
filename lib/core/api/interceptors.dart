import 'package:dio/dio.dart';
import 'package:dx/Authentication/Regestration/login.dart';
import 'package:dx/Social-Media/notifications/services/socket_service.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/core/navigation/navigation_service.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:flutter/material.dart';

class ApiInterceptors extends QueuedInterceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Never inject auth headers for auth endpoints.
    if (options.path.contains(Endpoints.logIn)) {
      return handler.next(options);
    }

    final accessToken =
        CacheHelper().getData(key: ApiKey.accessToken) as String?;
    if (accessToken != null) {
      options.headers[ApiKey.authorization] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _clearSession().then((_) => _navigateToLogin());
    }
    handler.next(err);
  }

  Future<void> _clearSession() async {
    final cache = CacheHelper();
    await Future.wait([
      cache.removeData(key: ApiKey.accessToken),
      cache.removeData(key: ApiKey.refreshToken),
      cache.removeData(key: ApiKey.userId),
      cache.removeData(key: ApiKey.role),
      cache.removeData(key: ApiKey.email),
      cache.removeData(key: ApiKey.isProfileComplete),
    ]);
    if (getIt.isRegistered<SocketService>()) {
      getIt<SocketService>().disconnect();
    }
  }

  void _navigateToLogin() {
    NavigationService.navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LogIn()),
      (route) => false,
    );
  }
}
