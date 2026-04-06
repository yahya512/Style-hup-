import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dx/Authentication/Regestration/login.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/core/navigation/navigation_service.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/repositories/user_repository.dart';
import 'package:flutter/material.dart';

// Interceptor allows modifying requests, responses, and errors
// before they reach the server or return to the app

class ApiInterceptors extends QueuedInterceptor {
  final Dio retryDio;
  bool _isRefreshing = false;
  Completer<void>? _refreshcompleter;
  ApiInterceptors({required this.retryDio});
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String? token = CacheHelper().getData(key: ApiKey.accessToken);
    if (token != null) {
      options.headers[ApiKey.authorization] = "Bearer $token";
    }
    handler.next(options);
    // super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // ✅ مشكلة 1: الـ login endpoint مش المكان الصح للـ token refresh
    // الـ refresh المفروض يتعمل على باقي الـ endpoints مش login نفسه
    // لو 401 على login → معناها credentials غلط أو email مش verified → مرره زي ما هو
    if (err.requestOptions.path.contains(Endpoints.logIn)) {
      return handler.next(err);
    }

    // ✅ لو 401 على refresh endpoint نفسه → session انتهت خالص، logout
    if (err.requestOptions.path.contains(Endpoints.refreshToken)) {
      _handleSessionExpired(handler, err);
      return;
    }

    if (err.response?.statusCode == 401) {
      // ✅ مشكلة 3: تحقق من وجود الـ refresh token قبل أي حاجة
      final String? refreshToken = CacheHelper().getData(
        key: ApiKey.refreshToken,
      );
      if (refreshToken == null || refreshToken.isEmpty) {
        _handleSessionExpired(handler, err);
        return;
      }

      if (_isRefreshing) {
        try {
          await _refreshcompleter?.future;
          err.requestOptions.headers[ApiKey.authorization] =
              "Bearer ${CacheHelper().getData(key: ApiKey.accessToken)}";
          final response = await retryDio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (_) {
          // ✅ مشكلة 4: return قبل handler عشان منكملش
          return handler.next(err);
        }
      }

      _isRefreshing = true;
      _refreshcompleter = Completer();

      try {
        final repository = getIt<UserRepository>();
        final receivedNewTokens = await repository.refreshtoken(refreshToken);

        await CacheHelper().saveData(
          key: ApiKey.accessToken,
          value: receivedNewTokens.accessToken,
        );
        await CacheHelper().saveData(
          key: ApiKey.refreshToken,
          value: receivedNewTokens.refreshToken,
        );

        _refreshcompleter?.complete();

        err.requestOptions.headers[ApiKey.authorization] =
            "Bearer ${receivedNewTokens.accessToken}";

        final retryResponse = await retryDio.fetch(err.requestOptions);
        return handler.resolve(retryResponse);
      } catch (e) {
        _refreshcompleter?.completeError(e);
        _handleSessionExpired(handler, err);
        return; // ✅ مشكلة 4: return بعد handler
      } finally {
        _isRefreshing = false;
      }
    }

    // أي error تاني غير 401
    return handler.next(err);
  }

  // ✅ helper منفصل للـ session expiry
  void _handleSessionExpired(
    ErrorInterceptorHandler handler,
    DioException err,
  ) {
    CacheHelper().removeData(key: ApiKey.accessToken); // امسح كل الـ tokens
    CacheHelper().removeData(key: ApiKey.refreshToken); // امسح كل الـ tokens
    NavigationService.navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LogIn()),
      (route) => false,
    );
    handler.next(err);
  }
}

// QueuedInterceptor => ensures that requests enter the interceptor sequentially
// to avoid concurrency issues

// handler.next(options) → continue the request normally
// handler.next(err) → pass the error to the next interceptor or caller
// handler.resolve(response) → treat the request as successful with this response

/*
wait until the refresh process finishes
if refresh fails, the Future will throw an error
so we wrap it in try-catch to prevent other pending requests from crashing 
 try {
   await _refreshcompleter?.future; }
     catch (_) {} 
*/
