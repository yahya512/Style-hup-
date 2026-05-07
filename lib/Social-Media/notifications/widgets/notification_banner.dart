import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/notifications/models/notification_model.dart';

/// Slide-down in-app banner for real-time notifications.
///
/// Insert via [NotificationBannerOverlay.show] — it manages its own
/// [OverlayEntry] and calls [onDismissed] when fully gone.
class NotificationBannerOverlay extends StatefulWidget {
  const NotificationBannerOverlay({
    super.key,
    required this.notification,
    required this.onDismissed,
    required this.onTap,
  });

  final NotificationModel notification;

  /// Called after the exit animation completes. The caller should remove
  /// the OverlayEntry and clear the cubit banner state here.
  final VoidCallback onDismissed;

  /// Called when the user taps the banner (before dismissal starts).
  final VoidCallback onTap;

  /// Convenience factory: inserts an [OverlayEntry] and returns it.
  static OverlayEntry show({
    required BuildContext context,
    required NotificationModel notification,
    required VoidCallback onDismissed,
    required VoidCallback onTap,
  }) {
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => NotificationBannerOverlay(
        notification: notification,
        onDismissed: () {
          entry.remove();
          onDismissed();
        },
        onTap: onTap,
      ),
    );
    Overlay.of(context).insert(entry);
    return entry;
  }

  @override
  State<NotificationBannerOverlay> createState() =>
      _NotificationBannerOverlayState();
}

class _NotificationBannerOverlayState extends State<NotificationBannerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  Timer? _autoTimer;
  bool _dismissed = false;

  static const _autoDismissDelay = Duration(seconds: 4);
  static const _animDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(vsync: this, duration: _animDuration);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.6)),
    );

    _ctrl.forward();
    _autoTimer = Timer(_autoDismissDelay, _dismiss);
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (_dismissed) return;
    _dismissed = true;
    _autoTimer?.cancel();
    await _ctrl.reverse();
    widget.onDismissed();
  }

  void _handleTap() {
    widget.onTap();
    _dismiss();
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.notification;
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnim,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _handleTap,
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta != null && details.primaryDelta! < -6) {
                _dismiss();
              }
            },
            child: Container(
              margin: EdgeInsets.only(
                top: topPadding + 8.h,
                left: 12.w,
                right: 12.w,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF5ECD7),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                type: MaterialType.transparency,
                child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: const Color(0xFFB05070),
                      backgroundImage: n.actorPhoto != null
                          ? NetworkImage(n.actorPhoto!)
                          : null,
                      child: n.actorPhoto == null
                          ? Icon(Icons.person,
                              size: 22.r, color: Colors.white70)
                          : null,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            n.typeLabel,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1A1A1A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            n.displayText,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF555555),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: BoxDecoration(
                        color: const Color(0xFF800020),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ),
        ),
      ),
    );
  }
}
