import 'dart:io';
import 'package:dx/Social-Media/feed/widgets/error_view.dart';
import 'package:dx/Social-Media/follow/cubit/follow_list_cubit.dart';
import 'package:dx/Social-Media/follow/screens/follow_list_screen.dart';
import 'package:dx/Social-Media/profile_posts/cubit/my_posts_cubit.dart';
import 'package:dx/Social-Media/profile_posts/cubit/my_posts_state.dart';
import 'package:dx/Social-Media/shared/widgets/profile_tab_delegate.dart';
import 'package:dx/Social-Media/user/cubit/user_profile_cubit.dart';
import 'package:dx/Social-Media/user/widgets/profile_app_bar.dart';
import 'package:dx/Social-Media/user/widgets/user_edit_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dx/Social-Media/user/models/user_profile_model.dart';
import 'package:dx/Social-Media/user/widgets/profile_header.dart';
import 'package:dx/Social-Media/user/widgets/bio.dart';
import 'package:dx/Social-Media/user/widgets/post_card.dart';

class UserProfileBody extends StatelessWidget {
  const UserProfileBody({super.key, required this.profile});

  final UserProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: ProfileAppBar(
          username: profile.username,
          onEdit: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            builder: (_) => BlocProvider.value(
              value: context.read<UserProfileCubit>(),
              child: UserEditBottomSheet(profile: profile),
            ),
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeaderSection(
                    profileImageUrl: profile.profileImageUrl,
                    posts: profile.numberOfPosts,
                    followers: profile.numberOfFollowers,
                    following: profile.numberOfFollowing,
                    onFollowersTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FollowListScreen(
                          userId: profile.id,
                          isOwn: true,
                          initialTab: FollowTab.followers,
                        ),
                      ),
                    ),
                    onFollowingTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FollowListScreen(
                          userId: profile.id,
                          isOwn: true,
                          initialTab: FollowTab.following,
                        ),
                      ),
                    ),
                    onAddImage: () async {
                      final picked = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (picked != null && context.mounted) {
                        context
                            .read<UserProfileCubit>()
                            .uploadImage(File(picked.path));
                      }
                    },
                  ),
                  ProfileBio(name: profile.displayName, bio: profile.bio),
                ],
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: const ProfileTabBarDelegate(
                tabs: [
                  Tab(icon: Icon(Icons.grid_on_rounded, color: Colors.black)),
                  Tab(
                      icon: Icon(Icons.slow_motion_video_rounded,
                          color: Colors.black54)),
                  Tab(
                      icon: Icon(Icons.person_pin_outlined,
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
                  return RefreshIndicator(
                    color: const Color(0xFF32DBE6),
                    onRefresh: () async {
                      context.read<UserProfileCubit>().loadProfile();
                      await context.read<MyPostsCubit>().refreshPosts();
                    },
                    child: ProfilePostsGrid(
                      posts: postsState.posts,
                      isLoadingMore:
                          postsState.status == MyPostsStatus.loadingMore,
                      hasMore: postsState.hasMore,
                      onLoadMore: () =>
                          context.read<MyPostsCubit>().loadMorePosts(),
                    ),
                  );
                },
              ),
              const ProfileEmptyState(
                  icon: Icons.slow_motion_video_rounded,
                  label: 'No Reels Yet'),
              const ProfileEmptyState(
                  icon: Icons.person_pin_outlined, label: 'No Tagged Posts'),
            ],
          ),
        ),
      ),
    );
  }
}
