import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/Social-Media/feed/models/post_model.dart';
import 'package:dx/Social-Media/feed/widgets/edit_post_bottom_sheet.dart';
import 'package:dx/Social-Media/interactions/cubit/reaction_cubit.dart';
import 'package:dx/Social-Media/interactions/cubit/reaction_state.dart';
import 'package:dx/Social-Media/interactions/widgets/comment_bottom_sheet.dart';
import 'package:dx/Social-Media/brand/screens/other_brand_profile_screen.dart';
import 'package:dx/Social-Media/user/screens/other_user_profile_screen.dart';
import 'package:dx/core/navigation/tab_notifier.dart';
import 'package:dx/E-Commerce/Screens/home_screen.dart';
import 'post_media_carousel.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.item,
    this.onDelete,
    this.onEdit,
  });

  final FeedItemModel item;
  final VoidCallback? onDelete;
  final void Function(String? content, PostVisibility visibility)? onEdit;

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
    final post = item.post;

    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    final currentUserId =
                        CacheHelper().getData(key: ApiKey.userId) as String?;
                    if (currentUserId == post.authorId) {
                      appTabNotifier.value = 4;
                      return;
                    }
                    if (post.authorRole == 'BRAND') {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            OtherBrandProfilePage(userId: post.authorId),
                      ));
                      return;
                    }
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) =>
                          OtherUserProfilePage(userId: post.authorId),
                    ));
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: post.authorImage != null
                            ? NetworkImage(post.authorImage!)
                            : null,
                        child: post.authorImage == null
                            ? Icon(Icons.person,
                                size: 22.r, color: Colors.grey[500])
                            : null,
                      ),
                      SizedBox(width: 10.w),
                      Text(post.authorName,
                          style: AppStyles.normalTextStyle,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const Spacer(),
                _PostMenuButton(post: post, onDelete: onDelete, onEdit: onEdit),
              ],
            ),
          ),
          if (post.images.isNotEmpty || post.videos.isNotEmpty)
              PostMediaCarousel(
                images: post.images,
                videos: post.videos,
              ),
          BlocBuilder<ReactionCubit, ReactionState>(
            builder: (context, rxState) {
              final isReacted = rxState.reacted[post.id] ?? post.isReactedByMe;
              final reactionCount =
                  rxState.reactionCounts[post.id] ?? post.reactionsCount;
              final commentCount =
                  rxState.commentCounts[post.id] ?? post.commentsCount;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isReacted ? Icons.favorite : Icons.favorite_border,
                        color: isReacted ? Colors.red : Colors.black87,
                      ),
                      iconSize: 26.r,
                      onPressed: () =>
                          context.read<ReactionCubit>().toggleReaction(post.id),
                    ),
                    Text('$reactionCount', style: AppStyles.labelTextStyle),
                    SizedBox(width: 4.w),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      iconSize: 24.r,
                      color: Colors.black87,
                      onPressed: () => showCommentBottomSheet(
                        context,
                        postId: post.id,
                        onCountChanged: (delta) => context
                            .read<ReactionCubit>()
                            .updateCommentCount(post.id, delta),
                      ),
                    ),
                    Text('$commentCount', style: AppStyles.labelTextStyle),
                    if (post.authorRole == 'BRAND') ...[
                      SizedBox(width: 4.w),
                      IconButton(
                        icon: const Icon(Icons.storefront_rounded),
                        iconSize: 24.r,
                        color: const Color(0xFF800020),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                HomeScreen(brandId: post.authorId),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          if (post.content != null && post.content!.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(post.content!, style: AppStyles.normalTextStyle),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 10.h),
            child: Text(_relativeTime(item.createdAt), style: AppStyles.labelTextStyle.copyWith(fontSize: 12.sp)),
          ),
          Divider(height: 1.h, color: Colors.grey[200]),
        ],
      ),
    );
  }
}

/// Shows the "..." icon. If the current user owns the post, tapping it opens
/// a bottom sheet with Edit and Delete options.
class _PostMenuButton extends StatelessWidget {
  const _PostMenuButton({
    required this.post,
    this.onDelete,
    this.onEdit,
  });

  final FeedPostModel post;
  final VoidCallback? onDelete;
  final void Function(String? content, PostVisibility visibility)? onEdit;

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        CacheHelper().getData(key: ApiKey.userId) as String?;
    final isOwner = currentUserId != null && currentUserId == post.authorId;

    return GestureDetector(
      onTap: isOwner ? () => _showMenu(context) : null,
      child: Icon(
        Icons.more_horiz,
        size: 20.r,
        color: Colors.grey[600],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Post'),
              onTap: () {
                Navigator.of(ctx).pop();
                if (onEdit != null) {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16.r)),
                    ),
                    builder: (_) => EditPostBottomSheet(
                      post: post,
                      onSave: onEdit!,
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete Post',
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.of(ctx).pop();
                _confirmDelete(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onDelete?.call();
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}