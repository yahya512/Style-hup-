import 'package:equatable/equatable.dart';

enum NotificationType { newFollower, postLiked, postCommented }

class NotificationModel extends Equatable {
  const NotificationModel({
    required this.id,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.actorId,
    this.actorName,
    this.actorPhoto,
    this.postId,
    this.readAt,
  });

  final String id;
  final NotificationType type;
  final String? actorId;
  final String? actorName;
  final String? actorPhoto;
  final String? postId;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      type: _parseType(json['type'] as String),
      actorId: json['actorId'] as String?,
      actorName: json['actorName'] as String?,
      actorPhoto: json['actorPhoto'] as String?,
      postId: json['postId'] as String?,
      isRead: json['isRead'] as bool,
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  NotificationModel copyWith({bool? isRead, DateTime? readAt}) {
    return NotificationModel(
      id: id,
      type: type,
      actorId: actorId,
      actorName: actorName,
      actorPhoto: actorPhoto,
      postId: postId,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt,
    );
  }

  String get typeLabel => switch (type) {
        NotificationType.newFollower => 'New Follower',
        NotificationType.postLiked => 'Post Liked',
        NotificationType.postCommented => 'New Comment',
      };

  String get displayText {
    final name = actorName ?? 'Someone';
    return switch (type) {
      NotificationType.newFollower => '$name started following you',
      NotificationType.postLiked => '$name liked your post',
      NotificationType.postCommented => '$name commented on your post',
    };
  }

  static NotificationType _parseType(String raw) {
    return switch (raw) {
      'NEW_FOLLOWER' => NotificationType.newFollower,
      'POST_LIKED' => NotificationType.postLiked,
      'POST_COMMENTED' => NotificationType.postCommented,
      _ => NotificationType.newFollower,
    };
  }

  @override
  List<Object?> get props => [id, type, isRead, readAt, createdAt];
}
