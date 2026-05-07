import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/Social-Media/follow/cubit/follow_list_cubit.dart';
import 'package:dx/Social-Media/follow/cubit/follow_list_state.dart';
import 'package:dx/Social-Media/follow/services/follow_service.dart';
import 'package:dx/Social-Media/follow/widgets/follow_account_tile.dart';
import 'package:dx/Social-Media/user/screens/other_user_profile_screen.dart';

class FollowListScreen extends StatefulWidget {
  const FollowListScreen({
    super.key,
    required this.userId,
    required this.isOwn,
    required this.initialTab,
  });

  final String userId;
  final bool isOwn;
  final FollowTab initialTab;

  @override
  State<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late FollowListCubit _followersCubit;
  late FollowListCubit _followingCubit;
  final _followersScroll = ScrollController();
  final _followingScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab == FollowTab.followers ? 0 : 1,
    );

    _followersCubit = FollowListCubit(
      service: getIt<FollowService>(),
      userId: widget.userId,
      isOwn: widget.isOwn,
      tab: FollowTab.followers,
    )..load();

    _followingCubit = FollowListCubit(
      service: getIt<FollowService>(),
      userId: widget.userId,
      isOwn: widget.isOwn,
      tab: FollowTab.following,
    )..load();

    _followersScroll.addListener(_onFollowersScroll);
    _followingScroll.addListener(_onFollowingScroll);
  }

  void _onFollowersScroll() {
    if (_followersScroll.position.pixels >=
        _followersScroll.position.maxScrollExtent - 200) {
      _followersCubit.loadMore();
    }
  }

  void _onFollowingScroll() {
    if (_followingScroll.position.pixels >=
        _followingScroll.position.maxScrollExtent - 200) {
      _followingCubit.loadMore();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _followersScroll.dispose();
    _followingScroll.dispose();
    _followersCubit.close();
    _followingCubit.close();
    super.dispose();
  }

  void _navigateToProfile(BuildContext context, String userId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OtherUserProfilePage(userId: userId),
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
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF32DBE6),
          tabs: const [Tab(text: 'Followers'), Tab(text: 'Following')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BlocBuilder<FollowListCubit, FollowListState>(
            bloc: _followersCubit,
            builder: (context, state) => _FollowList(
              state: state,
              tab: FollowTab.followers,
              scrollController: _followersScroll,
              onRetry: _followersCubit.load,
              onTapAccount: (id) => _navigateToProfile(context, id),
            ),
          ),
          BlocBuilder<FollowListCubit, FollowListState>(
            bloc: _followingCubit,
            builder: (context, state) => _FollowList(
              state: state,
              tab: FollowTab.following,
              scrollController: _followingScroll,
              onRetry: _followingCubit.load,
              onTapAccount: (id) => _navigateToProfile(context, id),
            ),
          ),
        ],
      ),
    );
  }
}

class _FollowList extends StatelessWidget {
  const _FollowList({
    required this.state,
    required this.tab,
    required this.scrollController,
    required this.onRetry,
    required this.onTapAccount,
  });

  final FollowListState state;
  final FollowTab tab;
  final ScrollController scrollController;
  final VoidCallback onRetry;
  final void Function(String userId) onTapAccount;

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      FollowListStatus.initial || FollowListStatus.loading => const Center(
          child: CircularProgressIndicator(color: Color(0xFF32DBE6)),
        ),
      FollowListStatus.failure when state.items.isEmpty => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.errorMessage ?? 'Failed to load.',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 12.h),
              TextButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      _ when state.items.isEmpty => Center(
          child: Text(
            tab == FollowTab.followers
                ? 'No followers yet'
                : 'Not following anyone yet',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
        ),
      _ => ListView.builder(
          controller: scrollController,
          itemCount: state.items.length + (state.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.items.length) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF32DBE6),
                  ),
                ),
              );
            }
            final account = state.items[index];
            return FollowAccountTile(
              account: account,
              onTap: () => onTapAccount(account.id),
            );
          },
        ),
    };
  }
}
