import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/interactions/models/comment_model.dart';
import 'package:dx/core/theme/appstyles.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.comment,
    required this.currentUserId,
    required this.onEdit,
    required this.onDelete,
  });

  final CommentModel comment;
  final String currentUserId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String _relativeTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isOwn = comment.authorId == currentUserId;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: Colors.grey[200],
            backgroundImage: comment.authorImage != null
                ? NetworkImage(comment.authorImage!)
                : null,
            child: comment.authorImage == null
                ? Icon(Icons.person, size: 18.r, color: Colors.grey[500])
                : null,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.authorName,
                      style: AppStyles.normalTextStyle.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _relativeTime(comment.updatedAt ?? comment.createdAt),
                      style: AppStyles.labelTextStyle.copyWith(fontSize: 11.sp),
                    ),
                    if (isOwn) ...[
                      SizedBox(width: 4.w),
                      PopupMenuButton<String>(
                        iconSize: 18.r,
                        padding: EdgeInsets.zero,
                        onSelected: (value) {
                          if (value == 'edit') onEdit();
                          if (value == 'delete') onDelete();
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(
                              value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  comment.content,
                  style: AppStyles.normalTextStyle.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
