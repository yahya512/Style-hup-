import 'package:dx/Authentication/Regestration/login.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/navigation/navigation_service.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  //setup for Shared_preferences
  WidgetsFlutterBinding.ensureInitialized();
  CacheHelper().init();

  //for Get_it package for singleton repository
  setupServiceLocator();
  runApp(const MyApp());
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
          navigatorKey: NavigationService.navigatorKey,
          debugShowCheckedModeBanner: false,
          home: LogIn(),
        );
      },
    );
  }
}
