import 'package:dx/Social-Media/chat/cubit/conversations_cubit.dart';
import 'package:dx/Social-Media/chat/screens/conversations_screen.dart';
import 'package:dx/Social-Media/chat/services/chat_service.dart';
import 'package:dx/Social-Media/follow/services/follow_service.dart';
import 'package:dx/Social-Media/user/services/other_user_profile_service.dart';
import 'package:dx/Social-Media/ShopEntry/shop_tab.dart';
import 'package:dx/Social-Media/search/screens/search_screen.dart';
import 'package:dx/Social-Media/user/screens/user_profile_screen.dart'; // This is the Page/Screen
import 'package:dx/Social-Media/brand/screens/brand_profile_screen.dart';
import 'package:dx/Social-Media/profile_posts/cubit/my_posts_cubit.dart';
import 'package:dx/Social-Media/profile_posts/services/my_posts_service.dart';
import 'package:dx/Social-Media/brand/cubit/brand_profile_cubit.dart';
import 'package:dx/Social-Media/brand/services/brand_profile_service.dart';
import 'package:dx/Social-Media/user/cubit/user_profile_cubit.dart';
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
import 'package:dx/core/navigation/tab_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

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
          create: (_) => BrandProfileCubit(
            service: getIt<BrandProfileService>(),
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
        BlocProvider(
          create: (_) => ConversationsCubit(
            chatService: getIt<ChatService>(),
            socketService: getIt<SocketService>(),
            profileService: getIt<OtherUserProfileService>(),
            followService: getIt<FollowService>(),
          ),
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
  // Saved in initState so dispose() can use them without a BuildContext lookup.
  late final NotificationCubit _notificationCubit;
  late final ConversationsCubit _conversationsCubit;

  @override
  void initState() {
    super.initState();
    appTabNotifier.addListener(_onTabNotifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _notificationCubit = context.read<NotificationCubit>();
      _conversationsCubit = context.read<ConversationsCubit>();
      final accessToken =
          CacheHelper().getData(key: ApiKey.accessToken) as String?;
      if (accessToken != null) {
        getIt<SocketService>().connect(accessToken);
        _notificationCubit
          ..startListening()
          ..loadInitial();
        _conversationsCubit
          ..startListening()
          ..loadInitial();
      }
    });
  }

  void _onTabNotifier() {
    if (mounted) setState(() => _currentIndex = appTabNotifier.value);
  }

  @override
  void dispose() {
    appTabNotifier.removeListener(_onTabNotifier);
    _bannerEntry?.remove();
    _notificationCubit.stopListening();
    _conversationsCubit.stopListening();
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
        appTabNotifier.value = 5;
      },
    );
  }

  Future<void> _openDashboardWebsite() async {
    final Uri url =
        Uri.parse('https://static-dashboard-five.vercel.app/#/login');
    try {
      if (!await launchUrl(
        url,
        mode: LaunchMode.inAppWebView,
      )) {
        debugPrint('Could not launch $url');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not launch the dashboard website.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error launching website: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = CacheHelper().getData(key: ApiKey.role) as String?;
    final isBrand = (role == 'BRAND');

    final List<Widget> screens = [
      const FeedPage(),
      const ShopEntry(),
      const ConversationsScreen(),
      const SearchPage(),
      // role-aware profile entry
      isBrand ? const BrandProfilePage() : const UserProfileScreen(),
      // hidden tab — notifications (index 5)
      const NotificationsScreen(),
    ];

    // Build navigation items
    final List<BottomNavigationBarItem> navItems = [
      _navItem(_currentIndex == 0 ? Icons.home : Icons.home_outlined, 0),
      _navItem(Icons.shopping_cart_outlined, 1),
    ];

    if (isBrand) {
      navItems.add(
        BottomNavigationBarItem(
          icon: Icon(
            Icons.dashboard_rounded,
            color: Colors.white54, // visually inactive
            size: 28.r,
          ),
          label: '',
        ),
      );
    }

    navItems.addAll([
      _navItem(Icons.send_outlined, 2),
      _navItem(Icons.search, 3),
      BottomNavigationBarItem(
        icon: _ProfileAvatar(isActive: _currentIndex == 4, role: role),
        label: 'Profile',
      ),
    ]);

    // Visual selected index mapping for BottomNavigationBar
    int navBarCurrentIndex;
    if (isBrand) {
      if (_currentIndex == 0) {
        navBarCurrentIndex = 0;
      } else if (_currentIndex == 1) {
        navBarCurrentIndex = 1;
      } else if (_currentIndex == 2) {
        navBarCurrentIndex = 3; // Chat
      } else if (_currentIndex == 3) {
        navBarCurrentIndex = 4; // Search
      } else {
        navBarCurrentIndex = 5; // Profile / Notifications
      }
    } else {
      navBarCurrentIndex = _currentIndex.clamp(0, 4);
    }

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
            decoration: BoxDecoration(
              color: const Color(0xFF800020),
              border: Border(
                  top: BorderSide(color: const Color(0xFF600018), width: 0.5)),
            ),
            child: BottomNavigationBar(
              currentIndex: navBarCurrentIndex,
              onTap: (index) {
                if (isBrand) {
                  if (index == 2) {
                    _openDashboardWebsite();
                    return;
                  }
                  // Map visual navigation index back to actual screen index
                  int screenIndex = index;
                  if (index > 2) {
                    screenIndex = index - 1;
                  }
                  appTabNotifier.value = screenIndex;
                } else {
                  appTabNotifier.value = index;
                }
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: const Color(0xFF800020),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 0,
              items: navItems,
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

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.isActive, required this.role});

  final bool isActive;
  final String? role;

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = role == 'BRAND'
        ? context.watch<BrandProfileCubit>().state.profile?.profileImageUrl
        : context.watch<UserProfileCubit>().state.profile?.profileImageUrl;

    return Container(
      padding: EdgeInsets.all(isActive ? 1.5.r : 0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isActive ? Border.all(color: Colors.white, width: 1.5) : null,
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
  }
}
