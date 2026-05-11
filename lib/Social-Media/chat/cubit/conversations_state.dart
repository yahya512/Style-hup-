import 'package:dx/Social-Media/chat/models/chat_conversation.dart';
import 'package:dx/Social-Media/follow/models/follow_account.dart';

enum ConversationsStatus { initial, loading, success, failure }

class ConversationsState {
  const ConversationsState({
    this.status = ConversationsStatus.initial,
    this.conversations = const [],
    this.people = const [],
    this.error,
    this.hasMore = false,
  });

  final ConversationsStatus status;
  final List<ChatConversation> conversations;
  /// Merged followers + following, deduplicated by id.
  final List<FollowAccount> people;
  final String? error;
  final bool hasMore;

  bool get isInitialLoading =>
      status == ConversationsStatus.loading && conversations.isEmpty;

  ConversationsState copyWith({
    ConversationsStatus? status,
    List<ChatConversation>? conversations,
    List<FollowAccount>? people,
    String? error,
    bool? hasMore,
  }) =>
      ConversationsState(
        status: status ?? this.status,
        conversations: conversations ?? this.conversations,
        people: people ?? this.people,
        error: error,
        hasMore: hasMore ?? this.hasMore,
      );
}
