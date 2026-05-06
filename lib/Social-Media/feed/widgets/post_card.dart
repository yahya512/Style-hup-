import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/Social-Media/feed/models/post_model.dart';
import 'package:dx/Social-Media/interactions/cubit/reaction_cubit.dart';
import 'package:dx/Social-Media/interactions/cubit/reaction_state.dart';
import 'package:dx/Social-Media/interactions/widgets/comment_bottom_sheet.dart';
import 'post_media_carousel.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.item});

  final FeedItemModel item;

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
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: post.authorImage != null
                      ? NetworkImage(post.authorImage!)
                      : null,
                  child: post.authorImage == null
                      ? Icon(Icons.person, size: 22.r, color: Colors.grey[500])
                      : null,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(post.authorName, style: AppStyles.normalTextStyle, overflow: TextOverflow.ellipsis),
                ),
                Icon(Icons.more_horiz, size: 20.r, color: Colors.grey[600]),
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
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border),
                      iconSize: 24.r,
                      color: Colors.black87,
                      onPressed: () {},
                    ),
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