import 'package:flutter/material.dart';

class UserRating extends StatelessWidget {
  UserRating(this.status);

  final String status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case "topRanked":
        return tag(
          text: "GOLD PLUS",
          color: Color(0xFFF6CF00),
        );
      case "reliable":
        return tag(
          text: "SILVER",
          color: Color(0xFFBBC0C7),
        );

      case "verified":
        return tag(
          text: "BRONZE",
          color: Color(0xFFB79768),
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget tag({required String text, required Color color}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
          ),
        ),
      );
}
