import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/chat/models/chat_message.dart';
import 'package:dx/Social-Media/chat/widgets/message_status_icon.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
  });

  final ChatMessage message;
  final bool isMine;

  static const _burgundy = Color(0xFF800020);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: message.isOptimistic ? 0.65 : 1.0,
      child: Align(
        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(
            left: isMine ? 60.w : 12.w,
            right: isMine ? 12.w : 60.w,
            bottom: 4.h,
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isMine ? _burgundy : Colors.grey.shade100,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
              bottomLeft: Radius.circular(isMine ? 16.r : 4.r),
              bottomRight: Radius.circular(isMine ? 4.r : 16.r),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.content,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isMine ? Colors.white : Colors.black87,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(message.createdAt),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color:
                          isMine ? Colors.white54 : Colors.grey.shade500,
                    ),
                  ),
                  if (isMine) ...[
                    SizedBox(width: 4.w),
                    MessageStatusIcon(status: message.status),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
