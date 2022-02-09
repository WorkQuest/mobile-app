import 'package:app/ui/pages/main_page/my_quests_page/quests_list.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../../../enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class ProfileQuestsPage extends StatefulWidget {
  static const String routeName = "/questsPage";

  ProfileQuestsPage(this.userId);

  final String userId;

  @override
  _ProfileQuestsPageState createState() => _ProfileQuestsPageState();
}

class _ProfileQuestsPageState extends State<ProfileQuestsPage> {
  ProfileMeStore? profileMeStore;

  @override
  void initState() {
    profileMeStore = context.read<ProfileMeStore>();
    profileMeStore!.getQuestHolder(widget.userId).then((value) {
      profileMeStore!.offset = 0;
      profileMeStore!.quests.clear();
      profileMeStore!.questHolder!.role == UserRole.Worker
          ? profileMeStore!.getActiveQuests(profileMeStore!.questHolder!.id)
          : profileMeStore!.getCompletedQuests(profileMeStore!.questHolder!.id);
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
              largeTitle: Text(
                "profiler.quests".tr(),
              ),
              border: const Border.fromBorderSide(BorderSide.none),
            ),
          ];
        },
        physics: const ClampingScrollPhysics(),
        body: NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEnd) {
            final metrics = scrollEnd.metrics;
            if (metrics.atEdge ||
                metrics.maxScrollExtent < metrics.pixels &&
                    !profileMeStore!.isLoading) {
              if (profileMeStore!.questHolder!.role == UserRole.Worker)
                profileMeStore!
                    .getActiveQuests(profileMeStore!.questHolder!.id);
              else
                profileMeStore!
                    .getCompletedQuests(profileMeStore!.questHolder!.id);
            }
            return true;
          },
          child: Observer(
            builder: (_) => profileMeStore!.questHolder == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : QuestsList(
                    profileMeStore!.questHolder!.role == UserRole.Worker
                        ? QuestItemPriorityType.Active
                        : QuestItemPriorityType.Performed,
                    profileMeStore!.quests,
                    isLoading: profileMeStore!.isLoading,
                  ),
          ),
        ),
      ),
    );
  }
}
