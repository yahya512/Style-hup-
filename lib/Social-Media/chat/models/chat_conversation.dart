import 'package:dx/Social-Media/chat/models/chat_message.dart';

class ChatConversation {
  const ChatConversation({
    required this.id,
    required this.otherParticipantId,
    required this.unreadCount,
    required this.createdAt,
    this.lastMessageAt,
    this.otherParticipantName,
    this.otherParticipantAvatar,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) =>
      ChatConversation(
        id: json['id'] as String,
        otherParticipantId: json['otherParticipantId'] as String,
        unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
        createdAt: DateTime.parse(json['createdAt'] as String),
        lastMessageAt: json['lastMessageAt'] != null
            ? DateTime.tryParse(json['lastMessageAt'] as String)
            : null,
      );

  final String id;
  final String otherParticipantId;
  final int unreadCount;
  final DateTime createdAt;
  final DateTime? lastMessageAt;

  /// Populated after fetching the other participant's profile via
  /// OtherUserProfileService.getProfile(otherParticipantId).
  /// Works for both USER and BRAND accounts.
  final String? otherParticipantName;
  final String? otherParticipantAvatar;

  ChatConversation copyWith({
    int? unreadCount,
    DateTime? lastMessageAt,
    String? otherParticipantName,
    String? otherParticipantAvatar,
  }) =>
      ChatConversation(
        id: id,
        otherParticipantId: otherParticipantId,
        unreadCount: unreadCount ?? this.unreadCount,
        createdAt: createdAt,
        lastMessageAt: lastMessageAt ?? this.lastMessageAt,
        otherParticipantName:
            otherParticipantName ?? this.otherParticipantName,
        otherParticipantAvatar:
            otherParticipantAvatar ?? this.otherParticipantAvatar,
      );
}

class ConversationsPage {
  const ConversationsPage({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory ConversationsPage.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return ConversationsPage(
      items: rawItems
          .map((e) => ChatConversation.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt() ?? rawItems.length,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? rawItems.length,
    );
  }

  final List<ChatConversation> items;
  final int total;
  final int page;
  final int limit;
}

class MessagesPage {
  const MessagesPage({required this.items, this.nextCursor});

  factory MessagesPage.fromJson(Map<String, dynamic> json) => MessagesPage(
        items: (json['items'] as List<dynamic>)
            .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
            .toList(),
        nextCursor: json['nextCursor'] as String?,
      );

  final List<ChatMessage> items;
  final String? nextCursor;
}
