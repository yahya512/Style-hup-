/// Mirrors the backend `PostVisibility` enum.
enum PostVisibility { public, followers, private }

PostVisibility _visibilityFromString(String raw) =>
    PostVisibility.values.firstWhere(
      (v) => v.name.toUpperCase() == raw.toUpperCase(),
      orElse: () => PostVisibility.public,
    );

/// Mirrors the backend `FeedItemType` enum.
enum FeedItemType { post, repost, share }

FeedItemType _feedItemTypeFromString(String raw) =>
    FeedItemType.values.firstWhere(
      (v) => v.name.toUpperCase() == raw.toUpperCase(),
      orElse: () => FeedItemType.post,
    );

/// Maps to the backend `FeedPostDto`.
class FeedPostModel {
  const FeedPostModel({
    required this.id,
    this.content,
    required this.images,
    required this.videos,
    required this.authorId,
    required this.authorName,
    this.authorImage,
    required this.visibility,
    required this.reactionsCount,
    required this.commentsCount,
    required this.createdAt,
    this.isReactedByMe = false,
  });

  factory FeedPostModel.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    String authorName = '';
    String? authorImage;

    if (author != null) {
      if (author['role'] == 'BRAND') {
        final bp = author['brandProfile'] as Map<String, dynamic>?;
        authorName = bp?['brandName'] as String? ?? '';
        authorImage = bp?['profileImageUrl'] as String?;
      } else {
        final up = author['userProfile'] as Map<String, dynamic>?;
        final first = up?['firstName'] as String? ?? '';
        final last = up?['lastName'] as String? ?? '';
        authorName = '$first $last'.trim();
        authorImage = up?['profileImageUrl'] as String?;
      }
    } else {
      authorName = json['authorName'] as String? ?? '';
      authorImage = json['authorImage'] as String?;
    }

    return FeedPostModel(
      id: json['id'] as String,
      content: json['content'] as String?,
      images: List<String>.from(json['images'] as List? ?? const []),
      videos: List<String>.from(json['videos'] as List? ?? const []),
      authorId: json['authorId'] as String,
      authorName: authorName,
      authorImage: authorImage,
      visibility: _visibilityFromString(
        json['visibility'] as String? ?? 'PUBLIC',
      ),
      reactionsCount: (json['reactionsCount'] as num?)?.toInt() ?? 0,
      commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isReactedByMe: json['isReactedByMe'] as bool? ?? false,
    );
  }

  final String id;
  final String? content;
  final List<String> images;
  final List<String> videos;
  final String authorId;
  final String authorName;
  final String? authorImage;
  final PostVisibility visibility;
  final int reactionsCount;
  final int commentsCount;
  final DateTime createdAt;
  final bool isReactedByMe;

  FeedPostModel copyWith({
    int? reactionsCount,
    int? commentsCount,
    bool? isReactedByMe,
  }) =>
      FeedPostModel(
        id: id,
        content: content,
        images: images,
        videos: videos,
        authorId: authorId,
        authorName: authorName,
        authorImage: authorImage,
        visibility: visibility,
        reactionsCount: reactionsCount ?? this.reactionsCount,
        commentsCount: commentsCount ?? this.commentsCount,
        createdAt: createdAt,
        isReactedByMe: isReactedByMe ?? this.isReactedByMe,
      );
}

/// Maps to the backend `FeedItemResponseDto`.
class FeedItemModel {
  const FeedItemModel({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.post,
  });

  factory FeedItemModel.fromJson(Map<String, dynamic> json) => FeedItemModel(
        id: json['id'] as String,
        type: _feedItemTypeFromString(json['type'] as String? ?? 'POST'),
        createdAt: DateTime.parse(json['createdAt'] as String),
        post: FeedPostModel.fromJson(
          json['post'] as Map<String, dynamic>,
        ),
      );

  final String id;
  final FeedItemType type;
  final DateTime createdAt;
  final FeedPostModel post;
}
