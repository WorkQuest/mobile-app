import 'package:app/constants.dart';
import 'package:app/ui/pages/main_page/my_quests_page/quests_tab.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import '../../../../enums.dart';
import 'package:easy_localization/easy_localization.dart';

class MyQuestsPage extends StatefulWidget {
  static const String routeName = '/myQuestPage';

  MyQuestsPage();

  @override
  _MyQuestsPageState createState() => _MyQuestsPageState();
}

class _MyQuestsPageState extends State<MyQuestsPage>
    with SingleTickerProviderStateMixin {
  MyQuestStore? myQuests;
  late UserRole role;
  late String userID;
  late TabController _tabController;

  @override
  void initState() {
    myQuests = context.read<MyQuestStore>();
    ProfileMeStore profileMeStore = context.read<ProfileMeStore>();
    role = profileMeStore.userData?.role ?? UserRole.Employer;
    _tabController = TabController(
      vsync: this,
      length: role == UserRole.Worker ? 6 : 5,
    );
    profileMeStore.getProfileMe().then((value) {
      setState(() => role = profileMeStore.userData!.role);
      userID = profileMeStore.userData!.id;
      myQuests!.setId(userID);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            CupertinoSliverNavigationBar(
              largeTitle: Text("quests.MyQuests".tr()),
              border: const Border.fromBorderSide(BorderSide.none),
            ),
          ];
        },
        physics: const ClampingScrollPhysics(),
        body: DefaultTabController(
          length: role == UserRole.Worker ? 6 : 5,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                controller: _tabController,
                tabs: [
                  tab(text: 'quests.tabs.all'),
                  tab(text: 'quests.tabs.favorites'),
                  if (role == UserRole.Worker)
                    tab(text: 'quests.tabs.responded'),
                  if (role == UserRole.Worker) tab(text: 'quests.tabs.invited'),
                  if (role == UserRole.Employer)
                    tab(text: 'quests.tabs.created'),
                  tab(text: 'quests.tabs.active'),
                  if (role == UserRole.Employer)
                    tab(text: 'quests.tabs.completed'),
                  if (role == UserRole.Worker)
                    tab(text: 'quests.tabs.performed'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    QuestsTab(
                      store: myQuests!,
                      type: QuestsType.All,
                      role: role,
                    ),
                    QuestsTab(
                      store: myQuests!,
                      type: QuestsType.Favorites,
                      role: role,
                    ),
                    if (role == UserRole.Worker)
                      QuestsTab(
                        store: myQuests!,
                        type: QuestsType.Responded,
                        role: role,
                      ),
                    if (role == UserRole.Worker)
                      QuestsTab(
                        store: myQuests!,
                        type: QuestsType.Invited,
                        role: role,
                      ),
                    if (role == UserRole.Employer)
                      QuestsTab(
                        store: myQuests!,
                        type: QuestsType.Created,
                        role: role,
                      ),
                    QuestsTab(
                      store: myQuests!,
                      type: QuestsType.Active,
                      role: role,
                    ),
                    if (role == UserRole.Employer)
                      QuestsTab(
                        store: myQuests!,
                        type: QuestsType.Completed,
                        role: role,
                      ),
                    if (role == UserRole.Worker)
                      QuestsTab(
                        store: myQuests!,
                        type: QuestsType.Performed,
                        role: role,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tab({
    required String text,
  }) =>
      Tab(
        child: Text(
          text.tr(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColor.enabledButton,
            fontSize: 13.0,
          ),
        ),
      );
}
