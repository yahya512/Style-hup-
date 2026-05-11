import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  SocketService({required this.baseUrl});

  final String baseUrl;
  io.Socket? _socket;

  /// Connect with the user's JWT access token.
  /// Call once after login.
  void connect(String accessToken) {
    if (_socket?.connected ?? false) return;

    _socket = io.io(
      baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': accessToken})
          .build(),
    );

    _socket!.onConnect((_) {
      // ignore: avoid_print
      print('[Socket] Connected');
    });
    _socket!.onDisconnect((_) {
      // ignore: avoid_print
      print('[Socket] Disconnected');
    });
    _socket!.onConnectError((err) {
      // ignore: avoid_print
      print('[Socket] Connection error: $err');
    });

    _socket!.connect();
  }

  /// Register a listener for the `notification` event.
  void onNotification(void Function(Map<String, dynamic> data) handler) {
    _socket?.on('notification', (raw) {
      if (raw is Map<String, dynamic>) handler(raw);
    });
  }

  /// Remove the `notification` listener.
  void offNotification() {
    _socket?.off('notification');
  }

  // ── Chat events ────────────────────────────────────────────────────────────

  /// Extracts a Map payload whether socket.io delivered it directly or
  /// wrapped it in a single-element List.
  static Map<String, dynamic>? _toMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is List && raw.isNotEmpty && raw.first is Map<String, dynamic>) {
      return raw.first as Map<String, dynamic>;
    }
    return null;
  }

  /// Listens for incoming messages: `chat:message` → MessageResponseDto shape.
  void onChatMessage(void Function(Map<String, dynamic> data) handler) {
    _socket?.on('chat:message', (raw) {
      final data = _toMap(raw);
      if (data != null) handler(data);
    });
  }

  /// Listens for status updates: `chat:status` → {messageId, status, timestamp}.
  /// Calls off first so reopening a chat screen never accumulates stale handlers.
  void onChatStatus(void Function(Map<String, dynamic> data) handler) {
    _socket?.off('chat:status');
    _socket?.on('chat:status', (raw) {
      final data = _toMap(raw);
      if (data != null) handler(data);
    });
  }

  /// Listens for typing events: `chat:typing` → {userId, conversationId, isTyping}.
  void onChatTyping(void Function(Map<String, dynamic> data) handler) {
    _socket?.off('chat:typing');
    _socket?.on('chat:typing', (raw) {
      final data = _toMap(raw);
      if (data != null) handler(data);
    });
  }

  /// Listens for server-side chat errors: `chat:error` → {message}.
  void onChatError(void Function(Map<String, dynamic> data) handler) {
    _socket?.off('chat:error');
    _socket?.on('chat:error', (raw) {
      final data = _toMap(raw);
      if (data != null) handler(data);
    });
  }

  /// Removes all chat event listeners — call on logout.
  void offChatEvents() {
    _socket?.off('chat:message');
    _socket?.off('chat:status');
    _socket?.off('chat:typing');
    _socket?.off('chat:error');
  }

  /// Removes only the per-conversation listeners owned by ChatCubit.
  /// Leaves chat:message intact for ConversationsCubit.
  void offChatConversationEvents() {
    _socket?.off('chat:status');
    _socket?.off('chat:typing');
    _socket?.off('chat:error');
  }

  /// Emits `chat:typing` — call while user is typing or after idle stop.
  void emitChatTyping(String conversationId, {required bool isTyping}) {
    _socket?.emit('chat:typing', {
      'conversationId': conversationId,
      'isTyping': isTyping,
    });
  }

  /// Emits `chat:seen` — call when user opens or focuses a conversation.
  void emitChatSeen(String conversationId) {
    _socket?.emit('chat:seen', {'conversationId': conversationId});
  }

  /// Emits `chat:send` — WebSocket alternative to the REST send endpoint.
  void emitChatSend(String conversationId, String content) {
    _socket?.emit('chat:send', {
      'conversationId': conversationId,
      'content': content,
    });
  }

  /// Call on logout.
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  bool get isConnected => _socket?.connected ?? false;
}
