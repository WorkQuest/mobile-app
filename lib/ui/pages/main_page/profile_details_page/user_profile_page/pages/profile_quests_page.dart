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

  ProfileQuestsPage(this.arguments);

  final ProfileQuestsArguments arguments;

  @override
  _ProfileQuestsPageState createState() => _ProfileQuestsPageState();
}

class _ProfileQuestsPageState extends State<ProfileQuestsPage> {
  ProfileMeStore? profileMeStore;
  late ProfileMeResponse profile;

  @override
  void initState() {
    profileMeStore = context.read<ProfileMeStore>();
    profileMeStore!.offset = 0;
    profileMeStore!.quests.clear();
    profile = widget.arguments.profile;
    Future.delayed(Duration.zero, () {
      widget.arguments.active
          ? profileMeStore!.getActiveQuests(
              userId: profile.id,
              newList: true,
              isProfileYours: profile.id == profileMeStore!.userData!.id,
            )
          : profileMeStore!.getCompletedQuests(
              userRole: profile.role,
              userId: profile.id,
              newList: true,
              isProfileYours: profile.id == profileMeStore!.userData!.id,
            );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        middle: Text("workers.quests".tr()),
      ),
      body: Observer(
        builder: (_) => !profileMeStore!.isLoading
            ? NotificationListener<ScrollEndNotification>(
                onNotification: (scrollEnd) {
                  final metrics = scrollEnd.metrics;
                  if (metrics.atEdge ||
                      metrics.maxScrollExtent < metrics.pixels &&
                          !profileMeStore!.isLoading) {
                    if (widget.arguments.active)
                      profileMeStore!.getActiveQuests(
                        userId: profileMeStore!.questHolder!.id,
                        newList: true,
                        isProfileYours:
                            profile.id == profileMeStore!.userData!.id,
                      );
                    else
                      profileMeStore!.getCompletedQuests(
                        userRole: profile.role,
                        userId: profile.id,
                        newList: false,
                        isProfileYours:
                            profile.id == profileMeStore!.userData!.id,
                      );
                  }
                  return true;
                },
                child: Observer(
                  builder: (_) => profileMeStore!.questHolder == null &&
                          profileMeStore!.isLoading &&
                          profileMeStore!.quests.isEmpty
                      ? Center(child: CircularProgressIndicator.adaptive())
                      : QuestsList(
                          widget.arguments.active
                              ? QuestsType.Active
                              : QuestsType.Performed,
                          profileMeStore!.quests,
                          isLoading: profileMeStore!.isLoading,
                          from: FromQuestList.questSearch,
                          role: profile.role,
                        ),
                ),
              )
            : Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}

class ProfileQuestsArguments {
  ProfileQuestsArguments({required this.profile, required this.active});

  final ProfileMeResponse profile;
  final bool active;
}
