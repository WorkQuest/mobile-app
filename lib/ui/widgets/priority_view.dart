import 'package:flutter/material.dart';

// 0 - low; 1 - normal; 2 - urgent
class PriorityView extends StatelessWidget {
  const PriorityView(this.priority);

  final int priority;

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
            "Low priority",
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
            "Normal priority",
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
            "Urgent ",
            style: TextStyle(color: Color(0xFFDF3333)),
          ),
        );
        break;
    }
    return returnWidget;
  }
}
