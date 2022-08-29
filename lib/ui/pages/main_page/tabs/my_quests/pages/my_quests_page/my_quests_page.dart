import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/my_quests_page/widgets/quests_list_type.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

class MyQuestsPage extends StatefulWidget {
  static const String routeName = '/myQuestPage';

  MyQuestsPage();

  @override
  _MyQuestsPageState createState() => _MyQuestsPageState();
}

class _MyQuestsPageState extends State<MyQuestsPage>
    with SingleTickerProviderStateMixin {
  late MyQuestStore myQuests;
  late TabController _tabController;

  UserRole get role => context.read<ProfileMeStore>().userData?.role ?? UserRole.Worker;

  @override
  void initState() {
    myQuests = context.read<MyQuestStore>();
    _tabController = TabController(
      vsync: this,
      length: role == UserRole.Worker ? 6 : 5,
    );
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
                    QuestsListType(
                      store: myQuests,
                      type: QuestsType.All,
                      role: role,
                    ),
                    QuestsListType(
                      store: myQuests,
                      type: QuestsType.Favorites,
                      role: role,
                    ),
                    if (role == UserRole.Worker)
                      QuestsListType(
                        store: myQuests,
                        type: QuestsType.Responded,
                        role: role,
                      ),
                    if (role == UserRole.Worker)
                      QuestsListType(
                        store: myQuests,
                        type: QuestsType.Invited,
                        role: role,
                      ),
                    if (role == UserRole.Employer)
                      QuestsListType(
                        store: myQuests,
                        type: QuestsType.Created,
                        role: role,
                      ),
                    QuestsListType(
                      store: myQuests,
                      type: QuestsType.Active,
                      role: role,
                    ),
                    if (role == UserRole.Employer)
                      QuestsListType(
                        store: myQuests,
                        type: QuestsType.Completed,
                        role: role,
                      ),
                    if (role == UserRole.Worker)
                      QuestsListType(
                        store: myQuests,
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
