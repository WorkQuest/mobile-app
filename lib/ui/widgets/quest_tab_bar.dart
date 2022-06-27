import 'package:flutter/material.dart';

class PersistentTabBar extends SliverPersistentHeaderDelegate {
  final List<String> titles;

  const PersistentTabBar(this.titles);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 8.0,
        right: 16.0,
        bottom: 8.0,
      ),
      child: Container(
        height: 44,
        width: double.infinity,
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: TabBar(
          labelPadding: const EdgeInsets.symmetric(
            horizontal: 0.0,
          ),
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
          ),
          labelColor: const Color(0xFF353C47),
          labelStyle: TextStyle(
            fontSize: 14,
          ),
          unselectedLabelColor: const Color(0xFF8D96A1),
          unselectedLabelStyle: TextStyle(
            fontSize: 14,
          ),
          tabs: [
            for (final title in titles)
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 44.0 + 16.0;

  @override
  double get minExtent => 44.0 + 16.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
