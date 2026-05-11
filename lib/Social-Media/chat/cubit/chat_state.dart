import 'package:dx/Social-Media/chat/models/chat_message.dart';

enum ChatStatus { initial, loading, success, failure }

class ChatState {
  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.nextCursor,
    this.hasMore = true,
    this.isTyping = false,
    this.isConnected = true,
    this.error,
    this.sendError,
  });

  final ChatStatus status;

  /// Display order: oldest at index 0, newest at last index (bottom of list).
  final List<ChatMessage> messages;

  /// Cursor for loading older messages. Null means beginning of history.
  final String? nextCursor;
  final bool hasMore;

  /// True when the other participant is currently typing.
  final bool isTyping;

  /// Reflects socket connection — send button disabled when false.
  final bool isConnected;

  final String? error;

  /// Non-null when an optimistic send failed — shown as a snackbar.
  final String? sendError;

  bool get isInitialLoading =>
      status == ChatStatus.loading && messages.isEmpty;

  ChatState copyWith({
    ChatStatus? status,
    List<ChatMessage>? messages,
    String? nextCursor,
    bool? hasMore,
    bool? isTyping,
    bool? isConnected,
    String? error,
    String? sendError,
    bool clearNextCursor = false,
    bool clearSendError = false,
  }) =>
      ChatState(
        status: status ?? this.status,
        messages: messages ?? this.messages,
        nextCursor:
            clearNextCursor ? null : (nextCursor ?? this.nextCursor),
        hasMore: hasMore ?? this.hasMore,
        isTyping: isTyping ?? this.isTyping,
        isConnected: isConnected ?? this.isConnected,
        error: error,
        sendError:
            clearSendError ? null : (sendError ?? this.sendError),
      );
}
