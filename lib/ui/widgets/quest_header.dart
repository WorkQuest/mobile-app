import 'package:app/constants.dart';
import 'package:app/model/quests_models/responded.dart';
import 'package:app/utils/quest_util.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../enums.dart';

class QuestHeader extends StatelessWidget {
  const QuestHeader({
    required this.itemType,
    required this.questStatus,
    required this.rounded,
    required this.responded,
    required this.role,
  });

  final QuestsType itemType;
  final int questStatus;
  final bool rounded;
  final Responded? responded;
  final UserRole? role;

  Widget get headerQuestClosed =>
      header(color: Colors.red, title: "quests.headers.closed");

  Widget get headerQuestDispute =>
      header(color: Colors.red, title: "quests.disputeQuest");

  Widget get headerQuestRejected =>
      header(color: Colors.red, title: "quests.headers.blocked");

  Widget get headerQuestResponded => header(
        color: Color(0xFFE9EFF5),
        title: "quests.headers.responded",
        textColor: Color(0xFF4C5767),
      );

  Widget get headerQuestPending =>
      header(color: Color(0xFFE8D20D), title: "quests.headers.pending");

  Widget get headerQuestInvited =>
      header(color: Color(0xFFE8D20D), title: "quests.headers.invited");

  Widget get headerQuestActive =>
      header(color: AppColor.green, title: "quests.headers.active");

  Widget get headerQuestPerformed =>
      header(color: Color(0xFF0083C7), title: "quests.headers.performed");

  Widget get headerQuestCompleted =>
      header(color: Color(0xFF0083C7), title: "quests.headers.completed");

  Widget get headerQuestPendingConsideration =>
      header(color: Colors.green, title: "quests.headers.pendingConsideration");

  Widget get headerQuestResponseRejected =>
      header(color: Colors.red, title: "quests.headers.rejected");

  @override
  Widget build(BuildContext context) {
    if (itemType == QuestsType.All || itemType == QuestsType.Favorites) {
      switch (questStatus) {
        case QuestConstants.questClosed:
          return headerQuestClosed;
        case QuestConstants.questDispute:
          return headerQuestDispute;
        case QuestConstants.questRejected:
          return headerQuestRejected;
        case QuestConstants.questCreated:
          if (responded?.status == QuestConstants.questResponseOpen &&
              responded?.type == QuestConstants.questResponseTypeResponded &&
              role == UserRole.Worker) {
            return headerQuestResponded;
          }
          if ((responded?.status == QuestConstants.questResponseOpen ||
                  responded?.status == QuestConstants.questResponseAccepted) &&
              role == UserRole.Worker)
            return headerQuestPending;
          else if ((responded?.status == QuestConstants.questResponseRejected) &&
              role == UserRole.Worker)
            return headerQuestResponseRejected;
          else if (responded?.status == QuestConstants.questResponseTypeResponded &&
              role == UserRole.Worker)
            return headerQuestResponded;
          else
            return SizedBox(
              height: 16,
            );
        case QuestConstants.questWaitWorkerOnAssign:
          if ((responded?.status == QuestConstants.questResponseRejected) &&
              role == UserRole.Worker)
            return headerQuestResponseRejected;
          else if (role == UserRole.Worker)
            return headerQuestInvited;
          else
            return SizedBox(
              height: 16,
            );
        case QuestConstants.questWaitWorker:
          if ((responded?.status == QuestConstants.questResponseRejected) &&
              role == UserRole.Worker)
            return headerQuestResponseRejected;
          else
            return headerQuestActive;
        case QuestConstants.questWaitEmployerConfirm:
          if ((responded?.status == QuestConstants.questResponseRejected) &&
              role == UserRole.Worker)
            return headerQuestResponseRejected;
          else
            return headerQuestPendingConsideration;
        case QuestConstants.questDone:
          if ((responded?.status == QuestConstants.questResponseRejected) &&
              role == UserRole.Worker)
            return headerQuestResponseRejected;
          else if (role == UserRole.Worker)
            return headerQuestPerformed;
          else
            return headerQuestCompleted;
        default:
          return SizedBox(
            height: 16,
          );
      }
    } else {
      switch (itemType) {
        case QuestsType.Responded:
          if ((responded?.status == QuestConstants.questResponseRejected) &&
              role == UserRole.Worker)
            return headerQuestResponseRejected;
          else if (questStatus == 1 && role == UserRole.Worker)
            return headerQuestResponded;
          else if (questStatus == 2 && role == UserRole.Worker)
            return headerQuestInvited;
          else if (role == UserRole.Worker) return headerQuestResponseRejected;
          return SizedBox(
            height: 16,
          );
        case QuestsType.Invited:
          return headerQuestPending;
        case QuestsType.Active:
          if (questStatus == QuestConstants.questDispute)
            return headerQuestDispute;
          else if (questStatus == QuestConstants.questWaitEmployerConfirm)
            return headerQuestPendingConsideration;
          else if (questStatus == QuestConstants.questWaitWorker)
            return headerQuestActive;
          else
            return headerQuestRejected;
        case QuestsType.Performed:
          return headerQuestPerformed;
        case QuestsType.Created:
          if (questStatus == QuestConstants.questClosed)
            return headerQuestRejected;
          else
            return SizedBox(
              height: 16,
            );
        case QuestsType.Completed:
          return headerQuestCompleted;
        default:
          return SizedBox(
            height: 16,
          );
      }
    }
  }

  Widget header({
    required Color color,
    required String title,
    Color textColor = Colors.white,
  }) =>
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
