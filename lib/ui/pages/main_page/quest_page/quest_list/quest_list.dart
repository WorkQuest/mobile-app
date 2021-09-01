import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/my_quests_page/my_quests_item.dart';
import 'package:app/ui/pages/main_page/quest_page/filter_quests_page/filter_quests_page.dart';
import 'package:app/ui/pages/main_page/quest_page/notification_page/notification_page.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/store/quests_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/platform_activity_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import "package:provider/provider.dart";

class QuestList extends StatefulWidget {
  final Function() changePage;

  QuestList(this.changePage);

  @override
  _QuestListState createState() => _QuestListState();
}

class _QuestListState extends State<QuestList> {
  ScrollController? controller;

  QuestsStore? questsStore;

  ProfileMeStore? profileMeStore;

  final QuestItemPriorityType questItemPriorityType =
      QuestItemPriorityType.Starred;
  final scrollKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
    questsStore = context.read<QuestsStore>();
    profileMeStore = context.read<ProfileMeStore>();
    profileMeStore!.getProfileMe().then((value) {
      context.read<ChatStore>().initialSetup(
            profileMeStore!.userData!.id,
          );
      questsStore!.getQuests(profileMeStore!.userData!.id);
    });
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: "QuestListLeftActionButton",
              onPressed: widget.changePage,
              child: Icon(
                Icons.map_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    return CustomScrollView(
      controller: controller,
      slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: Row(
            children: [
              Expanded(child: const Text("Quests")),
              InkWell(
                onTap: () => Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(
                  NotificationPage.routeName,
                ),
                child: const Icon(Icons.notifications_none_outlined),
              ),
              const SizedBox(width: 20.0)
            ],
          ),
        ),
        SliverAppBar(
          pinned: true,
          title: TextFormField(
            maxLines: 1,
            onChanged: questsStore!.setSearchWord,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                size: 25.0,
              ),
              hintText: "City / Street / Place",
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              const SizedBox(height: 20),
              //if (profileMeStore!.userData!.role == UserRole.Worker)
                _getDivider(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    // Сделано для отладки будет перенесена в routes.dart
                    MaterialPageRoute(
                      builder: (_) => FilterQuestsPage(),
                    ),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.filter_list),
                      const Text("Filters"),
                    ],
                  ),
                ),
              ),
              _getDivider(),
              Observer(
                builder: (_) => questsStore!.emptySearch
                    ? Center(
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              "assets/empty_quest_icon.svg",
                            ),
                            Text(
                              "No Quest Found",
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        key: scrollKey,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return _getDivider();
                        },
                        padding: EdgeInsets.zero,
                        itemCount: questsStore!.searchWord.length > 2
                            ? questsStore!.searchResultList!.length
                            : questsStore!.questsList!.length,
                        itemBuilder: (_, index) {
                          return MyQuestsItem(
                            questsStore!.searchWord.length > 2
                                ? questsStore!.searchResultList![index]
                                : questsStore!.questsList![index],
                            itemType: this.questItemPriorityType,
                          );
                        }),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Observer(
            builder: (_) => questsStore!.isLoading
                ? Center(child: PlatformActivityIndicator())
                : const SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget _getDivider() {
    return SizedBox(
      height: 10,
      child: Container(
        color: Color(0xFFF7F8FA),
      ),
    );
  }

  void _scrollListener() {
    if (controller!.position.extentAfter < 500) {
      if (questsStore != null) {
        if (questsStore!.isLoading) return;
        questsStore!.getQuests(profileMeStore!.userData!.id);
      }
    }
  }
}
