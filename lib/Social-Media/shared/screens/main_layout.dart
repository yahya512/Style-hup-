import 'package:dx/Social-Media/ShopEntry/shop_tab.dart';
import 'package:dx/Social-Media/search/screens/search_screen.dart';
import 'package:dx/Social-Media/user/screens/user_profile_screen.dart'; // This is the Page/Screen
import 'package:dx/Social-Media/brand/screens/brand_profile_screen.dart';
import 'package:dx/Social-Media/profile_posts/cubit/my_posts_cubit.dart';
import 'package:dx/Social-Media/profile_posts/services/my_posts_service.dart';
import 'package:dx/Social-Media/user/cubit/user_profile_cubit.dart';
import 'package:dx/Social-Media/user/cubit/user_profile_state.dart';
import 'package:dx/Social-Media/user/services/user_profile_service.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/notifications/cubit/notification_cubit.dart';
import 'package:dx/Social-Media/notifications/cubit/notification_state.dart';
import 'package:dx/Social-Media/notifications/models/notification_model.dart';
import 'package:dx/Social-Media/notifications/screens/notifications_screen.dart';
import 'package:dx/Social-Media/notifications/services/socket_service.dart';
import 'package:dx/Social-Media/notifications/widgets/notification_banner.dart';
import 'package:dx/Social-Media/feed/screens/feed_screen.dart';

// lib/Social-Media/main_layout.dart

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the Cubit here so the Bottom Nav Bar and all Profile widgets can see it.
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserProfileCubit(
            service: getIt<UserProfileService>(),
          )..loadProfile(),
        ),
        BlocProvider(
          create: (_) => MyPostsCubit(
            service: getIt<MyPostsService>(),
          )..loadPosts(),
        ),
        BlocProvider(
          create: (_) => getIt<NotificationCubit>(),
        ),
      ],
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
  OverlayEntry? _bannerEntry;
  // Saved in initState so dispose() can use it without a BuildContext lookup.
  late final NotificationCubit _notificationCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _notificationCubit = context.read<NotificationCubit>();
      final accessToken =
          CacheHelper().getData(key: ApiKey.accessToken) as String?;
      if (accessToken != null) {
        getIt<SocketService>().connect(accessToken);
        _notificationCubit
          ..startListening()
          ..loadInitial();
      }
    });
  }

  @override
  void dispose() {
    _bannerEntry?.remove();
    _notificationCubit.stopListening();
    getIt<SocketService>().disconnect();
    super.dispose();
  }

  void _showBanner(NotificationModel notification) {
    _bannerEntry?.remove();
    _bannerEntry = NotificationBannerOverlay.show(
      context: context,
      notification: notification,
      onDismissed: () {
        _bannerEntry = null;
        if (mounted) context.read<NotificationCubit>().clearBanner();
      },
      onTap: () {
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<NotificationCubit>(),
              child: const NotificationsScreen(),
            ),
          ),
        );
      },
    );
  }

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

    return BlocListener<NotificationCubit, NotificationState>(
      listenWhen: (prev, curr) =>
          curr.bannerNotification != null &&
          prev.bannerNotification != curr.bannerNotification,
      listener: (_, state) => _showBanner(state.bannerNotification!),
      child: Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF800020),
          border: Border(top: BorderSide(color: Color(0xFF600018), width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF800020),
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
                      border: isActive
                          ? Border.all(color: Colors.white, width: 1.5)
                          : null,
                    ),
                    child: CircleAvatar(
                      radius: 13.r,
                      backgroundColor: const Color(0xFFB05070),
                      backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                      child: imageUrl == null
                          ? Icon(Icons.person, size: 18.r, color: Colors.white70)
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
    ));
  }

  BottomNavigationBarItem _navItem(IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _currentIndex == index ? Colors.white : Colors.white54,
        size: 28.r,
      ),
      label: '',
    );
  }
}