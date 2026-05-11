import 'package:dio/dio.dart';
import 'package:dx/Authentication/Regestration/login.dart';
import 'package:dx/Social-Media/shared/screens/main_layout.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/core/api/jwt_helper.dart';
import 'package:dx/core/navigation/navigation_service.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:ui' as ui;

/// Proactively refreshes an expired access token at startup so the user is
/// never sent to [MainLayout] holding a stale token.
///
/// On success  : updates both tokens in SharedPreferences.
/// On failure  : removes both tokens so [MyApp] redirects to [LogIn].
Future<void> _tryRefreshOnStartup() async {
  final prefs = CacheHelper.sharedPreferences;
  final accessToken = prefs.getString(ApiKey.accessToken);

  if (!JwtHelper.isExpired(accessToken)) return;

  final refreshToken = prefs.getString(ApiKey.refreshToken);
  if (refreshToken == null || refreshToken.isEmpty) {
    await CacheHelper().removeData(key: ApiKey.accessToken);
    return;
  }

  try {
    final dio = Dio()..options.baseUrl = Endpoints.baseUrl;
    final response = await dio.post<Map<String, dynamic>>(
      Endpoints.refreshToken,
      data: {ApiKey.refreshToken: refreshToken},
    );
    final body = response.data;
    final newAccess = body?[ApiKey.accessToken] as String?;
    final newRefresh = body?[ApiKey.refreshToken] as String?;

    if (newAccess != null && newRefresh != null) {
      await CacheHelper().saveData(key: ApiKey.accessToken, value: newAccess);
      await CacheHelper().saveData(key: ApiKey.refreshToken, value: newRefresh);
    } else {
      await CacheHelper().removeData(key: ApiKey.accessToken);
      await CacheHelper().removeData(key: ApiKey.refreshToken);
    }
  } catch (_) {
    // Refresh failed (network error, expired refresh token, etc.) — logout.
    await CacheHelper().removeData(key: ApiKey.accessToken);
    await CacheHelper().removeData(key: ApiKey.refreshToken);
  }
}

void main() async {
  //setup for Shared_preferences
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await EasyLocalization.ensureInitialized();
  await CacheHelper().init();

  // Refresh expired access token before deciding which screen to show.
  await _tryRefreshOnStartup();

  // Read saved language
  final String? savedLang = CacheHelper.sharedPreferences.getString('lang');
  final Locale startLocale =
      savedLang != null ? Locale(savedLang) : const Locale('en');

  //for Get_it package for singleton repository
  setupServiceLocator();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'lib/core/localization/assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: startLocale,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(440, 956),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          navigatorKey: NavigationService.navigatorKey,
          debugShowCheckedModeBanner: false,
          home: CacheHelper.sharedPreferences.getString(ApiKey.accessToken) !=
                  null
              ? const MainLayout()
              : const LogIn(),
          builder: (context, child) {
            return Directionality(
              textDirection: context.locale.languageCode == 'ar'
                  ? ui.TextDirection.rtl
                  : ui.TextDirection.ltr,
              child: child!,
            );
          },
        );
      },
    );
  }
}
