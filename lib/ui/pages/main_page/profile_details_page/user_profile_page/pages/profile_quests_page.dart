import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/my_quests_page/quests_list.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../../../enums.dart';
import 'package:provider/provider.dart';

class ProfileQuestsPage extends StatefulWidget {
  static const String routeName = "/questsPage";

  ProfileQuestsPage(this.profile);

  final ProfileMeResponse profile;

  @override
  _ProfileQuestsPageState createState() => _ProfileQuestsPageState();
}

class _ProfileQuestsPageState extends State<ProfileQuestsPage> {
  ProfileMeStore? profileMeStore;

  @override
  void initState() {
    profileMeStore = context.read<ProfileMeStore>();
    profileMeStore!.offset = 0;
    profileMeStore!.quests.clear();
    if (profileMeStore!.userData!.id != widget.profile.id) {
      widget.profile.role == UserRole.Worker
          ? profileMeStore!.getActiveQuests(
              userId: widget.profile.id,
              newList: true,
              isProfileYours: false,
            )
          : profileMeStore!.getCompletedQuests(
              userRole: widget.profile.role,
              userId: widget.profile.id,
              newList: true,
              isProfileYours: false,
            );
    } else {
      profileMeStore!.getCompletedQuests(
        userRole: profileMeStore!.userData!.role,
        userId: profileMeStore!.userData!.id,
        newList: true,
        isProfileYours: false,
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        middle: Text(
          "workers.quests".tr(),
        ),
      ),
      body: Observer(
        builder: (_) => !profileMeStore!.isLoading
            ? NotificationListener<ScrollEndNotification>(
                onNotification: (scrollEnd) {
                  final metrics = scrollEnd.metrics;
                  if (metrics.atEdge || metrics.maxScrollExtent < metrics.pixels && !profileMeStore!.isLoading) {
                    if (widget.profile.role == UserRole.Worker)
                      profileMeStore!.getActiveQuests(
                        userId: profileMeStore!.questHolder!.id,
                        newList: true,
                        isProfileYours: profileMeStore!.userData!.id != widget.profile.id ? false : true,
                      );
                    else
                      profileMeStore!.getCompletedQuests(
                        userRole: widget.profile.role,
                        userId: widget.profile.id,
                        newList: false,
                        isProfileYours: profileMeStore!.userData!.id != widget.profile.id ? false : true,
                      );
                  }
                  return true;
                },
                child: Observer(
                  builder: (_) =>
                      profileMeStore!.questHolder == null && profileMeStore!.isLoading && profileMeStore!.quests.isEmpty
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : QuestsList(
                              widget.profile.role == UserRole.Worker
                                  ? QuestItemPriorityType.Active
                                  : QuestItemPriorityType.Performed,
                              profileMeStore!.quests,
                              isLoading: profileMeStore!.isLoading,
                              from: FromQuestList.questSearch,
                            ),
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
