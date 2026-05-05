import 'package:dx/E-Commerce/home_screen.dart';
import 'package:dx/E-Commerce/shop_screen.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingEcommerce extends StatefulWidget {
  const SettingEcommerce({super.key});

  @override
  State<SettingEcommerce> createState() => _SettingEcommerceState();
}

class _SettingEcommerceState extends State<SettingEcommerce> {
  bool isDarkMode = false;
  int _selectedIcon = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("settings.settings".tr(), style: AppStyles.mainTitleStyle),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      body: ListView(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 10.h),
        children: [
          // User Info Section
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50.r,
                  backgroundImage: const AssetImage(
                    "images/avatar_profile2X.png",
                  ),
                ),
                SizedBox(height: 15.h),
                Text("settings.user_name".tr(), style: AppStyles.subTitleStyle),
                Text(
                  "settings.user_email".tr(),
                  style: AppStyles.labelTextStyle,
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),

          // Language Section
          ListTile(
            leading: const Icon(Icons.language, color: Colors.black),
            title: Text("settings.language".tr(), style: AppStyles.normalTextStyle),
            trailing: Text(
              context.locale.languageCode == 'en' ? "English" : "العربية",
              style: AppStyles.labelTextStyle,
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("settings.language".tr()),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text("English"),
                        onTap: () async {
                          context.setLocale(const Locale('en'));
                          await CacheHelper.sharedPreferences.setString('lang', 'en');
                          if (context.mounted) Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text("العربية"),
                        onTap: () async {
                          context.setLocale(const Locale('ar'));
                          await CacheHelper.sharedPreferences.setString('lang', 'ar');
                          if (context.mounted) Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const Divider(),

          // Theme Section
          ListTile(
            leading: const Icon(Icons.dark_mode, color: Colors.black),
            title: Text("settings.dark_mode".tr(), style: AppStyles.normalTextStyle),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
              activeThumbColor: const Color(0xFF32DBE6),
            ),
          ),
          const Divider(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIcon,
        selectedItemColor: Color(0xFF32DBE6),
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            _selectedIcon = value;
            if (_selectedIcon == 0) {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => HomeScreen()));
            } else if (_selectedIcon == 2) {
              // Navigator.of(
              //   context,
              // ).push(MaterialPageRoute(builder: (context) => DashBoard()));
            } else if (_selectedIcon == 1) {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => ShopScreen()));
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "nav.home".tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "nav.shop".tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: "nav.dashboard".tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "nav.settings".tr(),
          ),
        ],
      ),
    );
  }
}
