import 'package:app/ui/pages/main_page/quest_page/my_quests_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class MyQuestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: Text("My quests"),
                border: const Border.fromBorderSide(BorderSide.none),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: const _PersistentTabBar(),
              ),
            ];
          },
          physics: const ClampingScrollPhysics(),
          body: TabBarView(
            children: [
              Center(child: const _List("Active")),
              Center(child: const _List("Invited")),
              Center(child: const _List("Performed")),
              Center(child: const _List("Starred")),
            ],
          ),
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  final String label;

  const _List(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F8FA),
      child: ListView.builder(
        itemCount: 100,
        padding: EdgeInsets.zero,
        itemBuilder: (_, index) {
          return MyQuestsItem(ItemType.Active);
          //   Padding(
          //   padding: const EdgeInsets.all(5.0),
          //   child: Container(
          //     color: Colors.red,
          //     child: Padding(
          //       padding: const EdgeInsets.all(20.0),
          //       child: Center(child: Text("$label $index")),
          //     ),
          //   ),
          // );
        },
      ),
    );
  }
}

class _PersistentTabBar extends SliverPersistentHeaderDelegate {
  const _PersistentTabBar();

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
            horizontal: 5.0,
          ),
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
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
            Text("Active"),
            Text("Invited"),
            Text("Performed"),
            Text("Starred"),
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
