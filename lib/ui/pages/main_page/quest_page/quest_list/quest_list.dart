import 'dart:async';
import 'dart:convert';

import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/model/notification_model.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/my_quests_page/my_quests_item.dart';
import 'package:app/ui/pages/main_page/my_quests_page/shimmer/shimmer_my_quest_item.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/notification_page/notification_page.dart';
import 'package:app/ui/pages/main_page/quest_page/filter_quests_page/filter_quests_page.dart';
import 'package:app/ui/pages/main_page/quest_page/filter_quests_page/store/filter_quests_store.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/shimmer/shimmer_workers_item.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/store/quests_store.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/workers_item.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/utils/deep_link_util.dart';
import 'package:app/utils/push_notification/open_scree_from_push.dart';
import 'package:app/utils/storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

const _divider = const SizedBox(
  height: 6,
  child: ColoredBox(color: AppColor.disabledButton),
);

class QuestList extends StatefulWidget {
  final Function() changePage;

  QuestList(this.changePage);

  @override
  _QuestListState createState() => _QuestListState();
}

class _QuestListState extends State<QuestList> {
  QuestsStore? questsStore;

  ProfileMeStore? profileMeStore;

  FilterQuestsStore? filterQuestsStore;

  final QuestsType questItemPriorityType = QuestsType.Favorites;
  final scrollKey = new GlobalKey();

  UserRole? role;

  @override
  void initState() {
    super.initState();
    questsStore = context.read<QuestsStore>();
    filterQuestsStore = context.read<FilterQuestsStore>();
    filterQuestsStore!.getFilters([], {});
    profileMeStore = context.read<ProfileMeStore>();
    profileMeStore!.getProfileMe().then((value) {
      context.read<ChatStore>().initialSetup(profileMeStore!.userData!.id);
      context.read<MyQuestStore>().setRole(profileMeStore!.userData!.role);
      profileMeStore!.userData!.role == UserRole.Worker
          ? questsStore!.getQuests(true)
          : questsStore!.getWorkers(true);
      questsStore!.role = profileMeStore!.userData!.role;
      role = profileMeStore!.userData!.role;
    });

    Storage.readDeepLinkCheck().then((value) {
      if (value == "0") {
        DeepLinkUtil().initDeepLink();
        Storage.writeDeepLinkCheck("1");
      }
    });
    _checkPush();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: questsStore!.searchWord.isNotEmpty
            ? getBody()
            : RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: () async {
                  if (questsStore!.searchWord.isNotEmpty)
                    return;
                  else if (role == UserRole.Worker && !questsStore!.isLoading)
                    return questsStore!.getQuests(true);
                  else
                    return questsStore!.getWorkers(true);
                },
                displacement: 50,
                edgeOffset: 250,
                child: getBody(),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                heroTag: "QuestListLeftActionButton",
                onPressed: () {
                  widget.changePage();
                  FocusScope.of(context).unfocus();
                },
                child: Icon(
                  Icons.map_outlined,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getBody() {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (ScrollEndNotification scrollEnd) {
        final metrics = scrollEnd.metrics;
        if (metrics.maxScrollExtent <= metrics.pixels) {
          if (questsStore!.isLoading) return true;
          if (profileMeStore!.userData!.role == UserRole.Worker) {
            questsStore!.searchWord.length > 0
                ? questsStore!.getSearchedQuests(false)
                : questsStore!.getQuests(false);
          } else {
            questsStore!.searchWord.length > 0
                ? questsStore!.getSearchedWorkers(false)
                : questsStore!.getWorkers(false);
          }
        }
        return true;
      },
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Row(
              children: [
                Expanded(
                  child: Text(
                    role == UserRole.Worker
                        ? "quests.quests".tr()
                        : "workers.workers".tr(),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(
                    NotificationPage.routeName,
                    arguments: profileMeStore!.userData!.id,
                  ),
                  child: const Icon(Icons.notifications_none_outlined),
                ),
                const SizedBox(width: 12.0)
              ],
            ),
          ),
          SliverAppBar(
            pinned: true,
            title: TextFormField(
              initialValue: questsStore!.searchWord,
              onChanged: (value) => questsStore!.setSearchWord(value),
              decoration: InputDecoration(
                fillColor: Color(0xFFF7F8FA),
                hintText: profileMeStore!.userData!.role == UserRole.Worker
                    ? "quests.hintWorker".tr()
                    : "quests.hintEmployer".tr(),
                prefixIcon: Icon(
                  Icons.search,
                  size: 25.0,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 8),
                _divider,
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: OutlinedButton(
                    onPressed: () async {
                      await Navigator.of(context, rootNavigator: true)
                          .pushNamed(FilterQuestsPage.routeName,
                              arguments: filterQuestsStore!.skillFilters);
                    },
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
                        SvgPicture.asset("assets/filter.svg"),
                        const SizedBox(width: 13),
                        Text("quests.filter.btn".tr()),
                      ],
                    ),
                  ),
                ),
                _divider,
                Observer(builder: (_) {
                  if (questsStore!.isLoading) {
                    return ListView.separated(
                      key: scrollKey,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return _divider;
                      },
                      padding: EdgeInsets.zero,
                      itemCount: 8,
                      itemBuilder: (_, index) {
                        if (role == UserRole.Worker) {
                          return ShimmerMyQuestItem();
                        }
                        return ShimmerWorkersItem();
                      },
                    );
                  }
                  if (questsStore!.emptySearch)
                    return Container(
                      height: MediaQuery.of(context).size.height / 4,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 15),
                          SvgPicture.asset("assets/empty_quest_icon.svg"),
                          const SizedBox(height: 10),
                          Text(
                            profileMeStore!.userData!.role == UserRole.Worker
                                ? "quests.noQuest".tr()
                                : "Worker not found",
                            style: TextStyle(
                              color: Color(0xFFD8DFE3),
                            ),
                          ),
                        ],
                      ),
                    );
                  else
                    return ListView.separated(
                      key: scrollKey,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return _divider;
                      },
                      padding: EdgeInsets.zero,
                      itemCount: () {
                        if (role == UserRole.Worker)
                          return questsStore!.questsList.length;
                        return questsStore!.workersList.length;
                      }(),
                      itemBuilder: (_, index) {
                        return Observer(builder: (_) {
                          if (role == UserRole.Worker) {
                            final item = questsStore!.questsList[index];
                            _markItem(item);
                            return MyQuestsItem(
                              questInfo: item,
                              itemType: this.questItemPriorityType,
                            );
                          }
                          final item = questsStore!.workersList[index];
                          _markItem(item);
                          return WorkersItem(
                            item,
                            questsStore!,
                          );
                        });
                      },
                    );
                }),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Observer(builder: (_) {
              return (questsStore!.isLoading || questsStore!.isLoadingMore)
                  ? Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : const SizedBox();
            }),
          ),
        ],
      ),
    );
  }

  Future _markItem(dynamic object) async {
    await Future.delayed(const Duration(seconds: 1));
    if (object is BaseQuestResponse) {
      object.showAnimation = false;
    }
    if (object is ProfileMeResponse) {
      object.showAnimation = false;
    }
  }

  Future<void> _checkPush() async {
    final payload = await Storage.readPushPayload();
    if (payload != null) {
      final response = jsonDecode(payload);
      final notification = NotificationNotification.fromJson(response);
      OpenScreeFromPush().openScreen(notification);
      Storage.delete("pushPayload");
    }
  }
}
