import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/Social-Media/follow/cubit/follow_list_cubit.dart';
import 'package:dx/Social-Media/follow/screens/follow_list_screen.dart';
import 'package:dx/Social-Media/shared/widgets/profile_app_bar.dart';
import 'package:dx/Social-Media/shared/widgets/profile_avatar.dart';
import 'package:dx/Social-Media/shared/widgets/profile_stat_item.dart';
import 'package:dx/Social-Media/shared/widgets/profile_tab_delegate.dart';
import 'package:dx/Social-Media/brand/cubit/brand_profile_cubit.dart';
import 'package:dx/Social-Media/brand/cubit/brand_profile_state.dart';
import 'package:dx/Social-Media/brand/models/brand_profile_model.dart';
import 'package:dx/Social-Media/brand/services/brand_profile_service.dart';
import 'package:dx/Social-Media/brand/widgets/brand_edit_bottom_sheet.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/Social-Media/feed/widgets/error_view.dart';
import 'package:dx/Social-Media/profile_posts/cubit/my_posts_cubit.dart';
import 'package:dx/Social-Media/profile_posts/cubit/my_posts_state.dart';
import 'package:dx/Social-Media/user/widgets/post_card.dart';

class BrandProfilePage extends StatelessWidget {
  const BrandProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          BrandProfileCubit(service: getIt<BrandProfileService>())
            ..loadProfile(),
      child: const BrandProfileScreen(),
    );
  }
}

class BrandProfileScreen extends StatelessWidget {
  const BrandProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BrandProfileCubit, BrandProfileState>(
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
      builder: (context, state) => switch (state.status) {
        BrandProfileStatus.initial ||
        BrandProfileStatus.loading =>
          const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF32DBE6)),
            ),
          ),
        BrandProfileStatus.failure when state.profile == null => Scaffold(
            body: ErrorView(
              message: state.errorMessage ?? 'Failed to load profile.',
              onRetry: () => context.read<BrandProfileCubit>().loadProfile(),
            ),
          ),
        _ => _BrandProfileBody(state: state),
      },
    );
  }
}

class _BrandProfileBody extends StatelessWidget {
  const _BrandProfileBody({required this.state});

  final BrandProfileState state;

  @override
  Widget build(BuildContext context) {
    final profile = state.profile;
    if (profile == null) return const SizedBox.shrink();
    final isUpdating = state.status == BrandProfileStatus.updating;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: ProfileAppBar(
          username: profile.username,
          isUpdating: isUpdating,
          onEdit: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            builder: (_) => BlocProvider.value(
              value: context.read<BrandProfileCubit>(),
              child: BrandEditBottomSheet(profile: profile),
            ),
          ),
        ),
        body: RefreshIndicator(
          color: const Color(0xFF32DBE6),
          onRefresh: () async {
            context.read<BrandProfileCubit>().loadProfile();
            await context.read<MyPostsCubit>().refreshPosts();
          },
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BrandHeaderSection(profile: profile, onAddImage: () async {
                      final picked = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (picked != null && context.mounted) {
                        context
                            .read<BrandProfileCubit>()
                            .uploadImage(File(picked.path));
                      }
                    }),
                    _BrandBioSection(profile: profile),
                  ],
                ),
              ),
              const SliverPersistentHeader(
                pinned: true,
                delegate: ProfileTabBarDelegate(
                  tabs: [
                    Tab(icon: Icon(Icons.grid_on_rounded, color: Colors.black)),
                    Tab(
                        icon: Icon(Icons.shopping_bag_outlined,
                            color: Colors.black54)),
                  ],
                ),
              ),
            ],
            body: TabBarView(
              children: [
                BlocBuilder<MyPostsCubit, MyPostsState>(
                  builder: (context, postsState) {
                    if (postsState.status == MyPostsStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF32DBE6),
                        ),
                      );
                    }
                    if (postsState.status == MyPostsStatus.failure &&
                        postsState.posts.isEmpty) {
                      return ErrorView(
                        message: postsState.errorMessage ??
                            'Failed to load posts.',
                        onRetry: () =>
                            context.read<MyPostsCubit>().loadPosts(),
                      );
                    }
                    return ProfilePostsGrid(
                      posts: postsState.posts,
                      isLoadingMore:
                          postsState.status == MyPostsStatus.loadingMore,
                      hasMore: postsState.hasMore,
                      onLoadMore: () =>
                          context.read<MyPostsCubit>().loadMorePosts(),
                      onPostDelete: (postId) =>
                          context.read<MyPostsCubit>().deletePostWithApi(postId),
                      onPostEdit: (postId, content, visibility) => context
                          .read<MyPostsCubit>()
                          .editPostWithApi(postId, content: content, visibility: visibility),
                    );
                  },
                ),
                const ProfileEmptyState(
                    icon: Icons.shopping_bag_outlined,
                    label: 'No Products Yet'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandHeaderSection extends StatelessWidget {
  const _BrandHeaderSection({
    required this.profile,
    required this.onAddImage,
  });

  final BrandProfileModel profile;
  final VoidCallback onAddImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
      child: Row(
        children: [
          ProfileAvatar(
            imageUrl: profile.profileImageUrl,
            onTap: onAddImage,
            defaultIcon: Icons.store,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ProfileStatItem(
                    count: profile.numberOfPosts,
                    label: 'Posts',
                    formatted: true),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FollowListScreen(
                        userId: profile.id,
                        isOwn: true,
                        initialTab: FollowTab.followers,
                      ),
                    ),
                  ),
                  child: ProfileStatItem(
                      count: profile.numberOfFollowers,
                      label: 'Followers',
                      formatted: true),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FollowListScreen(
                        userId: profile.id,
                        isOwn: true,
                        initialTab: FollowTab.following,
                      ),
                    ),
                  ),
                  child: ProfileStatItem(
                      count: profile.numberOfFollowing,
                      label: 'Following',
                      formatted: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandBioSection extends StatelessWidget {
  const _BrandBioSection({required this.profile});

  final BrandProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile.brandName,
            style: AppStyles.normalTextStyle,
          ),
          Text(
            '@${profile.username}',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
          if (profile.bio != null && profile.bio!.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              profile.bio!,
              style: TextStyle(
                  fontSize: 16.sp, color: Colors.black, height: 1.3),
            ),
          ],
          if (profile.websiteUrl != null &&
              profile.websiteUrl!.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(Icons.language_outlined,
                    size: 16.r, color: Colors.grey[600]),
                SizedBox(width: 4.w),
                Text(
                  profile.websiteUrl!,
                  style: TextStyle(fontSize: 14.sp, color: Colors.blue[700]),
                ),
              ],
            ),
          ],
          if (profile.phoneNumber != null &&
              profile.phoneNumber!.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(Icons.phone_outlined,
                    size: 16.r, color: Colors.grey[600]),
                SizedBox(width: 4.w),
                Text(
                  profile.phoneNumber!,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
