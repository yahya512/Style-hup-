import 'package:dx/Social-Media/feed/models/post_model.dart';
import 'package:dx/Social-Media/feed/widgets/post_video_player.dart';
import 'package:dx/Social-Media/profile_posts/screens/post_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePostsGrid extends StatelessWidget {
  const ProfilePostsGrid({
    super.key,
    required this.posts,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.onLoadMore,
    this.onPostDelete,
    this.onPostEdit,
  });

  final List<FeedPostModel> posts;
  final bool isLoadingMore;
  final bool hasMore;
  final VoidCallback? onLoadMore;
  final void Function(String postId)? onPostDelete;
  final void Function(String postId, String? content, PostVisibility visibility)? onPostEdit;

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const ProfileEmptyState(
        icon: Icons.camera_alt_outlined,
        label: 'No Posts Yet',
      );
    }

    // Extra item at the end when there are more pages to load.
    final itemCount = posts.length + (hasMore ? 1 : 0);

    return GridView.builder(
      padding: const EdgeInsets.all(1),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 1.5,
        mainAxisSpacing: 1.5,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Sentinel item — triggers load-more when it scrolls into view.
        if (index == posts.length) {
          if (!isLoadingMore && onLoadMore != null) {
            onLoadMore!();
          }
          return Container(
            color: Colors.grey[100],
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF32DBE6),
                ),
              ),
            ),
          );
        }

        final post = posts[index];
        final imageUrl = post.images.firstOrNull;
        final hasVideo = post.videos.isNotEmpty;
        final isTextOnly = post.images.isEmpty && post.videos.isEmpty;

        return GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PostDetailScreen(
                post: post,
                onDelete: onPostDelete != null
                    ? () => onPostDelete!(post.id)
                    : null,
                onEdit: onPostEdit != null
                    ? (content, vis) => onPostEdit!(post.id, content, vis)
                    : null,
              ),
            ),
          ),
          child: Container(
            color: Colors.grey[100],
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image thumbnail
                if (imageUrl != null)
                  Image.network(imageUrl, fit: BoxFit.cover)
                // Video-only post — show the actual video (muted, looping)
                else if (hasVideo)
                  ClipRect(
                    child: SizedBox.expand(
                      child: PostVideoPlayer(videoUrl: post.videos.first),
                    ),
                  )
                // Text-only post — show the actual text
                else if (isTextOnly)
                  Container(
                    color: Colors.grey[50],
                    padding: EdgeInsets.all(8.r),
                    alignment: Alignment.center,
                    child: Text(
                      post.content ?? '',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                // Video badge over image
                if (hasVideo && imageUrl != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Icon(
                      Icons.videocam,
                      size: 16.r,
                      color: Colors.white,
                      shadows: const [Shadow(blurRadius: 4)],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
class ProfileEmptyState extends StatelessWidget {
  final IconData icon;
  final String label;

  const ProfileEmptyState({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60.r, color: Colors.grey[300]),
          SizedBox(height: 12.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}