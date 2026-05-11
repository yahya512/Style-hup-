// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'post_video_player.dart'; // Import your new video player

class PostMediaCarousel extends StatefulWidget {
  final List<String> images;
  final List<String> videos;

  const PostMediaCarousel({
    super.key,
    required this.images,
    required this.videos,
  });

  @override
  State<PostMediaCarousel> createState() => _PostMediaCarouselState();
}

class _PostMediaCarouselState extends State<PostMediaCarousel> {
  int _current = 0;

  @override
  void didUpdateWidget(PostMediaCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.images != widget.images ||
        oldWidget.videos != widget.videos) {
      setState(() => _current = 0);
    }
  }

  Widget _buildItem(int index) {
    final imageCount = widget.images.length;
    if (index < imageCount) {
      return Image.network(
        widget.images[index],
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[100],
          alignment: Alignment.center,
          child: Icon(Icons.broken_image_outlined,
              size: 48.r, color: Colors.grey[400]),
        ),
      );
    }
    return PostVideoPlayer(videoUrl: widget.videos[index - imageCount]);
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.images.length + widget.videos.length;
    if (total == 0) return const SizedBox.shrink();

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: total,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (context, index) => _buildItem(index),
          ),

          // Dot indicator
          if (total > 1)
            Positioned(
              bottom: 10.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  total,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: _current == i ? 16.w : 6.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: _current == i
                          ? const Color(0xFF32DBE6)
                          : Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
