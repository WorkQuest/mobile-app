import 'package:flutter/material.dart';

class UserRating extends StatelessWidget {
  UserRating(
    this.status, {
    Key? key,
    this.isWorker = false,
  }) : super(key: key);

  final int status;
  final bool isWorker;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 8:
        return tag(
          text: isWorker ? "TOP RANKED" : "GOLD PLUS",
          color: Color(0xFFF6CF00),
        );
      case 4:
        return tag(
          text: isWorker ? "RELIABLE" : "SILVER",
          color: Color(0xFFBBC0C7),
        );

      case 2:
        return tag(
          text: isWorker ? "VERIFIED" : "BRONZE",
          color: Color(0xFFB79768),
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget tag({required String text, required Color color,}) => Container(
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
