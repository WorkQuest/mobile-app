import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/quest_details_page/quest_details_page.dart';
import 'package:app/ui/widgets/priority_view.dart';
import 'package:app/work_quest_app.dart';
import 'package:flutter/material.dart';
import '../../../../enums.dart';

class MyQuestsItem extends StatelessWidget {
  const MyQuestsItem(
    this.questInfo, {
    this.itemType = QuestItemPriorityType.Active,
    this.isExpanded = false,
  });

  final BaseQuestResponse questInfo;
  final bool isExpanded;
  final QuestItemPriorityType itemType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pushNamed(
          QuestDetails.routeName,
          arguments: questInfo,
        );
      },
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(
          top: 10,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isExpanded) getQuestHeader(itemType),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    questInfo.user.avatar.url,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  questInfo.user.firstName + questInfo.user.lastName,
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
            SizedBox(
              height: 17.5,
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: Color(0xFF7C838D),
                ),
                SizedBox(
                  width: 9,
                ),
                Text(
                  "150 from you",
                  style: TextStyle(color: Color(0xFF7C838D)),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              questInfo.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF1D2127),
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              questInfo.description,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF4C5767),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                PriorityView(questInfo.priority),
                Spacer(),
                Text(
                  questInfo.price + "  WUSD",
                  style: TextStyle(
                      color: Color(0xFF00AA5B),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget getQuestHeader(QuestItemPriorityType itemType) {
    Widget returnWidget = Container();
    switch (itemType) {
      case QuestItemPriorityType.Active:
        returnWidget = Container(
          margin: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7.5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: AppColors.green,
          ),
          child: Row(
            children: [
              Text(
                "Active",
                style: TextStyle(color: Colors.white),
              ),
              Spacer(),
              Text(
                "Runtime",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "14:10:23",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
        break;
      case QuestItemPriorityType.Invited:
        returnWidget = Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7.5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Color(0xFFE8D20D),
          ),
          child: Row(
            children: [
              Text(
                "You invited",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
        break;
      case QuestItemPriorityType.Requested:
        returnWidget = Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7.5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Color(0xFFE8D20D),
          ),
          child: Row(
            children: [
              Text(
                "You Requested",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
        break;
      case QuestItemPriorityType.Performed:
        returnWidget = Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7.5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Color(0xFF0083C7),
          ),
          child: Row(
            children: [
              Text(
                "Performed",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
        break;
      case QuestItemPriorityType.Starred:
        returnWidget = SizedBox(
          height: 16,
        );
        break;
    }
    return returnWidget;
  }
}
