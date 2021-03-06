import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

// 0 - low; 1 - normal; 2 - urgent
class PriorityView extends StatelessWidget {
  const PriorityView(this.priority, this.quest);

  final int priority;

  final bool quest;

  @override
  Widget build(BuildContext context) {
    Widget returnWidget = Container();
    switch (priority) {
      case 0:
        returnWidget = Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFF22CC14).withOpacity(0.1),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            quest ? "Fixed delivery" : "priority.lowPriority".tr(),
            style: TextStyle(
              color: Color(0xFF22CC14),
            ),
          ),
        );
        break;
      case 1:
        returnWidget = Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFFE8D20D).withOpacity(0.1),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            quest ? "Short term" : "priority.normalPriority".tr(),
            style: TextStyle(
              color: Color(0xFFE8D20D),
            ),
          ),
        );
        break;
      case 2:
        returnWidget = Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFFDF3333).withOpacity(0.1),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            "priority.urgent".tr(),
            style: TextStyle(color: Color(0xFFDF3333)),
          ),
        );
        break;
    }
    return returnWidget;
  }
}
