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
    required this.active,
  });

  final ProfileMeResponse profile;
  final bool active;
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

  bool get isActiveQuest => widget.arguments.active;

  bool get isMyProfile => profile.id == myId;

  @override
  void initState() {
    store = context.read<ProfileQuestsStore>();
    profile = widget.arguments.profile;
    if (isActiveQuest) {
      store.getActiveQuests(
        userRole: profile.role,
        userId: profile.id,
        isProfileYours: isMyProfile,
        isForce: true,
      );
    } else {
      store.getCompletedQuests(
        userRole: profile.role,
        userId: profile.id,
        isProfileYours: isMyProfile,
        isForce: true,
      );
    }
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
            if (isActiveQuest) {
              store.getActiveQuests(
                userId: profile.id,
                isForce: true,
                isProfileYours: isMyProfile,
                userRole: profile.role,
              );
            } else {
              store.getCompletedQuests(
                userRole: profile.role,
                userId: profile.id,
                isForce: true,
                isProfileYours: isMyProfile,
              );
            }
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
                    if (isActiveQuest) {
                      store.getActiveQuests(
                        userId: profile.id,
                        isProfileYours: isMyProfile,
                        userRole: profile.role,
                      );
                    } else {
                      store.getCompletedQuests(
                        userRole: profile.role,
                        userId: profile.id,
                        isProfileYours: isMyProfile,
                      );
                    }
                  }
                  return true;
                },
                child: QuestsList(
                  widget.arguments.active ? QuestsType.Active : QuestsType.Performed,
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

  String _getEmptyText() {
    if (isMyProfile) {
      return isActiveQuest
          ? 'profiler.dontHaveActiveQuest'.tr()
          : 'profiler.dontHaveCompletedQuest'.tr();
    } else {
      return isActiveQuest
          ? 'profiler.dontHaveActiveQuestOtherUser'.tr()
          : 'profiler.dontHaveCompletedQuestOtherUser'.tr();
    }
  }
}
