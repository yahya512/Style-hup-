import 'package:dx/Social-Media/shared/widgets/stylehub_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/Social-Media/feed/cubit/feed_cubit.dart';
import 'package:dx/Social-Media/feed/cubit/feed_state.dart';
import 'package:dx/Social-Media/feed/services/feed_service.dart';

import '../widgets/post_card.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FeedCubit(feedService: getIt<FeedService>())..loadFeed(),
      child: const FeedScreen(),
    );
  }
}

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ScrollController _scrollController = ScrollController();
  static const double _paginationThreshold = 300.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - _paginationThreshold) {
      context.read<FeedCubit>().loadMoreFeed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const StyleHubAppBar(), // Reusable App Bar injected here
      body: BlocConsumer<FeedCubit, FeedState>(
        listenWhen: (prev, curr) => curr.errorCount > prev.errorCount,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!), behavior: SnackBarBehavior.floating));
        },
        builder: (context, state) => switch (state.status) {
          FeedStatus.initial || FeedStatus.loading => const Center(child: CircularProgressIndicator(color: Color(0xFF32DBE6))),
          FeedStatus.failure when state.items.isEmpty => ErrorView(
              message: state.errorMessage ?? 'Failed to load your feed.',
              onRetry: () => context.read<FeedCubit>().loadFeed(),
            ),
          _ => _buildListView(state),
        },
      ),
    );
  }

  Widget _buildListView(FeedState state) {
    if (state.items.isEmpty) return const EmptyView();

    final showLoader = state.status == FeedStatus.loadingMore;
    final itemCount = state.items.length + (showLoader ? 1 : 0);

    return RefreshIndicator(
      color: const Color(0xFF32DBE6),
      onRefresh: () => context.read<FeedCubit>().refreshFeed(),
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 8.h, bottom: 32.h),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index == state.items.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: const Center(child: CircularProgressIndicator(color: Color(0xFF32DBE6))),
            );
          }
          return PostCard(item: state.items[index]);
        },
      ),
    );
  }
}