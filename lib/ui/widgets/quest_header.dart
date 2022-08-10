import 'package:app/constants.dart';
import 'package:app/model/quests_models/invited.dart';
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
    required this.invited,
    required this.role,
  });

  final QuestsType itemType;
  final int questStatus;
  final bool rounded;
  final Responded? responded;
  final Invited? invited;
  final UserRole? role;

  @override
  Widget build(BuildContext context) {
    if (itemType == QuestsType.All || itemType == QuestsType.Favorites) {
      switch (questStatus) {
        case QuestConstants.questClosed:
          return header(
            color: Colors.red,
            title: "quests.headers.closed",
          );
        case QuestConstants.questDispute:
          return header(
            color: Colors.red,
            title: "quests.disputeQuest",
          );
        case QuestConstants.questRejected:
          return header(
            color: Colors.red,
            title: "quests.headers.blocked",
          );
        case QuestConstants.questCreated:
          if (invited != null && invited!.status != -1 && role == UserRole.Worker)
            return header(
              color: Color(0xFFE8D20D),
              title: "quests.headers.pending",
            );
          else if ((responded?.status == QuestConstants.questResponseRejected || invited?.status == -1) &&
              role == UserRole.Worker)
            return header(
              color: Colors.red,
              title: "quests.headers.rejected",
            );
          else if (responded?.status == QuestConstants.questResponseOpen && role == UserRole.Worker)
            return header(
              color: Color(0xFFE9EFF5),
              title: "quests.headers.responded",
              textColor: Color(0xFF4C5767),
            );
          else
            return SizedBox(
              height: 16,
            );
        case QuestConstants.questWaitWorkerOnAssign:
          if ((responded?.status == QuestConstants.questResponseRejected || invited?.status == -1) &&
              role == UserRole.Worker)
            return header(
              color: Colors.red,
              title: "quests.headers.rejected",
            );
          else if (role == UserRole.Worker)
            return header(
              color: Color(0xFFE8D20D),
              title: "quests.headers.invited",
            );
          else
            return SizedBox(
              height: 16,
            );
        case QuestConstants.questWaitWorker:
          if ((responded?.status == QuestConstants.questResponseRejected || invited?.status == -1) &&
              role == UserRole.Worker)
            return header(
              color: Colors.red,
              title: "quests.headers.rejected",
            );
          else
            return header(
              color: AppColor.green,
              title: "quests.headers.active",
            );
        case QuestConstants.questWaitEmployerConfirm:
          if ((responded?.status == QuestConstants.questResponseRejected || invited?.status == -1) &&
              role == UserRole.Worker)
            return header(
              color: Colors.red,
              title: "quests.headers.rejected",
            );
          else
            return header(
              color: Colors.green,
              title: "quests.headers.pendingConsideration",
            );
        case QuestConstants.questDone:
          if ((responded?.status == QuestConstants.questResponseRejected || invited?.status == -1) &&
              role == UserRole.Worker)
            return header(
              color: Colors.red,
              title: "quests.headers.rejected",
            );
          else
            return header(
              color: Color(0xFF0083C7),
              title: "quests.performed",
            );
        default:
          return SizedBox(
            height: 16,
          );
      }
    } else {
      switch (itemType) {
        case QuestsType.Responded:
          if ((responded?.status == QuestConstants.questResponseRejected || invited?.status == -1) &&
              role == UserRole.Worker)
            return header(
              color: Colors.red,
              title: "quests.headers.rejected",
            );
          else if (questStatus == 1 && role == UserRole.Worker)
            return header(
              color: Color(0xFFE9EFF5),
              title: "quests.headers.responded",
              textColor: Color(0xFF4C5767),
            );
          else if (questStatus == 2 && role == UserRole.Worker)
            return header(
              color: Color(0xFFE8D20D),
              title: "quests.headers.invited",
            );
          else if (role == UserRole.Worker)
            return header(
              color: Colors.red,
              title: "quests.headers.rejected",
            );
          return SizedBox(
            height: 16,
          );
        case QuestsType.Invited:
          return header(
            color: Color(0xFFE8D20D),
            title: "quests.headers.pending",
          );
        case QuestsType.Active:
          if (questStatus == -2)
            return header(
              color: Colors.red,
              title: "quests.headers.dispute",
            );
          else if (questStatus == 4)
            return header(
              color: Colors.green,
              title: "quests.headers.pendingConsideration",
            );
          else if (questStatus == 3)
            return header(
              color: AppColor.green,
              title: "quests.headers.active",
            );
          else
            return header(
              color: Color(0xFFE9EFF5),
              title: "quests.headers.blocked",
              textColor: Color(0xFF4C5767),
            );
        case QuestsType.Performed:
          return header(
            color: Color(0xFF0083C7),
            title: "quests.headers.performed",
          );
        case QuestsType.Created:
          if (questStatus == -3)
            return header(
              color: Color(0xFFE9EFF5),
              title: "quests.headers.blocked",
              textColor: Color(0xFF4C5767),
            );
          else
            return SizedBox(
              height: 16,
            );
        case QuestsType.Completed:
          return header(
            color: Color(0xFF0083C7),
            title: "quests.headers.completed",
          );
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
