import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/create_quest_page/create_quest_page.dart';
import 'package:flutter/material.dart';

import '../../../../enums.dart';
import 'my_quests_item.dart';

class QuestsList extends StatelessWidget {
  final QuestItemPriorityType questItemPriorityType;

  final List<BaseQuestResponse>? questsList;

  final bool hasCreateButton;

  const QuestsList(this.questItemPriorityType, this.questsList,
      {this.hasCreateButton = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFFF7F8FA),
        child: questsList == null
            ? getLoadingBody()
            : questsList!.isNotEmpty
                ? getBody()
                : getEmptyBody());
  }

  Widget getBody() {
    return ListView.builder(
      itemCount: hasCreateButton ? questsList!.length + 1 : questsList!.length,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, index) {
        if (hasCreateButton) if (index == 0) {
          return Container(
            margin: EdgeInsets.only(top: 10.0),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed(CreateQuestPage.routeName);
                    },
                    child: Text("Add new quest"),
                  ),
                ),
              ],
            ),
          );
        }
        return MyQuestsItem(questsList![(hasCreateButton) ? index - 1 : index],
            itemType: questItemPriorityType);
      },
    );
  }

  Widget getEmptyBody() {
    return Center(
      child: Text(
        "you don't have any ${enumToString(questItemPriorityType)} Quest yet",
      ),
    );
  }

  Widget getLoadingBody() {
    return Center(child: CircularProgressIndicator());
  }

  String enumToString(QuestItemPriorityType questItemPriorityType) {
    switch (questItemPriorityType) {
      case QuestItemPriorityType.Active:
        return "Active";
      case QuestItemPriorityType.Invited:
        return "Invited";
      case QuestItemPriorityType.Requested:
        return "Requested";
      case QuestItemPriorityType.Performed:
        return "Performed";
      case QuestItemPriorityType.Starred:
        return "Starred";
    }
  }
}
