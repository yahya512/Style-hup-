import 'package:dx/Social-Media/chat/models/chat_conversation.dart';
import 'package:dx/Social-Media/chat/models/chat_message.dart';
import 'package:dx/core/api/api_client.dart';
import 'package:dx/core/api/endpoints.dart';

class ChatService {
  /// GET /chat/conversations
  Future<ConversationsPage> getConversations() async {
    final response = await ApiClient.instance.get<dynamic>(
      Endpoints.chatConversations,
    );
    final data = response.data;
    // Server may return a flat array or a paginated envelope.
    if (data is List) {
      return ConversationsPage.fromJson({'items': data});
    }
    return ConversationsPage.fromJson(data as Map<String, dynamic>);
  }

  /// POST /chat/conversations  { participantId }
  Future<ChatConversation> getOrCreateConversation(
    String participantId,
  ) async {
    final response = await ApiClient.instance.post<Map<String, dynamic>>(
      Endpoints.chatConversations,
      data: {'participantId': participantId},
    );
    return ChatConversation.fromJson(response.data!);
  }

  /// GET /chat/conversations/:id/messages?limit=&cursor=
  Future<MessagesPage> getMessages(
    String conversationId, {
    String? cursor,
    int limit = 20,
  }) async {
    final params = <String, dynamic>{'limit': limit};
    if (cursor != null) params['cursor'] = cursor;

    final response = await ApiClient.instance.get<Map<String, dynamic>>(
      Endpoints.conversationMessages(conversationId),
      queryParameters: params,
    );
    return MessagesPage.fromJson(response.data!);
  }

  /// POST /chat/messages  { recipientId, content }
  /// Creates a conversation automatically if one does not exist.
  Future<ChatMessage> sendDirectMessage(
    String recipientId,
    String content,
  ) async {
    final response = await ApiClient.instance.post<Map<String, dynamic>>(
      Endpoints.chatMessages,
      data: {'recipientId': recipientId, 'content': content},
    );
    return ChatMessage.fromJson(response.data!);
  }

  /// POST /chat/conversations/:id/messages  { content }
  Future<ChatMessage> sendMessage(
    String conversationId,
    String content,
  ) async {
    final response = await ApiClient.instance.post<Map<String, dynamic>>(
      Endpoints.conversationMessages(conversationId),
      data: {'content': content},
    );
    return ChatMessage.fromJson(response.data!);
  }

  /// PATCH /chat/conversations/:id/seen
  Future<void> markAsSeen(String conversationId) async {
    await ApiClient.instance.patch<void>(
      Endpoints.markConversationSeen(conversationId),
    );
  }
}
