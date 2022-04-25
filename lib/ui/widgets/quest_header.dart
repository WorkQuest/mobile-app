import 'package:app/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../enums.dart';

class QuestHeader extends StatelessWidget {
  const QuestHeader(
    this.itemType,
    this.questStatus,
    this.rounded,
    this.responded,
    this.forMe,
  );

  final QuestItemPriorityType itemType;
  final int questStatus;
  final bool rounded;
  final bool responded;
  final bool forMe;

  @override
  Widget build(BuildContext context) {
    switch (itemType) {
      case QuestItemPriorityType.Active:
        if (questStatus == 3) {
          return header(
            color: Colors.red,
            title: "quests.disputeQuest",
          );
        } else if (questStatus == 5) {
          return header(
            color: Colors.green,
            title: "quests.employerConfirmationPending",
          );
        } else if (responded && questStatus == 0) {
          return header(
            color: Color(0xFF0083C7),
            title: "quests.responded",
          );
        } else if (responded && !forMe) {
          return header(
            color: Colors.red,
            title: "quests.responded",
          );
        } else if (questStatus == 0) {
          return SizedBox(
            height: 16,
          );
        } else {
          return header(
            color: AppColor.green,
            title: "quests.active",
          );
        }
      case QuestItemPriorityType.Invited:
        if (forMe)
          return header(
            color: Color(0xFFE8D20D),
            title: "quests.youInvited",
          );
        else if (responded)
          return header(
            color: Colors.red,
            title: "quests.responded",
          );
        else
          return header(
            color: Color(0xFFE8D20D),
            title: "quests.employeeAwaited",
          );

      case QuestItemPriorityType.Requested:
        return header(
            color: Color(0xFFF7F8FA),
            title: "quests.requested",
            textColor: Color(0xFFAAB0B9));
      case QuestItemPriorityType.Performed:
        if (!forMe && responded)
          return header(
            color: Colors.red,
            title: "quests.responded",
          );
        else if (questStatus == 5) {
          return header(
            color: Color(0xFF0083C7),
            title: "quests.waitConfirm",
          );
        } else {
          return header(
            color: Color(0xFF0083C7),
            title: questStatus == 5
                ? "quests.employerConfirmationPending"
                : "quests.performed",
          );
        }
      default:
        return SizedBox(
          height: 16,
        );
      // case QuestItemPriorityType.Starred:
      //   return SizedBox(
      //     height: 16,
      //   );
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
