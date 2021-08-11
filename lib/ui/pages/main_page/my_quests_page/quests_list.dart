import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:flutter/material.dart';

import '../../../../enums.dart';
import 'my_quests_item.dart';

class QuestsList extends StatelessWidget {
  final QuestItemPriorityType questItemPriorityType;

  final List<BaseQuestResponse>? questsList;

  const QuestsList(this.questItemPriorityType, this.questsList);

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
      itemCount: questsList!.length,
      padding: EdgeInsets.zero,
      itemBuilder: (_, index) {
        return MyQuestsItem(questsList![index],
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
      case QuestItemPriorityType.Performed:
        return "Performed";
      case QuestItemPriorityType.Starred:
        return "Starred";
    }
  }
}
