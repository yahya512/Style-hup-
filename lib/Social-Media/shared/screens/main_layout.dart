import 'package:dx/Social-Media/ShopEntry/shop_tab.dart';
import 'package:dx/Social-Media/search/screens/search_screen.dart';
import 'package:dx/Social-Media/user/screens/user_profile_screen.dart'; // This is the Page/Screen
import 'package:dx/Social-Media/brand/screens/brand_profile_screen.dart';
import 'package:dx/Social-Media/user/cubit/user_profile_cubit.dart';
import 'package:dx/Social-Media/user/cubit/user_profile_state.dart';
import 'package:dx/Social-Media/user/services/user_profile_service.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/feed/screens/feed_screen.dart';

// lib/Social-Media/main_layout.dart

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the Cubit here so the Bottom Nav Bar and all Profile widgets can see it.
    return BlocProvider(
      create: (context) => UserProfileCubit(
        service: getIt<UserProfileService>(),
      )..loadProfile(),
      child: const _MainLayoutContent(),
    );
  }
}

class _MainLayoutContent extends StatefulWidget {
  const _MainLayoutContent();

  @override
  State<_MainLayoutContent> createState() => _MainLayoutContentState();
}

class _MainLayoutContentState extends State<_MainLayoutContent> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final role = CacheHelper().getData(key: ApiKey.role) as String?;

    final List<Widget> screens = [
      const FeedPage(), 
      const ShopEntry(),
      const Center(child: Text('Chat/Messages Screen')),
      const SearchPage(),
      // role-aware profile entry
      role == 'BRAND' ? const BrandProfilePage() : const UserProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: [
            _navItem(_currentIndex == 0 ? Icons.home : Icons.home_outlined, 0),
            _navItem(Icons.shopping_cart_outlined, 1),
            _navItem(Icons.send_outlined, 2),
            _navItem(Icons.search, 3),
            BottomNavigationBarItem(
              icon: BlocBuilder<UserProfileCubit, UserProfileState>(
                builder: (context, state) {
                  final imageUrl = state.profile?.profileImageUrl;
                  final bool isActive = _currentIndex == 4;
                  
                  return Container(
                    padding: EdgeInsets.all(isActive ? 1.5.r : 0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isActive ? Border.all(color: Colors.black, width: 1.2) : null,
                    ),
                    child: CircleAvatar(
                      radius: 13.r,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                      child: imageUrl == null 
                          ? Icon(Icons.person, size: 18.r, color: Colors.grey[600]) 
                          : null,
                    ),
                  );
                },
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _navItem(IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _currentIndex == index ? Colors.black : Colors.grey.shade600,
        size: 28.r,
      ),
      label: '',
    );
  }
}