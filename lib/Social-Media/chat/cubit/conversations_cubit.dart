import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dx/Social-Media/chat/cubit/conversations_state.dart';
import 'package:dx/Social-Media/chat/models/chat_conversation.dart';
import 'package:dx/Social-Media/chat/models/chat_message.dart';
import 'package:dx/Social-Media/chat/services/chat_service.dart';
import 'package:dx/Social-Media/follow/models/follow_account.dart';
import 'package:dx/Social-Media/follow/services/follow_service.dart';
import 'package:dx/Social-Media/notifications/services/socket_service.dart';
import 'package:dx/Social-Media/user/services/other_user_profile_service.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';

class ConversationsCubit extends Cubit<ConversationsState> {
  ConversationsCubit({
    required ChatService chatService,
    required SocketService socketService,
    required OtherUserProfileService profileService,
    required FollowService followService,
  })  : _chatService = chatService,
        _socketService = socketService,
        _profileService = profileService,
        _followService = followService,
        super(const ConversationsState());

  final ChatService _chatService;
  final SocketService _socketService;
  final OtherUserProfileService _profileService;
  final FollowService _followService;

  // ── Socket ─────────────────────────────────────────────────────────────────

  /// Register chat:message listener to update the conversation list.
  /// Called from MainLayout after socket connects.
  void startListening() {
    _socketService.onChatMessage(_onIncomingMessage);
  }

  /// Remove listeners. Called from MainLayout dispose.
  void stopListening() {
    _socketService.offChatEvents();
  }

  void _onIncomingMessage(Map<String, dynamic> data) {
    if (isClosed) return;
    final message = ChatMessage.fromJson(data);
    final convId = message.conversationId;

    final list = List<ChatConversation>.from(state.conversations);
    final idx = list.indexWhere((c) => c.id == convId);

    if (idx == -1) {
      // Unknown conversation — reload list to pick it up.
      loadInitial();
      return;
    }

    final currentUserId =
        CacheHelper().getData(key: ApiKey.userId) as String? ?? '';
    final isOwnMessage = message.senderId == currentUserId;

    final conv = list.removeAt(idx);
    // Always bump to top; only increment unread for messages from others.
    list.insert(
      0,
      conv.copyWith(
        lastMessageAt: message.createdAt,
        unreadCount: isOwnMessage ? conv.unreadCount : conv.unreadCount + 1,
      ),
    );

    emit(state.copyWith(conversations: list));
  }

  // ── REST ───────────────────────────────────────────────────────────────────

  Future<void> loadInitial() async {
    if (state.status == ConversationsStatus.loading) return;

    emit(state.copyWith(
      status: ConversationsStatus.loading,
      conversations: [],
      error: null,
    ));

    try {
      final convPage = await _chatService.getConversations();
      final followersResp =
          await _followService.getMyFollowers(limit: 100);
      final followingResp =
          await _followService.getMyFollowing(limit: 100);

      final enriched = await _enrichAll(convPage.items);

      // Merge followers + following, deduplicated by id.
      final seenIds = <String>{};
      final people = <FollowAccount>[];
      for (final account in [
        ...followersResp.items,
        ...followingResp.items,
      ]) {
        if (seenIds.add(account.id)) people.add(account);
      }

      emit(state.copyWith(
        status: ConversationsStatus.success,
        conversations: enriched,
        people: people,
        hasMore: false,
      ));
    } on DioException catch (e) {
      emit(state.copyWith(
        status: ConversationsStatus.failure,
        error: e.message ?? 'Failed to load conversations.',
      ));
    } catch (_) {
      emit(state.copyWith(
        status: ConversationsStatus.failure,
        error: 'Something went wrong.',
      ));
    }
  }

  Future<void> refresh() => loadInitial();

  /// Gets or creates a conversation with [participantId], returns it ready
  /// for navigation. Throws on network error.
  Future<ChatConversation> getOrCreateConversation(
    String participantId,
  ) async {
    final conv =
        await _chatService.getOrCreateConversation(participantId);
    // Update local list so the conversation appears immediately.
    final exists =
        state.conversations.any((c) => c.id == conv.id);
    if (!exists) {
      emit(state.copyWith(
        conversations: [conv, ...state.conversations],
      ));
    }
    return conv;
  }

  /// Zero out the unread badge when the user opens a conversation.
  void resetUnread(String conversationId) {
    if (isClosed) return;
    final updated = state.conversations.map((c) {
      if (c.id != conversationId) return c;
      return c.copyWith(unreadCount: 0);
    }).toList();
    emit(state.copyWith(conversations: updated));
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Fetches name/avatar for every participant in parallel.
  /// OtherUserProfileService handles both USER and BRAND accounts.
  Future<List<ChatConversation>> _enrichAll(
    List<ChatConversation> convs,
  ) async {
    final profiles = await Future.wait(
      convs.map(
        (c) => _profileService
            .getProfile(c.otherParticipantId)
            .then<Object?>((p) => p)
            .catchError((_) => null),
      ),
    );

    return List.generate(convs.length, (i) {
      final profile = profiles[i];
      if (profile == null) return convs[i];
      // ignore: avoid_dynamic_calls
      final p = profile as dynamic;
      return convs[i].copyWith(
        otherParticipantName: (p.displayName as String?) ?? convs[i].otherParticipantId,
        otherParticipantAvatar: p.profileImageUrl as String?,
      );
    });
  }
}
