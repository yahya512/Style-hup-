import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/Social-Media/feed/widgets/error_view.dart';
import 'package:dx/Social-Media/follow/cubit/follow_button_cubit.dart';
import 'package:dx/Social-Media/follow/cubit/follow_list_cubit.dart';
import 'package:dx/Social-Media/follow/screens/follow_list_screen.dart';
import 'package:dx/Social-Media/follow/services/follow_service.dart';
import 'package:dx/Social-Media/follow/widgets/follow_button.dart';
import 'package:dx/Social-Media/shared/widgets/profile_avatar.dart';
import 'package:dx/Social-Media/shared/widgets/profile_stat_item.dart';
import 'package:dx/Social-Media/user/cubit/other_user_profile_cubit.dart';
import 'package:dx/Social-Media/user/cubit/other_user_profile_state.dart';
import 'package:dx/Social-Media/user/models/user_profile_model.dart';
import 'package:dx/Social-Media/user/services/other_user_profile_service.dart';

/// Entry point — provides both cubits and passes userId down.
class OtherUserProfilePage extends StatelessWidget {
  const OtherUserProfilePage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => OtherUserProfileCubit(
            service: getIt<OtherUserProfileService>(),
            userId: userId,
          )..loadProfile(),
        ),
        BlocProvider(
          create: (_) => FollowButtonCubit(
            service: getIt<FollowService>(),
            targetUserId: userId,
          )..init(),
        ),
      ],
      child: OtherUserProfileScreen(userId: userId),
    );
  }
}

class OtherUserProfileScreen extends StatelessWidget {
  const OtherUserProfileScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OtherUserProfileCubit, OtherUserProfileState>(
      listenWhen: (prev, curr) => curr.errorCount > prev.errorCount,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content:
                Text(state.errorMessage ?? 'An unexpected error occurred.'),
            behavior: SnackBarBehavior.floating,
          ));
      },
      builder: (context, state) {
        if (state.status == OtherUserProfileStatus.initial ||
            state.status == OtherUserProfileStatus.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF32DBE6)),
            ),
          );
        }

        if (state.status == OtherUserProfileStatus.failure &&
            state.profile == null) {
          return Scaffold(
            body: ErrorView(
              message: state.errorMessage ?? 'Failed to load profile.',
              onRetry: () =>
                  context.read<OtherUserProfileCubit>().loadProfile(),
            ),
          );
        }

        return _OtherUserProfileBody(
          profile: state.profile!,
          userId: userId,
        );
      },
    );
  }
}

class _OtherUserProfileBody extends StatelessWidget {
  const _OtherUserProfileBody({
    required this.profile,
    required this.userId,
  });

  final UserProfileModel profile;
  final String userId;

  bool get _isOwnProfile {
    final cached = CacheHelper.sharedPreferences.getString(ApiKey.userId);
    return cached != null && cached == userId;
  }

  void _openFollowList(BuildContext context, FollowTab initialTab) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FollowListScreen(
          userId: userId,
          isOwn: _isOwnProfile,
          initialTab: initialTab,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.r,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          profile.username,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderSection(
              profile: profile,
              isOwnProfile: _isOwnProfile,
              onFollowersTap: () =>
                  _openFollowList(context, FollowTab.followers),
              onFollowingTap: () =>
                  _openFollowList(context, FollowTab.following),
            ),
            _BioSection(profile: profile),
            SizedBox(height: 16.h),
            const Divider(height: 1),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 48.h),
                child: Column(
                  children: [
                    Icon(Icons.grid_on_rounded,
                        size: 48.r, color: Colors.grey[300]),
                    SizedBox(height: 12.h),
                    Text(
                      'No Posts Yet',
                      style:
                          TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.profile,
    required this.isOwnProfile,
    required this.onFollowersTap,
    required this.onFollowingTap,
  });

  final UserProfileModel profile;
  final bool isOwnProfile;
  final VoidCallback onFollowersTap;
  final VoidCallback onFollowingTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProfileAvatar(imageUrl: profile.profileImageUrl),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ProfileStatItem(
                      count: profile.numberOfPosts,
                      label: 'Posts',
                    ),
                    GestureDetector(
                      onTap: onFollowersTap,
                      child: ProfileStatItem(
                        count: profile.numberOfFollowers,
                        label: 'Followers',
                      ),
                    ),
                    GestureDetector(
                      onTap: onFollowingTap,
                      child: ProfileStatItem(
                        count: profile.numberOfFollowing,
                        label: 'Following',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isOwnProfile) ...[
            SizedBox(height: 12.h),
            const FollowButton(),
          ],
        ],
      ),
    );
  }
}

class _BioSection extends StatelessWidget {
  const _BioSection({required this.profile});

  final UserProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile.displayName,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          if (profile.bio != null && profile.bio!.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              profile.bio!,
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
            ),
          ],
        ],
      ),
    );
  }
}
