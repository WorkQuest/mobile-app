import 'package:app/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../enums.dart';

class QuestHeader extends StatelessWidget {
  const QuestHeader(this.itemType, this.questStatus, this.rounded);

  final QuestItemPriorityType itemType;
  final int questStatus;
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    switch (itemType) {
      case QuestItemPriorityType.Active:
        if (questStatus == -2) {
          return header(
            color: Colors.red,
            title: "quests.disputeQuest",
          );
        } else if (questStatus == 2) {
          return header(
            color: Colors.green,
            title: "quests.employerConfirmationPending",
          );
        } else {
          return header(
            color: AppColor.green,
            title: "quests.active",
          );
        }
      case QuestItemPriorityType.Invited:
        return header(
          color: Color(0xFFE8D20D),
          title: "quests.youInvited",
        );
      case QuestItemPriorityType.Requested:
        return header(
            color: Color(0xFFF7F8FA),
            title: "quests.requested",
            textColor: Color(0xFFAAB0B9));
      case QuestItemPriorityType.Performed:
        if (questStatus == 4) {
          return header(
            color: Color(0xFF0083C7),
            title: "quests.waitConfirm",
          );
        } else {
          return header(
            color: Color(0xFF0083C7),
            title: questStatus == 2
                ? "quests.employerConfirmationPending"
                : "quests.performed",
          );
        }
      case QuestItemPriorityType.Starred:
        return SizedBox(
          height: 16,
        );
    }
  }

  Widget header(
          {required Color color,
          required String title,
          Color textColor = Colors.white}) =>
      Container(
        width: double.maxFinite,
        margin: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 7.5,
        ),
        decoration: BoxDecoration(
          borderRadius: rounded ? BorderRadius.circular(4) : null,
          color: color,
        ),
        child: Text(
          title.tr(),
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
}
