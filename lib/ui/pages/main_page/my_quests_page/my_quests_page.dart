import 'package:app/ui/pages/main_page/my_quests_page/my_quests_item.dart';
import 'package:app/ui/pages/main_page/quest_page/store/quests_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import '../../../../enums.dart';

class MyQuestsPage extends StatelessWidget {
  //static const String routeName = "/myQuestPage";

  @override
  Widget build(BuildContext context) {
    final myQuestList = context.read<QuestsStore>();
    myQuestList.getQuests();
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
              Center(child: _List(QuestItemPriorityType.Active, myQuestList)),
              Center(child: _List(QuestItemPriorityType.Invited, myQuestList)),
              Center(
                  child: _List(QuestItemPriorityType.Performed, myQuestList)),
              Center(child: _List(QuestItemPriorityType.Starred, myQuestList)),
            ],
          ),
        ),
      ),
    );
  }
}

class _List extends StatelessWidget {
  final QuestItemPriorityType questItemPriorityType;
  final QuestsStore store;

  const _List(this.questItemPriorityType, this.store);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Container(
        color: const Color(0xFFF7F8FA),
        child: ListView.builder(
          itemCount: store.questsList!.length,
          padding: EdgeInsets.zero,
          itemBuilder: (_, index) {
            return MyQuestsItem(
              title:store.questsList![index].title ,
              itemType: questItemPriorityType,
              price: store.questsList![index].price,
              priority: store.questsList![index].priority,
              creatorName: store.questsList![index].user.firstName +
                  store.questsList![index].user.lastName,
              description: store.questsList![index].description,
            );
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
    });
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
