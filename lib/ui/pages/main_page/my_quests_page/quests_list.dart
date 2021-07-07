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
      child: questsList!.isNotEmpty
          ? ListView.builder(
              itemCount: questsList!.length,
              padding: EdgeInsets.zero,
              itemBuilder: (_, index) {
                return MyQuestsItem(
                  title: questsList![index].title,
                  itemType: questItemPriorityType,
                  price: questsList![index].price,
                  priority: questsList![index].priority,
                  creatorName: questsList![index].user.firstName +
                      questsList![index].user.lastName,
                  description: questsList![index].description,
                );

                //   Padding(
                //   padding: const EdgeInsets.all(5.0),
                //   child: Container(
                //     color: Colors.red,
                //     child: Padding(
                //       padding: const EdgeInsets.all(20.0),
                //       child: Center(child: Text("$label $index")),
                //     ),
                //   ),
                // );
              },
            )
          : Center(
              child: Text(
                "you don't have any ${enumToString(questItemPriorityType)} Quest yet",
              ),
            ),
    );
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
