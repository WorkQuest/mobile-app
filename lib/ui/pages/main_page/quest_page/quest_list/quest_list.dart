import 'package:app/enums.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/my_quests_page/my_quests_item.dart';
import 'package:app/ui/pages/main_page/quest_page/filter_quests_page/filter_quests_page.dart';
import 'package:app/ui/pages/main_page/quest_page/filter_quests_page/store/filter_quests_store.dart';
import 'package:app/ui/pages/main_page/quest_page/notification_page/notification_page.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/store/quests_store.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/workers_item.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

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

  FilterQuestsStore? filterQuestsStore;

  final QuestItemPriorityType questItemPriorityType =
      QuestItemPriorityType.Starred;
  final scrollKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
    questsStore = context.read<QuestsStore>();
    filterQuestsStore = context.read<FilterQuestsStore>();
    filterQuestsStore!.getFilters([], {});
    profileMeStore = context.read<ProfileMeStore>();
    profileMeStore!.getProfileMe().then((value) {
      context.read<ChatStore>().initialSetup(
            profileMeStore!.userData!.id,
          );
      context.read<ChatStore>().role = profileMeStore!.userData!.role;
      profileMeStore!.userData!.role == UserRole.Worker
          ? questsStore!.getQuests(true)
          : questsStore!.getWorkers(true);
      questsStore!.role = profileMeStore!.userData!.role;
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
    );
  }

  Widget getBody() {
    final role = profileMeStore?.userData?.role;
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () async {
        if (role == UserRole.Worker && !questsStore!.isLoading)
          return questsStore!.getQuests(true);
        else
          return questsStore!.getWorkers(true);
      },
      displacement: 50,
      edgeOffset: 300,
      child: CustomScrollView(
        controller: controller,
        physics: AlwaysScrollableScrollPhysics(),
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
                InkWell(
                  onTap: () => Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(
                    NotificationPage.routeName,
                    arguments: profileMeStore!.userData!.id,
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
              onChanged: (value) => value.isNotEmpty
                  ? questsStore!.setSearchWord(value)
                  : profileMeStore!.userData!.role == UserRole.Worker
                      ? questsStore!.getQuests(true)
                      : questsStore!.getWorkers(true),
              decoration: InputDecoration(
                fillColor: Color(0xFFF7F8FA),
                hintText: profileMeStore!.userData!.role == UserRole.Worker
                    ? "Employer / Title / Description"
                    : "Employee / City",
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
                _getDivider(),
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
                        SizedBox(
                          width: 13,
                        ),
                        Text(
                          "quests.filter.btn".tr(),
                        ),
                      ],
                    ),
                  ),
                ),
                _getDivider(),
                Observer(builder: (_) {
                  if (questsStore!.isLoading) {
                    return ListView.separated(
                      key: scrollKey,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return _getDivider();
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
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          SvgPicture.asset(
                            "assets/empty_quest_icon.svg",
                          ),
                          Text(
                            profileMeStore!.userData!.role == UserRole.Worker
                                ? "quests.noQuest".tr()
                                : "Worker not wound",
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
                        return _getDivider();
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
                              item,
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
            child: Observer(
              builder: (_) => questsStore!.isLoading
                  ? Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getDivider() {
    return SizedBox(
      height: 6,
      child: Container(
        color: Color(0xFFF7F8FA),
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

  void _scrollListener() {
    if (controller!.position.extentAfter < 500) {
      if (questsStore != null) {
        if (questsStore!.isLoading) return;
        if (profileMeStore!.userData!.role == UserRole.Worker)
          questsStore!.searchWord.length > 2
              ? questsStore!.getSearchedQuests()
              : questsStore!.getQuests(false);
        else
          questsStore!.searchWord.length > 2
              ? questsStore!.getSearchedWorkers()
              : questsStore!.getWorkers(false);
      }
    }
  }
}

class _AnimationWorkersQuestsItems extends StatefulWidget {
  final Widget child;
  final int index;
  final bool enabled;

  const _AnimationWorkersQuestsItems({
    Key? key,
    required this.child,
    this.enabled = false,
    this.index = 0,
  }) : super(key: key);

  @override
  _AnimationWorkersQuestsItemsState createState() =>
      _AnimationWorkersQuestsItemsState();
}

class _AnimationWorkersQuestsItemsState
    extends State<_AnimationWorkersQuestsItems> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 550));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enabled) {
      _animationController.forward();
    }
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(25 - (25 * _animationController.value), 0),
          child: Opacity(
            opacity: 0.1 + 0.9 * _animationController.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
