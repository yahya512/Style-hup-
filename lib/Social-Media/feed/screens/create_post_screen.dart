import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/Social-Media/feed/services/feed_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final List<File> _images = [];
  String _visibility = 'PUBLIC';
  bool _isLoading = false;

  static const _visibilityOptions = ['PUBLIC', 'FOLLOWERS', 'PRIVATE'];

  @override
  void dispose() {
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final remaining = 5 - _images.length;
    if (remaining <= 0) return;

    final picked = await _picker.pickMultiImage();
    if (picked.isEmpty) return;

    setState(() {
      for (final x in picked) {
        if (_images.length < 5) _images.add(File(x.path));
      }
    });
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  Future<void> _submit() async {
    final content = _contentCtrl.text.trim();
    if (content.isEmpty && _images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add some text or images to post.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await getIt<FeedService>().createPost(
        content: content.isEmpty ? null : content,
        visibility: _visibility,
        images: _images,
      );
      if (mounted) Navigator.of(context).pop(true);
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  IconData _visibilityIcon(String v) => switch (v) {
        'PUBLIC' => Icons.public,
        'FOLLOWERS' => Icons.people_outline,
        _ => Icons.lock_outline,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('New Post', style: AppStyles.normalTextStyle),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: _isLoading
                ? const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF32DBE6),
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: _submit,
                    child: Text(
                      'Post',
                      style: TextStyle(
                        color: const Color(0xFF32DBE6),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _contentCtrl,
              maxLines: null,
              minLines: 4,
              style: TextStyle(fontSize: 16.sp, color: Colors.black),
              decoration: InputDecoration(
                hintText: "What's on your mind?",
                hintStyle:
                    TextStyle(fontSize: 16.sp, color: Colors.grey[400]),
                border: InputBorder.none,
              ),
            ),
            if (_images.isNotEmpty) ...[
              SizedBox(height: 12.h),
              SizedBox(
                height: 100.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  separatorBuilder: (_, _) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) => Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.file(
                          _images[index],
                          width: 100.w,
                          height: 100.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(2.r),
                            child: Icon(Icons.close,
                                color: Colors.white, size: 14.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            SizedBox(height: 16.h),
            const Divider(),
            SizedBox(height: 8.h),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.photo_library_outlined,
                      color: Colors.black87, size: 26.r),
                  onPressed: _images.length < 5 ? _pickImages : null,
                  tooltip: 'Add images (max 5)',
                ),
                if (_images.length >= 5)
                  Text(
                    'Max 5 images',
                    style:
                        TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
                  ),
                const Spacer(),
                DropdownButton<String>(
                  value: _visibility,
                  underline: const SizedBox.shrink(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  items: _visibilityOptions
                      .map(
                        (v) => DropdownMenuItem(
                          value: v,
                          child: Row(
                            children: [
                              Icon(_visibilityIcon(v),
                                  size: 16.r, color: Colors.black54),
                              SizedBox(width: 4.w),
                              Text(v),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _visibility = v);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
