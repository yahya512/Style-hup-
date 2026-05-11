import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/chat/cubit/conversations_cubit.dart';
import 'package:dx/Social-Media/chat/cubit/conversations_state.dart';
import 'package:dx/Social-Media/chat/models/chat_conversation.dart';
import 'package:dx/Social-Media/chat/screens/chat_screen.dart';
import 'package:dx/Social-Media/chat/widgets/conversation_tile.dart';
import 'package:dx/Social-Media/follow/models/follow_account.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF800020),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<ConversationsCubit, ConversationsState>(
        builder: (context, state) {
          if (state.isInitialLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF800020)),
            );
          }

          if (state.status == ConversationsStatus.failure &&
              state.conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      size: 48.r, color: Colors.grey.shade400),
                  SizedBox(height: 12.h),
                  Text(
                    state.error ?? 'Something went wrong.',
                    style: TextStyle(
                        fontSize: 14.sp, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12.h),
                  TextButton(
                    onPressed: () =>
                        context.read<ConversationsCubit>().refresh(),
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Color(0xFF800020)),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: const Color(0xFF800020),
            onRefresh: () => context.read<ConversationsCubit>().refresh(),
            child: CustomScrollView(
              slivers: [
                // ── People you follow / follow you ──────────────────────
                if (state.people.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _PeopleRow(people: state.people),
                  ),

                // ── Conversations list ───────────────────────────────────
                if (state.conversations.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline,
                              size: 64.r, color: Colors.grey.shade300),
                          SizedBox(height: 16.h),
                          Text(
                            'No conversations yet',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Tap someone above to start chatting',
                            style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final conv = state.conversations[index];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ConversationTile(
                              conversation: conv,
                              onTap: () => _openChat(context, conv),
                            ),
                            Divider(
                                height: 1, color: Colors.grey.shade100),
                          ],
                        );
                      },
                      childCount: state.conversations.length,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openChat(BuildContext context, ChatConversation conv) {
    final currentUserId =
        CacheHelper().getData(key: ApiKey.userId) as String? ?? '';
    context.read<ConversationsCubit>().resetUnread(conv.id);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          conversationId: conv.id,
          otherParticipantName:
              conv.otherParticipantName ?? conv.otherParticipantId,
          otherParticipantAvatar: conv.otherParticipantAvatar,
          currentUserId: currentUserId,
        ),
      ),
    );
  }
}

// ── People row ────────────────────────────────────────────────────────────────

class _PeopleRow extends StatelessWidget {
  const _PeopleRow({required this.people});

  final List<FollowAccount> people;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
          child: Text(
            'People',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
        ),
        SizedBox(
          height: 88.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: people.length,
            separatorBuilder: (_, __) => SizedBox(width: 16.w),
            itemBuilder: (context, index) =>
                _PersonAvatar(account: people[index]),
          ),
        ),
        Divider(height: 1, color: Colors.grey.shade100),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
          child: Text(
            'Conversations',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _PersonAvatar extends StatelessWidget {
  const _PersonAvatar({required this.account});

  final FollowAccount account;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _startChat(context),
      child: SizedBox(
        width: 60.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 28.r,
              backgroundColor: const Color(0xFFB05070),
              backgroundImage: account.profileImageUrl != null
                  ? NetworkImage(account.profileImageUrl!)
                  : null,
              child: account.profileImageUrl == null
                  ? Icon(Icons.person, size: 26.r, color: Colors.white70)
                  : null,
            ),
            SizedBox(height: 4.h),
            Text(
              account.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startChat(BuildContext context) async {
    final currentUserId =
        CacheHelper().getData(key: ApiKey.userId) as String? ?? '';
    final cubit = context.read<ConversationsCubit>();

    // Show loading indicator while we get/create the conversation.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF800020)),
      ),
    );

    try {
      final conv = await cubit.getOrCreateConversation(account.id);
      if (!context.mounted) return;
      Navigator.of(context).pop(); // dismiss loader
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            conversationId: conv.id,
            otherParticipantName: account.displayName,
            otherParticipantAvatar: account.profileImageUrl,
            currentUserId: currentUserId,
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      Navigator.of(context).pop(); // dismiss loader
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open conversation. Try again.'),
          backgroundColor: Color(0xFF800020),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
