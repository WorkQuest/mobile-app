import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/my_quests_page/quests_list.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/quest_page/create_quest_page/create_quest_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/quest_tab_bar.dart';
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
                delegate: PersistentTabBar(role == UserRole.Worker
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
          body: ColoredBox(
            color: Color(0xFFF7F8FA),
            child: TabBarView(
              children: [
                Observer(
                  builder: (_) => tabWrapper(
                    QuestItemPriorityType.Active,
                    myQuests!.active,
                  ),
                ),
                Observer(
                  builder: (_) => tabWrapper(
                    role == UserRole.Employer
                        ? QuestItemPriorityType.Requested
                        : QuestItemPriorityType.Invited,
                    role == UserRole.Employer
                        ? myQuests!.requested
                        : myQuests!.invited,
                  ),
                ),
                Observer(
                  builder: (_) => tabWrapper(
                    QuestItemPriorityType.Performed,
                    myQuests!.performed,
                  ),
                ),
                if (role == UserRole.Worker)
                  Observer(
                    builder: (_) => tabWrapper(
                      QuestItemPriorityType.Starred,
                      myQuests!.starred,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tabWrapper(
    QuestItemPriorityType type,
    ObservableList<BaseQuestResponse> list,
  ) =>
      RefreshIndicator(
        onRefresh: () {
          return myQuests!.getQuests(userID, role, true);
        },
        child: NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEnd) {
            final metrics = scrollEnd.metrics;
            if (metrics.atEdge || metrics.maxScrollExtent < metrics.pixels) {
              myQuests!.getQuests(userID, role, false);
            }
            return true;
          },
          child: Column(
            children: [
              if (role == UserRole.Employer &&
                  type == QuestItemPriorityType.Active)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    right: 12.0,
                    top: 5.0,
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.of(context, rootNavigator: true)
                          .pushNamed<bool>(CreateQuestPage.routeName)
                          .then(
                            (value) =>
                                myQuests!.getQuests(userID, role, false),
                          );
                    },
                    child: Text(
                      "quests.addNewQuest".tr(),
                    ),
                  ),
                ),
              Expanded(
                child: QuestsList(
                  type,
                  list,
                  isLoading: myQuests!.isLoading,
                ),
              ),
            ],
          ),
        ),
      );
}
