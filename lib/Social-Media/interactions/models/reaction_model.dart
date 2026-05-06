class ReactionModel {
  const ReactionModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.createdAt,
  });

  factory ReactionModel.fromJson(Map<String, dynamic> json) => ReactionModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        userName: json['userName'] as String? ?? '',
        userImage: json['userImage'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  final String id;
  final String userId;
  final String userName;
  final String? userImage;
  final DateTime createdAt;
}
