import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/feed/models/post_model.dart';

class EditPostBottomSheet extends StatefulWidget {
  const EditPostBottomSheet({
    super.key,
    required this.post,
    required this.onSave,
  });

  final FeedPostModel post;
  final void Function(String? content, PostVisibility visibility) onSave;

  @override
  State<EditPostBottomSheet> createState() => _EditPostBottomSheetState();
}

class _EditPostBottomSheetState extends State<EditPostBottomSheet> {
  late final TextEditingController _contentCtrl;
  late PostVisibility _visibility;

  static const _visibilityLabels = {
    PostVisibility.public: 'PUBLIC',
    PostVisibility.followers: 'FOLLOWERS',
    PostVisibility.private: 'PRIVATE',
  };

  static const _visibilityIcons = {
    PostVisibility.public: Icons.public,
    PostVisibility.followers: Icons.people_outline,
    PostVisibility.private: Icons.lock_outline,
  };

  @override
  void initState() {
    super.initState();
    _contentCtrl = TextEditingController(text: widget.post.content ?? '');
    _visibility = widget.post.visibility;
  }

  @override
  void dispose() {
    _contentCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final content = _contentCtrl.text.trim();
    widget.onSave(content.isEmpty ? null : content, _visibility);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Edit Post',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _save,
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _contentCtrl,
            maxLines: 5,
            minLines: 3,
            style: TextStyle(fontSize: 15.sp, color: Colors.black),
            decoration: InputDecoration(
              hintText: "What's on your mind?",
              hintStyle: TextStyle(fontSize: 15.sp, color: Colors.grey[400]),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              contentPadding:
                  EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 14.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(color: Colors.black, width: 1.5.w),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                'Visibility',
                style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
              ),
              const Spacer(),
              DropdownButton<PostVisibility>(
                value: _visibility,
                underline: const SizedBox.shrink(),
                style: TextStyle(fontSize: 13.sp, color: Colors.black87),
                items: PostVisibility.values.map((v) {
                  return DropdownMenuItem(
                    value: v,
                    child: Row(
                      children: [
                        Icon(
                          _visibilityIcons[v],
                          size: 16.r,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 4.w),
                        Text(_visibilityLabels[v]!),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _visibility = v);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
