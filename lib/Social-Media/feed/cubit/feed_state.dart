import 'package:equatable/equatable.dart';
import 'package:dx/Social-Media/feed/models/post_model.dart';

enum FeedStatus {
  initial,
  loading, // first load — list is empty
  refreshing, // pull-to-refresh — old list still visible
  loadingMore, // appending next page
  success,
  failure,
}

class FeedState extends Equatable {
  const FeedState({
    required this.status,
    required this.items,
    required this.hasMore,
    required this.offset,
    this.errorMessage,
    this.errorCount = 0,
  });

  const FeedState.initial()
      : status = FeedStatus.initial,
        items = const [],
        hasMore = true,
        offset = 0,
        errorMessage = null,
        errorCount = 0;

  final FeedStatus status;
  final List<FeedItemModel> items;

  /// Whether there are more pages to load.
  final bool hasMore;

  /// Current offset for the next request (= total items loaded so far).
  final int offset;

  /// Non-null when an error should be surfaced to the UI.
  final String? errorMessage;

  /// Incremented on every error emit so the listener fires even when the
  /// message text repeats (e.g. two consecutive network failures).
  final int errorCount;

  FeedState copyWith({
    FeedStatus? status,
    List<FeedItemModel>? items,
    bool? hasMore,
    int? offset,
    String? errorMessage,
    int? errorCount,
  }) {
    return FeedState(
      status: status ?? this.status,
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      errorMessage: errorMessage,
      errorCount: errorCount ?? this.errorCount,
    );
  }

  @override
  List<Object?> get props =>
      [status, items, hasMore, offset, errorMessage, errorCount];
}
