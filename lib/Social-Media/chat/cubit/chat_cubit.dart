import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dx/Social-Media/chat/cubit/chat_state.dart';
import 'package:dx/Social-Media/chat/models/chat_message.dart';
import 'package:dx/Social-Media/chat/services/chat_service.dart';
import 'package:dx/Social-Media/notifications/services/socket_service.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required this.conversationId,
    required this.currentUserId,
    required ChatService chatService,
    required SocketService socketService,
  })  : _chatService = chatService,
        _socketService = socketService,
        super(const ChatState());

  final String conversationId;
  final String currentUserId;

  final ChatService _chatService;
  final SocketService _socketService;

  /// Temp id of the in-flight optimistic message.
  String? _optimisticId;

  /// Buffers status events that arrive before the server echo replaces the
  /// optimistic bubble. Key = real message UUID, value = status string.
  final _pendingStatuses = <String, String>{};

  static const _statusRank = {'SENT': 0, 'DELIVERED': 1, 'SEEN': 2};

  /// Typing debounce: fires stop-typing after 1.5 s of idle.
  Timer? _typingTimer;

  /// Auto-clear other user's typing indicator after 3 s with no new event.
  Timer? _typingClearTimer;

  static const int _limit = 20;

  // ── Socket ─────────────────────────────────────────────────────────────────

  void startListening() {
    _socketService.onChatMessage(_onMessage);
    _socketService.onChatStatus(_onStatus);
    _socketService.onChatTyping(_onTyping);
    _socketService.onChatError(_onError);
  }

  void stopListening() {
    _typingTimer?.cancel();
    _typingClearTimer?.cancel();
  }

  void _onMessage(Map<String, dynamic> data) {
    if (isClosed) return;
    final incoming = ChatMessage.fromJson(data);
    if (incoming.conversationId != conversationId) return;

    final msgs = List<ChatMessage>.from(state.messages);

    // Replace optimistic placeholder with confirmed server message.
    if (_optimisticId != null && incoming.senderId == currentUserId) {
      final idx = msgs.indexWhere((m) => m.id == _optimisticId);
      if (idx != -1) {
        // Apply any buffered status that arrived before this echo.
        final buffered = _pendingStatuses.remove(incoming.id);
        final confirmed = buffered != null
            ? incoming.copyWith(status: buffered)
            : incoming;
        msgs[idx] = confirmed;
        _optimisticId = null;
        emit(state.copyWith(messages: msgs));
        return;
      }
    }

    // Avoid duplicates (server may echo our own send via REST).
    if (msgs.any((m) => m.id == incoming.id)) return;

    msgs.add(incoming);

    // Auto-emit seen for messages from the other user so the sender's
    // bubble updates to blue ✓✓ immediately when both are in the chat.
    if (incoming.senderId != currentUserId) {
      _socketService.emitChatSeen(conversationId);
    }

    emit(state.copyWith(messages: msgs));
  }

  void _onStatus(Map<String, dynamic> data) {
    if (isClosed) return;
    // ignore: avoid_print
    print('[STATUS] event received: $data');

    final messageId = data['messageId'] as String?;
    final newStatus = data['status'] as String?;
    // ignore: avoid_print
    print('[STATUS] messageId=$messageId newStatus=$newStatus');

    if (messageId == null || newStatus == null) {
      // ignore: avoid_print
      print('[STATUS] null fields, returning');
      return;
    }

    final msgs = state.messages;
    // ignore: avoid_print
    print('[STATUS] messages in state: ${msgs.length}');

    final index = msgs.indexWhere((m) => m.id == messageId);
    // ignore: avoid_print
    print('[STATUS] index found: $index');

    if (index == -1) {
      // ignore: avoid_print
      print('[STATUS] not found, buffering in _pendingStatuses');
      _pendingStatuses[messageId] = newStatus;
      return;
    }

    final current = msgs[index];
    // ignore: avoid_print
    print('[STATUS] current status: ${current.status}, new: $newStatus');

    // Never downgrade: SEEN(2) > DELIVERED(1) > SENT(0).
    if ((_statusRank[newStatus] ?? 0) <= (_statusRank[current.status] ?? 0)) {
      // ignore: avoid_print
      print('[STATUS] no upgrade needed, ignoring');
      return;
    }

    final updated = List<ChatMessage>.from(msgs);
    updated[index] = current.copyWith(status: newStatus);
    // ignore: avoid_print
    print('[STATUS] emitting updated state');
    emit(state.copyWith(messages: updated));
  }

  void _onTyping(Map<String, dynamic> data) {
    if (isClosed) return;
    final convId = data['conversationId'] as String?;
    if (convId != conversationId) return;

    final userId = data['userId'] as String?;
    if (userId == currentUserId) return; // ignore our own typing echo

    final isTyping = data['isTyping'] as bool? ?? false;
    _typingClearTimer?.cancel();
    emit(state.copyWith(isTyping: isTyping));

    if (isTyping) {
      // Auto-clear after 3 s if stop event is missed.
      _typingClearTimer = Timer(const Duration(seconds: 3), () {
        if (!isClosed) emit(state.copyWith(isTyping: false));
      });
    }
  }

  void _onError(Map<String, dynamic> data) {
    if (isClosed) return;
    if (_optimisticId != null) {
      final msgs =
          state.messages.where((m) => m.id != _optimisticId).toList();
      _optimisticId = null;
      emit(state.copyWith(
        messages: msgs,
        sendError: data['message'] as String? ?? 'Failed to send message.',
      ));
    }
  }

  // ── REST ───────────────────────────────────────────────────────────────────

  Future<void> loadInitial() async {
    if (state.status == ChatStatus.loading) return;

    emit(state.copyWith(
      status: ChatStatus.loading,
      messages: [],
      hasMore: true,
      error: null,
      clearNextCursor: true,
    ));

    try {
      final page =
          await _chatService.getMessages(conversationId, limit: _limit);
      // API returns newest-first; reverse for oldest-first display order.
      final rawMsgs = page.items.reversed.toList();

      // Apply any status updates that arrived via WebSocket before REST finished.
      final msgs = rawMsgs.map((m) {
        final pending = _pendingStatuses.remove(m.id);
        if (pending == null) return m;
        final pendingRank = _statusRank[pending] ?? 0;
        final currentRank = _statusRank[m.status] ?? 0;
        return pendingRank > currentRank ? m.copyWith(status: pending) : m;
      }).toList();

      emit(state.copyWith(
        status: ChatStatus.success,
        messages: msgs,
        nextCursor: page.nextCursor,
        hasMore: page.nextCursor != null,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: ChatStatus.failure,
        error: e.message ?? 'Failed to load messages.',
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ChatStatus.failure,
        error: 'Something went wrong.',
      ));
    }
  }

  /// Load older messages when user scrolls to top (cursor pagination).
  Future<void> loadMore() async {
    if (!state.hasMore || state.status == ChatStatus.loading) return;

    try {
      final page = await _chatService.getMessages(
        conversationId,
        cursor: state.nextCursor,
        limit: _limit,
      );
      final older = page.items.reversed.toList();
      final merged = [...older, ...state.messages];

      emit(state.copyWith(
        messages: merged,
        nextCursor: page.nextCursor,
        hasMore: page.nextCursor != null,
      ));
    } catch (_) {
      // Silently ignore — list stays intact.
    }
  }

  /// Optimistic send via WebSocket. The server echoes back the confirmed
  /// message on chat:message, which replaces the optimistic bubble.
  /// Failures arrive on chat:error → _onError removes the optimistic entry.
  void sendMessage(String content) {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;

    _typingTimer?.cancel();
    _socketService.emitChatTyping(conversationId, isTyping: false);

    final tempId = 'opt_${DateTime.now().millisecondsSinceEpoch}';
    _optimisticId = tempId;

    final optimistic = ChatMessage(
      id: tempId,
      conversationId: conversationId,
      senderId: currentUserId,
      content: trimmed,
      status: 'SENT',
      createdAt: DateTime.now(),
      isOptimistic: true,
    );

    emit(state.copyWith(
      messages: [...state.messages, optimistic],
      clearSendError: true,
    ));

    // Fire-and-forget — confirmation/error handled by socket events.
    _socketService.emitChatSend(conversationId, trimmed);
  }

  /// Mark seen via WebSocket only — server handles persistence.
  void emitSeen() {
    _socketService.emitChatSeen(conversationId);
  }

  /// Debounced typing events: emit true on keystroke, false after 1.5 s idle.
  void onTextChanged(String text) {
    if (text.isEmpty) {
      _typingTimer?.cancel();
      _socketService.emitChatTyping(conversationId, isTyping: false);
      return;
    }
    _socketService.emitChatTyping(conversationId, isTyping: true);
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(milliseconds: 1500), () {
      _socketService.emitChatTyping(conversationId, isTyping: false);
    });
  }

  void clearSendError() {
    if (!isClosed) emit(state.copyWith(clearSendError: true));
  }

  @override
  Future<void> close() {
    _typingTimer?.cancel();
    _typingClearTimer?.cancel();
    _socketService.offChatConversationEvents();
    return super.close();
  }
}
