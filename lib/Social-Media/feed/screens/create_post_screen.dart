import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/Social-Media/feed/services/feed_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentCtrl = TextEditingController();

  final List<AssetEntity> _assets = [];
  String _visibility = 'PUBLIC';
  bool _isLoading = false;

  static const int _maxAssets = 9;
  static const _visibilityOptions = ['PUBLIC', 'FOLLOWERS', 'PRIVATE'];

  @override
  void dispose() {
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickMedia() async {
    if (_assets.length >= _maxAssets) return;

    final picked = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        requestType: RequestType.common,
        maxAssets: _maxAssets,
        selectedAssets: List<AssetEntity>.from(_assets),
      ),
    );
    if (picked == null || !mounted) return;

    setState(() {
      _assets
        ..clear()
        ..addAll(picked);
    });
  }

  void _removeAsset(int index) {
    setState(() => _assets.removeAt(index));
  }

  Future<void> _submit() async {
    final content = _contentCtrl.text.trim();
    if (content.isEmpty && _assets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add some text or media to post.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final images = <File>[];
      final videos = <File>[];

      for (final asset in _assets) {
        final file = await asset.originFile;
        if (file == null) continue;
        if (asset.type == AssetType.video) {
          videos.add(file);
        } else {
          images.add(file);
        }
      }

      await getIt<FeedService>().createPost(
        content: content.isEmpty ? null : content,
        visibility: _visibility,
        images: images,
        videos: videos,
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
        title: Text(
          'New Post',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
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
                        color: Colors.black,
                      ),
                    ),
                  )
                : TextButton(
                    onPressed: _submit,
                    child: Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.black,
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
                hintStyle: TextStyle(fontSize: 16.sp, color: Colors.grey[400]),
                border: InputBorder.none,
              ),
            ),
            if (_assets.isNotEmpty) ...[
              SizedBox(height: 12.h),
              SizedBox(
                height: 100.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _assets.length,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    final asset = _assets[index];
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: AssetEntityImage(
                            asset,
                            isOriginal: false,
                            width: 100.w,
                            height: 100.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (asset.type == AssetType.video)
                          Positioned.fill(
                            child: Center(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black38,
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(6.r),
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 20.r,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => _removeAsset(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(2.r),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 14.r,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
            SizedBox(height: 16.h),
            const Divider(),
            SizedBox(height: 8.h),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.photo_library_outlined,
                    color: Colors.black87,
                    size: 26.r,
                  ),
                  onPressed: _assets.length < _maxAssets ? _pickMedia : null,
                  tooltip: 'Add photos & videos (max $_maxAssets)',
                ),
                if (_assets.length >= _maxAssets)
                  Text(
                    'Max $_maxAssets items',
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
                              Icon(
                                _visibilityIcon(v),
                                size: 16.r,
                                color: Colors.black54,
                              ),
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
