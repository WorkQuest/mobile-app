import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/my_quests_page/quests_list.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import "package:provider/provider.dart";
import '../../../../enums.dart';
import 'package:easy_localization/easy_localization.dart';

class MyQuestsPage extends StatefulWidget {
  MyQuestsPage();

  @override
  _MyQuestsPageState createState() => _MyQuestsPageState();
}

class _MyQuestsPageState extends State<MyQuestsPage> {
  MyQuestStore? myQuests;
  late UserRole role;
  late String userID;

  @override
  void initState() {
    myQuests = context.read<MyQuestStore>();
    ProfileMeStore profileMeStore = context.read<ProfileMeStore>();
    role = profileMeStore.userData?.role ?? UserRole.Employer;
    profileMeStore.getProfileMe().then((value) {
      setState(() => role = profileMeStore.userData!.role);
      userID = profileMeStore.userData!.id;
      myQuests!.getQuests(userID, role, true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: role == UserRole.Worker ? 4 : 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: Text(
                  "quests.MyQuests".tr(),
                ),
                border: const Border.fromBorderSide(BorderSide.none),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _PersistentTabBar(role == UserRole.Worker
                    ? [
                        "quests.active".tr(),
                        "quests.invited".tr(),
                        "quests.performed".tr(),
                        "quests.starred".tr(),
                      ]
                    : [
                        "quests.active".tr(),
                        "quests.requested".tr(),
                        "quests.performed".tr(),
                      ]),
              ),
            ];
          },
          physics: const ClampingScrollPhysics(),
          body: TabBarView(
            children: [
              Observer(
                builder: (_) => Center(
                  child: refreshIndicator(
                    notificationListener(
                        QuestItemPriorityType.Active,
                        myQuests!.active,
                        role == UserRole.Employer
                            ? (statusCreate) {
                                if (statusCreate)
                                  myQuests!.getQuests(userID, role, false);
                              }
                            : null),
                  ),
                ),
              ),
              Observer(
                builder: (_) => Center(
                  child: refreshIndicator(
                    role == UserRole.Employer
                        ? notificationListener(QuestItemPriorityType.Requested,
                            myQuests!.requested, null)
                        : notificationListener(QuestItemPriorityType.Invited,
                            myQuests!.invited, null),
                  ),
                ),
              ),
              Observer(
                builder: (_) => Center(
                  child: refreshIndicator(
                    notificationListener(
                      QuestItemPriorityType.Performed,
                      myQuests!.performed,
                      null,
                    ),
                  ),
                ),
              ),
              if (role == UserRole.Worker)
                Observer(
                  builder: (_) => Center(
                    child: refreshIndicator(
                      notificationListener(QuestItemPriorityType.Starred,
                          myQuests!.starred, null),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget refreshIndicator(Widget child) => RefreshIndicator(
        onRefresh: () {
          return myQuests!.getQuests(userID, role, true);
        },
        child: child,
      );

  Widget notificationListener(QuestItemPriorityType type,
          ObservableList<BaseQuestResponse> list, Function(bool)? onCreate) =>
      NotificationListener<ScrollEndNotification>(
        onNotification: (scrollEnd) {
          final metrics = scrollEnd.metrics;
          if (metrics.atEdge || metrics.maxScrollExtent < metrics.pixels) {
            myQuests!.getQuests(userID, role, false);
          }
          return true;
        },
        child: Container(
          color: const Color(0xFFF7F8FA),
          child: Center(
            child: QuestsList(
              type,
              list,
              onCreate: onCreate,
              isLoading: myQuests!.isLoading,
            ),
          ),
        ),
      );
}

class _PersistentTabBar extends SliverPersistentHeaderDelegate {
  final List<String> titles;

  const _PersistentTabBar(this.titles);

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
