import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/Social-Media/brand/models/brand_profile_model.dart';
import 'package:dx/Social-Media/brand/services/brand_profile_service.dart';
import 'package:dx/Social-Media/feed/models/post_model.dart';
import 'package:dx/Social-Media/follow/cubit/follow_button_cubit.dart';
import 'package:dx/Social-Media/follow/cubit/follow_list_cubit.dart';
import 'package:dx/Social-Media/follow/screens/follow_list_screen.dart';
import 'package:dx/Social-Media/follow/services/follow_service.dart';
import 'package:dx/Social-Media/follow/widgets/follow_button.dart';
import 'package:dx/Social-Media/brand/widgets/visit_store_button.dart';
import 'package:dx/Social-Media/profile_posts/services/my_posts_service.dart';
import 'package:dx/Social-Media/shared/widgets/profile_avatar.dart';
import 'package:dx/Social-Media/shared/widgets/profile_stat_item.dart';
import 'package:dx/Social-Media/user/widgets/post_card.dart';

class OtherBrandProfilePage extends StatelessWidget {
  const OtherBrandProfilePage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FollowButtonCubit(
        service: getIt<FollowService>(),
        targetUserId: userId,
      )..init(),
      child: _OtherBrandProfileContent(userId: userId),
    );
  }
}

class _OtherBrandProfileContent extends StatefulWidget {
  const _OtherBrandProfileContent({required this.userId});

  final String userId;

  @override
  State<_OtherBrandProfileContent> createState() =>
      _OtherBrandProfileContentState();
}

class _OtherBrandProfileContentState extends State<_OtherBrandProfileContent> {
  late final Future<(BrandProfileModel, List<FeedPostModel>)> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.wait([
      getIt<BrandProfileService>().getOtherBrandProfile(widget.userId),
      getIt<MyPostsService>()
          .getPostsByUser(widget.userId, limit: 30)
          .then((page) => page.items),
    ]).then((results) => (
          results[0] as BrandProfileModel,
          results[1] as List<FeedPostModel>,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(BrandProfileModel, List<FeedPostModel>)>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF32DBE6)),
            ),
          );
        }
        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: const BackButton(color: Colors.black),
            ),
            body: Center(
              child: Text(
                'Failed to load profile.',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
            ),
          );
        }

        final (profile, posts) = snapshot.data!;
        return _OtherBrandProfileBody(
          profile: profile,
          posts: posts,
          userId: widget.userId,
        );
      },
    );
  }
}

class _OtherBrandProfileBody extends StatelessWidget {
  const _OtherBrandProfileBody({
    required this.profile,
    required this.posts,
    required this.userId,
  });

  final BrandProfileModel profile;
  final List<FeedPostModel> posts;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 20.r, color: Colors.black),
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
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ProfileAvatar(
                        imageUrl: profile.profileImageUrl,
                        defaultIcon: Icons.store,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ProfileStatItem(
                                count: profile.numberOfPosts, label: 'Posts'),
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => FollowListScreen(
                                    userId: userId,
                                    isOwn: false,
                                    initialTab: FollowTab.followers,
                                  ),
                                ),
                              ),
                              child: ProfileStatItem(
                                  count: profile.numberOfFollowers,
                                  label: 'Followers'),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => FollowListScreen(
                                    userId: userId,
                                    isOwn: false,
                                    initialTab: FollowTab.following,
                                  ),
                                ),
                              ),
                              child: ProfileStatItem(
                                  count: profile.numberOfFollowing,
                                  label: 'Following'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  const FollowButton(),
                  SizedBox(height: 10.h),
                  VisitStoreButton(brandId: userId),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.brandName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '@${profile.username}',
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                  ),
                  if (profile.bio != null && profile.bio!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(profile.bio!,
                        style: TextStyle(
                            fontSize: 14.sp, color: Colors.black87)),
                  ],
                  if (profile.websiteUrl != null &&
                      profile.websiteUrl!.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.language_outlined,
                            size: 14.r, color: Colors.grey[600]),
                        SizedBox(width: 4.w),
                        Text(profile.websiteUrl!,
                            style: TextStyle(
                                fontSize: 13.sp, color: Colors.blue[700])),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 8.h),
            const Divider(height: 1),
            if (posts.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 48.h),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.grid_on_rounded,
                          size: 48.r, color: Colors.grey[300]),
                      SizedBox(height: 12.h),
                      Text('No Posts Yet',
                          style: TextStyle(
                              fontSize: 14.sp, color: Colors.grey[500])),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                height: 400.h,
                child: ProfilePostsGrid(posts: posts),
              ),
          ],
        ),
      ),
    );
  }
}
