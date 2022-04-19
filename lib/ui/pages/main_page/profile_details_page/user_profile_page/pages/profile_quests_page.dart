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

  late Future<UserRole?> future;

  @override
  void initState() {
    profileMeStore = context.read<ProfileMeStore>();
    profileMeStore!.offset = 0;
    profileMeStore!.quests.clear();
    future = _getRole();
    super.initState();
  }

  Future<UserRole?> _getRole() async {
    UserRole? role;
    if (profileMeStore!.userData!.id != widget.userId) {
      await profileMeStore!.getQuestHolder(widget.userId);
      role = profileMeStore!.questHolder!.role;
      role == UserRole.Worker
          ? profileMeStore!.getActiveQuests(
              userId: profileMeStore!.questHolder!.id,
              newList: true,
              isProfileYours: false,
            )
          : profileMeStore!.getCompletedQuests(
              userId: profileMeStore!.questHolder!.id,
              newList: true,
              isProfileYours: false,
            );
    } else {
      await profileMeStore!.getCompletedQuests(
        userId: profileMeStore!.userData!.id,
        newList: true,
        isProfileYours: false,
      );
      role = profileMeStore!.userData!.role;
    }
    return Future.value(role);
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
      body: FutureBuilder<UserRole?>(
        future: future,
        builder: (_, snapshot) {
          print('snapshot.connectionState: ${snapshot.connectionState}');
          if (snapshot.connectionState == ConnectionState.done) {
            return NotificationListener<ScrollEndNotification>(
              onNotification: (scrollEnd) {
                final metrics = scrollEnd.metrics;
                if (metrics.atEdge ||
                    metrics.maxScrollExtent < metrics.pixels &&
                        !profileMeStore!.isLoading) {
                  if (snapshot.data == UserRole.Worker)
                    profileMeStore!.getActiveQuests(
                      userId: profileMeStore!.questHolder!.id,
                      newList: true,
                      isProfileYours:
                          profileMeStore!.userData!.id != widget.userId
                              ? false
                              : true,
                    );
                  else
                    profileMeStore!.getCompletedQuests(
                      userId: widget.userId,
                      newList: false,
                      isProfileYours:
                          profileMeStore!.userData!.id != widget.userId
                              ? false
                              : true,
                    );
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
                          snapshot.data == UserRole.Worker
                              ? QuestItemPriorityType.Active
                              : QuestItemPriorityType.Performed,
                          profileMeStore!.quests,
                          isLoading: profileMeStore!.isLoading,
                        )),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
