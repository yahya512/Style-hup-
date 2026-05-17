import 'package:dx/Authentication/Regestration/login.dart';
import 'package:dx/Social-Media/shared/screens/main_layout.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/core/navigation/navigation_service.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'dart:ui' as ui;

void main() async {
  //setup for Shared_preferences
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await EasyLocalization.ensureInitialized();
  await CacheHelper().init();

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
