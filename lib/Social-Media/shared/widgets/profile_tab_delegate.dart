import 'package:flutter/material.dart';

/// A [SliverPersistentHeaderDelegate] that renders a sticky [TabBar].
/// Pass the desired [tabs] list; the delegate handles the white background
/// and bottom border shared by all profile screens.
class ProfileTabBarDelegate extends SliverPersistentHeaderDelegate {
  const ProfileTabBarDelegate({required this.tabs});

  final List<Tab> tabs;

  @override
  double get minExtent => 48.0;
  @override
  double get maxExtent => 48.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1.0),
        ),
      ),
      child: TabBar(
        indicatorColor: Colors.black,
        indicatorWeight: 1.5,
        labelPadding: EdgeInsets.zero,
        tabs: tabs,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
