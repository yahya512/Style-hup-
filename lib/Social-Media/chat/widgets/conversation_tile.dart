import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/chat/models/chat_conversation.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  final ChatConversation conversation;
  final VoidCallback onTap;

  static const _burgundy = Color(0xFF800020);

  @override
  Widget build(BuildContext context) {
    final name =
        conversation.otherParticipantName ?? conversation.otherParticipantId;
    final avatar = conversation.otherParticipantAvatar;
    final hasUnread = conversation.unreadCount > 0;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26.r,
              backgroundColor: const Color(0xFFB05070),
              backgroundImage:
                  avatar != null ? NetworkImage(avatar) : null,
              child: avatar == null
                  ? Icon(Icons.person, size: 26.r, color: Colors.white70)
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: hasUnread
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _timeAgo(conversation.lastMessageAt),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            if (hasUnread)
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: _burgundy,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  conversation.unreadCount > 99
                      ? '99+'
                      : conversation.unreadCount.toString(),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
