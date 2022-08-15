import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/my_quests_page/quests_list.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/profile_quests_page/store/profile_quests_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import '../../../../../../../enums.dart';
import 'package:provider/provider.dart';

const _physics = BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

class ProfileQuestsArguments {
  ProfileQuestsArguments({
    required this.profile,
    required this.type,
  });

  final ProfileMeResponse profile;
  final ProfileQuestsType type;
}

class ProfileQuestsPage extends StatefulWidget {
  static const String routeName = "/questsPage";

  ProfileQuestsPage(this.arguments);

  final ProfileQuestsArguments arguments;

  @override
  _ProfileQuestsPageState createState() => _ProfileQuestsPageState();
}

class _ProfileQuestsPageState extends State<ProfileQuestsPage> {
  late ProfileMeResponse profile;
  late ProfileQuestsStore store;

  String get myId => GetIt.I.get<ProfileMeStore>().userData!.id;

  bool get isMyProfile => profile.id == myId;

  @override
  void initState() {
    store = context.read<ProfileQuestsStore>();
    profile = widget.arguments.profile;
    store.getQuests(
      userRole: profile.role,
      userId: profile.id,
      isProfileYours: isMyProfile,
      typeQuests: widget.arguments.type,
      isForce: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener<ProfileQuestsStore>(
      onSuccess: () {},
      onFailure: () => false,
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          automaticallyImplyLeading: true,
          middle: Text("workers.quests".tr()),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            store.getQuests(
              userRole: profile.role,
              userId: profile.id,
              isProfileYours: isMyProfile,
              typeQuests: widget.arguments.type,
              isForce: true,
            );
          },
          child: Observer(
            builder: (_) {
              if (store.isLoading && store.quests.isEmpty) {
                return Center(child: CircularProgressIndicator.adaptive());
              }
              if (store.isSuccess && store.quests.isEmpty) {
                return SingleChildScrollView(
                  physics: _physics,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                        ),
                        SvgPicture.asset(
                          "assets/empty_quest_icon.svg",
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          _getEmptyText(),
                          style: TextStyle(
                            color: Color(0xFFD8DFE3),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return NotificationListener<ScrollEndNotification>(
                onNotification: (scrollEnd) {
                  final metrics = scrollEnd.metrics;
                  if (metrics.atEdge ||
                      metrics.maxScrollExtent < metrics.pixels && !store.isLoading) {
                    store.getQuests(
                      userRole: profile.role,
                      userId: profile.id,
                      isProfileYours: isMyProfile,
                      typeQuests: widget.arguments.type,
                      isForce: false,
                    );
                  }
                  return true;
                },
                child: QuestsList(
                  _getType(),
                  store.quests,
                  isLoading: store.isLoading,
                  from: FromQuestList.questSearch,
                  role: profile.role,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  QuestsType _getType() {
    switch (widget.arguments.type) {
      case ProfileQuestsType.active:
        return QuestsType.Active;
      case ProfileQuestsType.completed:
        return QuestsType.Completed;
      case ProfileQuestsType.all:
        return QuestsType.All;
    }
  }

  String _getEmptyText() {
    if (isMyProfile) {
      switch (widget.arguments.type) {

        case ProfileQuestsType.active:
          return 'profiler.dontHaveActiveQuest'.tr();
        case ProfileQuestsType.completed:
          return 'profiler.dontHaveCompletedQuest'.tr();
        case ProfileQuestsType.all:
          return 'You don\'t have any quests';
      }
    } else {
      switch (widget.arguments.type) {
        case ProfileQuestsType.active:
          return 'profiler.dontHaveActiveQuestOtherUser'.tr();
        case ProfileQuestsType.completed:
          return 'profiler.dontHaveCompletedQuestOtherUser'.tr();
        case ProfileQuestsType.all:
          return 'User not have any quests';
      }
    }
  }
}
