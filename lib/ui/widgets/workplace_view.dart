import 'package:flutter/material.dart';

class WorkplaceView extends StatelessWidget {
  const WorkplaceView(this.workplace);

  final String workplace;

  @override
  Widget build(BuildContext context) {
    Widget returnWidget = Container();
    switch (workplace) {
      case "Remote":
        returnWidget = Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFF0083C7).withOpacity(0.1),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            "Distant work",
            style: TextStyle(
              color: Color(0xFF0083C7),
            ),
          ),
        );
        break;
      case "InOffice":
        returnWidget = Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFF0083C7).withOpacity(0.1),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            "Work in office",
            style: TextStyle(
              color: Color(0xFF0083C7),
            ),
          ),
        );
        break;
      case "Hybrid":
        returnWidget = Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          decoration: BoxDecoration(
            color: Color(0xFF0083C7).withOpacity(0.1),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            "Both variant",
            style: TextStyle(
              color: Color(0xFF0083C7),
            ),
          ),
        );
        break;
    }
    return returnWidget;
  }
}
