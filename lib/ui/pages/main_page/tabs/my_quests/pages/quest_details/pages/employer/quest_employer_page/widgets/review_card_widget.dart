import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String message;
  final int mark;

  const ReviewCard({
    Key? key,
    required this.message,
    required this.mark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFFF7F8FA),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "quests.yourReview".tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(message),
            const SizedBox(height: 10),
            Row(
              children: [
                for (int i = 0; i < mark; i++)
                  Icon(
                    Icons.star,
                    color: Color(0xFFE8D20D),
                    size: 20.0,
                  ),
                for (int i = 0; i < 5 - mark; i++)
                  Icon(
                    Icons.star,
                    color: Color(0xFFE9EDF2),
                    size: 20.0,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
