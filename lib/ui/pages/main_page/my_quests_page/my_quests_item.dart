import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/quest_details_page/quest_details_page.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/store/quests_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/priority_view.dart';
import 'package:app/ui/widgets/running_line.dart';
import 'package:app/work_quest_app.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import '../../../../constants.dart';
import '../../../../enums.dart';
import 'package:easy_localization/easy_localization.dart';

class MyQuestsItem extends StatelessWidget {
  const MyQuestsItem(this.questInfo,
      {this.itemType = QuestItemPriorityType.Active, this.isExpanded = false});

  final BaseQuestResponse questInfo;
  final bool isExpanded;
  final QuestItemPriorityType itemType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // final myQuestStore = context.read<MyQuestStore>();
        final questStore = context.read<QuestsStore>();
        // final profile = context.read<ProfileMeStore>();
        await Navigator.of(context, rootNavigator: true).pushNamed(
          QuestDetails.routeName,
          arguments: questInfo,
        );
        // myQuestStore.getQuests(
        //     profile.userData!.id, profile.userData!.role, true);
        questStore.getQuests(true);
      },
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(
          top: 10,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isExpanded) getQuestHeader(itemType, context),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    questInfo.user.avatar.url,
                    width: 30,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: SizedBox(
                    height: 20,
                    child: RunningLine(
                      children: [
                        Text(
                          questInfo.user.firstName +
                              " " +
                              questInfo.user.lastName,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                if (questInfo.responded != null)
                  if (questInfo.responded!.workerId ==
                          context.read<ProfileMeStore>().userData!.id &&
                      (questInfo.status == 0 || questInfo.status == 4))
                    Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "quests.youResponded".tr(),
                        ),
                      ],
                    ),
              ],
            ),
            const SizedBox(
              height: 17.5,
            ),
            if (questInfo.userId !=
                    context.read<ProfileMeStore>().userData!.id &&
                questInfo.status != 5 &&
                questInfo.status != 6)
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFF7C838D),
                      ),
                      SizedBox(
                        width: 9,
                      ),
                      Flexible(
                        child: Text(
                          questInfo.locationPlaceName,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: Color(0xFF7C838D),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            Text(
              questInfo.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF1D2127),
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              questInfo.description,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF4C5767),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PriorityView(questInfo.priority),
                SizedBox(width: 50),
                Flexible(
                  child: Text(
                    questInfo.price + "  WUSD",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Color(0xFF00AA5B),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
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
          horizontal: 14,
          vertical: 7.5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: color,
        ),
        child: Text(
          title.tr(),
          style: TextStyle(color: textColor),
        ),
      );

  Widget getQuestHeader(QuestItemPriorityType itemType, BuildContext context) {
    switch (itemType) {
      case QuestItemPriorityType.Active:
        if (questInfo.status == 3) {
          return header(
            color: Colors.red,
            title: "quests.disputeQuest",
          );
        } else if (questInfo.status == 5) {
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
        if (questInfo.status == 5) {
          return header(
            color: Color(0xFF0083C7),
            title: "quests.waitConfirm",
          );
        } else {
          return header(
            color: Color(0xFF0083C7),
            title: questInfo.status == 5
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
}
