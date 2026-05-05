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
  });

  factory FeedPostModel.fromJson(Map<String, dynamic> json) => FeedPostModel(
        id: json['id'] as String,
        content: json['content'] as String?,
        images: List<String>.from(json['images'] as List? ?? const []),
        videos: List<String>.from(json['videos'] as List? ?? const []),
        authorId: json['authorId'] as String,
        authorName: json['authorName'] as String? ?? '',
        authorImage: json['authorImage'] as String?,
        visibility: _visibilityFromString(
          json['visibility'] as String? ?? 'PUBLIC',
        ),
        reactionsCount: (json['reactionsCount'] as num?)?.toInt() ?? 0,
        commentsCount: (json['commentsCount'] as num?)?.toInt() ?? 0,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

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
