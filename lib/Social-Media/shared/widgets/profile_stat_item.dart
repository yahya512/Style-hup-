import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A count + label column used in profile header stats rows.
/// Set [formatted] to true to abbreviate large numbers (1.2K, 3.4M).
class ProfileStatItem extends StatelessWidget {
  const ProfileStatItem({
    super.key,
    required this.count,
    required this.label,
    this.formatted = false,
  });

  final int count;
  final String label;

  /// When true, numbers >= 1 000 are shown as K/M.
  final bool formatted;

  String get _display {
    if (!formatted) return '$count';
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '$count';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _display,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.black87),
        ),
      ],
    );
  }
}
