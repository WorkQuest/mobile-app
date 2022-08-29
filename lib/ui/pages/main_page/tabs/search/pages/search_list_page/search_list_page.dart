import 'dart:async';

import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/my_quests_page/widgets/my_quests_item.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/my_quests_page/widgets/shimmer/shimmer_my_quest_item.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/filter_quests_page/filter_quests_page.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/notification_page/notification_page.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_list_page/entity/filter_arguments.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_list_page/store/search_list_store.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_list_page/widgets/shimmer/shimmer_workers_item.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_list_page/widgets/workers_item.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/utils/deep_link_util.dart';
import 'package:app/utils/storage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

const _divider = const SizedBox(
    height: 6, child: ColoredBox(color: AppColor.disabledButton));

class SearchListPage extends StatefulWidget {
  SearchListPage(this.changePage);

  final Function() changePage;

  @override
  _SearchListPageState createState() => _SearchListPageState();
}

class _SearchListPageState extends State<SearchListPage> {
  late SearchListStore store;
  late ProfileMeStore profileMeStore;

  final scrollKey = new GlobalKey();

  UserRole get role => profileMeStore.userData?.role ?? UserRole.Worker;

  @override
  void initState() {
    super.initState();
    store = context.read<SearchListStore>();
    profileMeStore = context.read<ProfileMeStore>();
    if (profileMeStore.userData == null) {
      profileMeStore.getProfileMe().then((value) {
        store.search(role: role);
      });
    } else {
      store.search(role: role);
    }

    Storage.readDeepLinkCheck().then((value) {
      if (value == "0") {
        DeepLinkUtil().initDeepLink();
        Storage.writeDeepLinkCheck("1");
      }
    });
    store.checkPush();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: _onRefresh,
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
                onPressed: _onPressedChangePage,
                child: Icon(Icons.map_outlined, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getBody() {
    return NotificationListener<ScrollEndNotification>(
      onNotification: _scrollListener,
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
                  onPressed: _onPressedOnNotifications,
                  child: const Icon(Icons.notifications_none_outlined),
                ),
                const SizedBox(width: 12.0)
              ],
            ),
          ),
          SliverAppBar(
            pinned: true,
            title: TextFormField(
              initialValue: store.searchWord,
              onChanged: (value) => store.search(role: role, searchLine: value),
              decoration: InputDecoration(
                fillColor: Color(0xFFF7F8FA),
                hintText: profileMeStore.userData!.role == UserRole.Worker
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
                    onPressed: _onPressedOnFilter,
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
                  if (store.isLoading) {
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
                  if (store.emptySearch)
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
                            profileMeStore.userData!.role == UserRole.Worker
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
                      itemCount: role == UserRole.Worker
                          ? store.questsList.length
                          : store.workersList.length,
                      itemBuilder: (_, index) {
                        return Observer(
                          builder: (_) {
                            if (role == UserRole.Worker) {
                              final item = store.questsList[index];
                              return MyQuestsItem(
                                questInfo: item,
                                itemType: QuestsType.Favorites,
                              );
                            }

                            final item = store.workersList[index];
                            return WorkersItem(item, store);
                          },
                        );
                      },
                    );
                }),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Observer(builder: (_) {
              return (store.isLoading || store.isLoadingMore)
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

  bool _scrollListener(ScrollEndNotification scrollEnd) {
    final before = scrollEnd.metrics.extentBefore;
    final max = scrollEnd.metrics.maxScrollExtent;

    if (before == max) {
      if (store.isLoading) return true;
      store.search(role: role, searchLine: store.searchWord, isForce: false);
    }

    return true;
  }

  Future<void> _onRefresh() async {
    store.search(role: role, searchLine: store.searchWord);
  }

  _onPressedOnFilter() async {
    final result = await Navigator.of(context, rootNavigator: true).pushNamed(
      FilterQuestsPage.routeName,
    );
    if (result != null && result is FilterArguments) {
      store.filters = result;
      store.search(role: role, searchLine: store.searchWord);
    }
  }

  _onPressedOnNotifications() {
    Navigator.of(context, rootNavigator: true)
        .pushNamed(NotificationPage.routeName);
  }

  _onPressedChangePage() {
    widget.changePage();
    FocusScope.of(context).unfocus();
  }
}
