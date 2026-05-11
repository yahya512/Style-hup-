import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageStatusIcon extends StatelessWidget {
  const MessageStatusIcon({super.key, required this.status});

  final String status;

  static const _blue = Color(0xFF4FC3F7);

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 'SEEN':
        return Icon(Icons.done_all, size: 14.r, color: _blue);
      case 'DELIVERED':
        return Icon(Icons.done_all, size: 14.r, color: Colors.white54);
      case 'SENT':
      default:
        return Icon(Icons.done, size: 14.r, color: Colors.white54);
    }
  }
}
