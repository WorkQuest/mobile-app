import 'package:app/ui/pages/main_page/my_quests_page/quests_list.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../../../enums.dart';
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

  late UserRole role;

  @override
  void initState() {
    profileMeStore = context.read<ProfileMeStore>();
    profileMeStore!.offset = 0;
    profileMeStore!.quests.clear();
    if (profileMeStore!.userData!.id != widget.userId)
      profileMeStore!.getQuestHolder(widget.userId).then((value) {
        role = profileMeStore!.questHolder!.role;
        role == UserRole.Worker
            ? profileMeStore!
                .getActiveQuests(profileMeStore!.questHolder!.id, true)
            : profileMeStore!
                .getCompletedQuests(profileMeStore!.questHolder!.id, true);
      });
    else {
      profileMeStore!.getCompletedQuests(profileMeStore!.userData!.id, true);
      role = profileMeStore!.userData!.role;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        middle: Text(
          "Quests",
        ),
      ),
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (scrollEnd) {
          final metrics = scrollEnd.metrics;
          if (metrics.atEdge ||
              metrics.maxScrollExtent < metrics.pixels &&
                  !profileMeStore!.isLoading) {
            if (role == UserRole.Worker)
              profileMeStore!.getActiveQuests(widget.userId, false);
            else
              profileMeStore!.getCompletedQuests(widget.userId, false);
          }
          return true;
        },
        child: Observer(
          builder: (_) => profileMeStore!.questHolder == null &&
                  profileMeStore!.isLoading &&
                  profileMeStore!.quests.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : QuestsList(
                  role == UserRole.Worker
                      ? QuestItemPriorityType.Active
                      : QuestItemPriorityType.Performed,
                  profileMeStore!.quests,
                  isLoading: profileMeStore!.isLoading,
                ),
        ),
      ),
    );
  }
}
