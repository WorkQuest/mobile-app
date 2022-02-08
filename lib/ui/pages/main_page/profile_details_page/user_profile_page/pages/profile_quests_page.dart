import 'package:app/ui/pages/main_page/my_quests_page/quests_list.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:flutter/material.dart';
import '../../../../../../enums.dart';

class ProfileQuestsPage extends StatefulWidget {
  static const String routeName = "/questsPage";

  ProfileQuestsPage(this.profile);

  final ProfileMeStore profile;

  @override
  _ProfileQuestsPageState createState() => _ProfileQuestsPageState();
}

class _ProfileQuestsPageState extends State<ProfileQuestsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QuestsList(
        QuestItemPriorityType.Performed,
        widget.profile.quests,
        isLoading: widget.profile.isLoading,
      ),
    );
  }
}
