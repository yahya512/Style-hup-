import 'package:dx/Social-Media/follow/models/follow_account.dart';

enum FollowListStatus { initial, loading, success, loadingMore, failure }

class FollowListState {
  const FollowListState({
    this.status = FollowListStatus.initial,
    this.items = const [],
    this.hasMore = true,
    this.offset = 0,
    this.errorMessage,
    this.errorCount = 0,
  });

  final FollowListStatus status;
  final List<FollowAccount> items;
  final bool hasMore;
  final int offset;
  final String? errorMessage;
  final int errorCount;

  bool get isLoadingMore => status == FollowListStatus.loadingMore;

  FollowListState copyWith({
    FollowListStatus? status,
    List<FollowAccount>? items,
    bool? hasMore,
    int? offset,
    String? errorMessage,
    int? errorCount,
  }) {
    return FollowListState(
      status: status ?? this.status,
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      errorMessage: errorMessage ?? this.errorMessage,
      errorCount: errorCount ?? this.errorCount,
    );
  }
}
