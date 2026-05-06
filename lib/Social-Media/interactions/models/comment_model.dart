class CommentModel {
  const CommentModel({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    this.authorImage,
    required this.content,
    required this.createdAt,
    this.updatedAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
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

    return CommentModel(
      id: json['id'] as String,
      postId: json['postId'] as String,
      authorId: json['authorId'] as String,
      authorName: authorName,
      authorImage: authorImage,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String? authorImage;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CommentModel copyWith({String? content, DateTime? updatedAt}) => CommentModel(
        id: id,
        postId: postId,
        authorId: authorId,
        authorName: authorName,
        authorImage: authorImage,
        content: content ?? this.content,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
