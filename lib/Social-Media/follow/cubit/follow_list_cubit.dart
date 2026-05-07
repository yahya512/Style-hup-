import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dx/Social-Media/follow/cubit/follow_list_state.dart';
import 'package:dx/Social-Media/follow/models/follow_list_response.dart';
import 'package:dx/Social-Media/follow/services/follow_service.dart';

enum FollowTab { followers, following }

class FollowListCubit extends Cubit<FollowListState> {
  FollowListCubit({
    required FollowService service,
    required this.userId,
    required this.isOwn,
    required this.tab,
  })  : _service = service,
        super(const FollowListState());

  final FollowService _service;
  final String userId;
  final bool isOwn;
  final FollowTab tab;

  static const int _limit = 15;

  Future<void> load() async {
    if (state.status == FollowListStatus.loading) return;
    emit(state.copyWith(
      status: FollowListStatus.loading,
      items: [],
      offset: 0,
      hasMore: true,
    ));
    await _fetchPage(offset: 0, append: false);
  }

  Future<void> loadMore() async {
    if (!state.hasMore) return;
    if (state.status == FollowListStatus.loadingMore ||
        state.status == FollowListStatus.loading) {
      return;
    }
    emit(state.copyWith(status: FollowListStatus.loadingMore));
    await _fetchPage(offset: state.offset, append: true);
  }

  Future<void> _fetchPage({required int offset, required bool append}) async {
    try {
      final page = await _fetchFromService(offset: offset);
      emit(state.copyWith(
        status: FollowListStatus.success,
        items: append ? [...state.items, ...page.items] : page.items,
        hasMore: page.hasMore,
        offset: offset + page.items.length,
      ));
    } catch (_) {
      emit(state.copyWith(
        status: append ? FollowListStatus.success : FollowListStatus.failure,
        errorMessage: 'Failed to load. Please try again.',
        errorCount: state.errorCount + 1,
      ));
    }
  }

  Future<FollowListResponse> _fetchFromService({required int offset}) {
    if (tab == FollowTab.followers) {
      return isOwn
          ? _service.getMyFollowers(limit: _limit, offset: offset)
          : _service.getUserFollowers(userId, limit: _limit, offset: offset);
    } else {
      return isOwn
          ? _service.getMyFollowing(limit: _limit, offset: offset)
          : _service.getUserFollowing(userId, limit: _limit, offset: offset);
    }
  }
}
