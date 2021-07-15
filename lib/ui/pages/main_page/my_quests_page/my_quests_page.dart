import 'package:app/ui/pages/main_page/my_quests_page/quests_list.dart';
import 'package:app/ui/pages/main_page/quest_page/store/quests_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import '../../../../enums.dart';

class MyQuestsPage extends StatelessWidget {
  //static const String routeName = "/myQuestPage";

  @override
  Widget build(BuildContext context) {
    final questStore = context.read<QuestsStore>();
    questStore.getQuests();
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
              Center(
                child: QuestsList(
                  QuestItemPriorityType.Active,
                  questStore.questsList,
                ),
              ),
              Center(
                child: QuestsList(
                  QuestItemPriorityType.Invited,
                  questStore.invitedQuestsList,
                ),
              ),
              Center(
                child: QuestsList(
                  QuestItemPriorityType.Performed,
                  questStore.performedQuestsList,
                ),
              ),
              Center(
                child: QuestsList(
                  QuestItemPriorityType.Starred,
                  questStore.starredQuestsList,
                ),
              ),
            ],
          ),
        ),
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
            Text(
              "Active",
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
            Text(
              "Invited",
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
            Text(
              "Performed",
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
            Text(
              "Starred",
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
