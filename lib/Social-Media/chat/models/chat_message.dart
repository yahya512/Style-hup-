class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.status,
    required this.createdAt,
    this.seenAt,
    this.isOptimistic = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'] as String,
        conversationId: json['conversationId'] as String,
        senderId: json['senderId'] as String,
        content: json['content'] as String,
        status: json['status'] as String? ?? 'SENT',
        seenAt: json['seenAt'] != null
            ? DateTime.tryParse(json['seenAt'] as String)
            : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  final String id;
  final String conversationId;
  final String senderId;
  final String content;

  /// SENT | DELIVERED | SEEN
  final String status;
  final DateTime? seenAt;
  final DateTime createdAt;

  /// True only for locally-inserted optimistic messages pending server echo.
  final bool isOptimistic;

  ChatMessage copyWith({
    String? id,
    String? status,
    bool? isOptimistic,
  }) =>
      ChatMessage(
        id: id ?? this.id,
        conversationId: conversationId,
        senderId: senderId,
        content: content,
        status: status ?? this.status,
        seenAt: seenAt,
        createdAt: createdAt,
        isOptimistic: isOptimistic ?? this.isOptimistic,
      );
}
