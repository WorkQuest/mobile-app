import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;
  double topPadding ;
  double bottomPadding;

  StickyTabBarDelegate({this.bottomPadding = 0 , this.topPadding = 0,required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: Color(0xFFF7F8FA),
      ),
      margin: EdgeInsets.fromLTRB(16.0, topPadding, 16.0, bottomPadding,),
      padding: EdgeInsets.all(5.0),
      child: this.child,
    );
  }

  @override
  double get maxExtent => this.child.preferredSize.height;

  @override
  double get minExtent => this.child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
