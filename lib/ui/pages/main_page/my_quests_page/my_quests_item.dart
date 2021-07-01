import 'package:app/ui/widgets/priority_view.dart';
import 'package:app/work_quest_app.dart';
import 'package:flutter/material.dart';

import '../../../../enums.dart';

class MyQuestsItem extends StatelessWidget {
  const MyQuestsItem({
    required this.itemType,
    required this.priority,
    required this.price,
    required this.title,
    required this.description,
    this.creatorName = "Samantha Sparcs",
    this.imageURL =
        "https://i.pinimg.com/736x/a9/3c/b4/a93cb4e0316ef9c4db83846550ff4deb.jpg",
    this.distance = 150,
  });

  final QuestItemPriorityType itemType;
  final int priority;
  final String price;
  final String title;
  final String creatorName;
  final String imageURL;
  final String description;
  final int distance;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(
        top: 10,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getQuestHeader(itemType),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(37),
                child: Image.network(
                  imageURL,
                  width: 30,
                  height: 30,
                ),
              ),
              Text(
                creatorName,
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
                "$distance from you",
                style: TextStyle(color: Color(0xFF7C838D)),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            title,
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
            description,
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
              PriorityView(priority),
              Spacer(),
              Text(
                price,
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
    );
  }

  Widget getQuestHeader(QuestItemPriorityType itemType) {
    Widget returnWidget = Container(
      child: Center(
        child: Text("you don't have any $itemType yet "),
      ),
    );
    switch (itemType) {
      case QuestItemPriorityType.Active:
        returnWidget = Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7.5),
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7.5),
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
      case QuestItemPriorityType.Performed:
        returnWidget = Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7.5),
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
