import 'package:equatable/equatable.dart';
import 'package:dx/Social-Media/feed/models/post_model.dart';

enum MyPostsStatus {
  initial,
  loading, // first load — list is empty
  refreshing, // pull-to-refresh — old list still visible
  loadingMore, // appending next page
  success,
  failure,
}

class MyPostsState extends Equatable {
  const MyPostsState({
    required this.status,
    required this.posts,
    required this.hasMore,
    required this.offset,
    this.errorMessage,
    this.errorCount = 0,
  });

  const MyPostsState.initial()
      : status = MyPostsStatus.initial,
        posts = const [],
        hasMore = true,
        offset = 0,
        errorMessage = null,
        errorCount = 0;

  final MyPostsStatus status;
  final List<FeedPostModel> posts;

  /// Whether there are more pages to load.
  final bool hasMore;

  /// Current offset for the next request (= total items loaded so far).
  final int offset;

  /// Non-null when an error should be surfaced to the UI.
  final String? errorMessage;

  /// Incremented on every error emit so the listener fires even when the
  /// message text repeats.
  final int errorCount;

  MyPostsState copyWith({
    MyPostsStatus? status,
    List<FeedPostModel>? posts,
    bool? hasMore,
    int? offset,
    String? errorMessage,
    int? errorCount,
  }) {
    return MyPostsState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      errorMessage: errorMessage,
      errorCount: errorCount ?? this.errorCount,
    );
  }

  @override
  List<Object?> get props =>
      [status, posts, hasMore, offset, errorMessage, errorCount];
}
