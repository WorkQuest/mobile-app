import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/quest_details_page/quest_details_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/priority_view.dart';
import 'package:app/work_quest_app.dart';
import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import '../../../../enums.dart';
import 'package:easy_localization/easy_localization.dart';

class MyQuestsItem extends StatelessWidget {
  const MyQuestsItem(
    this.questInfo, {
    this.itemType = QuestItemPriorityType.Active,
    this.isExpanded = false,
  });

  final BaseQuestResponse questInfo;
  final bool isExpanded;
  final QuestItemPriorityType itemType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        int oldStatus = questInfo.status;
        bool oldStar = questInfo.star;
        await Navigator.of(context, rootNavigator: true).pushNamed(
          QuestDetails.routeName,
          arguments: questInfo,
        );

        //TODO:Check and correct
        if (oldStar != questInfo.star) {
          if (questInfo.star == false) {
            context.read<MyQuestStore>().starred!.remove(questInfo);
            if (context
                .read<MyQuestStore>()
                .active!
                .where((element) => element.id == questInfo.id)
                .isNotEmpty) {
              context.read<MyQuestStore>().active!.remove(questInfo);
              context.read<MyQuestStore>().active!.add(questInfo);
            }
            if (context
                .read<MyQuestStore>()
                .invited!
                .where((element) => element.id == questInfo.id)
                .isNotEmpty) {
              context.read<MyQuestStore>().invited!.remove(questInfo);
              context.read<MyQuestStore>().invited!.add(questInfo);
            }
            if (context
                .read<MyQuestStore>()
                .performed!
                .where((element) => element.id == questInfo.id)
                .isNotEmpty) {
              context.read<MyQuestStore>().performed!.remove(questInfo);
              context.read<MyQuestStore>().performed!.add(questInfo);
            }
          } else {
            context.read<MyQuestStore>().starred!.add(questInfo);
            if (context
                .read<MyQuestStore>()
                .active!
                .where((element) => element.id == questInfo.id)
                .isNotEmpty) {
              context.read<MyQuestStore>().active!.remove(questInfo);
              context.read<MyQuestStore>().active!.add(questInfo);
            }
            if (context
                .read<MyQuestStore>()
                .invited!
                .where((element) => element.id == questInfo.id)
                .isNotEmpty) {
              context.read<MyQuestStore>().invited!.remove(questInfo);
              context.read<MyQuestStore>().invited!.add(questInfo);
            }
            if (context
                .read<MyQuestStore>()
                .performed!
                .where((element) => element.id == questInfo.id)
                .isNotEmpty) {
              context.read<MyQuestStore>().performed!.remove(questInfo);
              context.read<MyQuestStore>().performed!.add(questInfo);
            }
          }
        }

        //TODO:Check and correct
        if (oldStatus != questInfo.status) {
          switch (oldStatus) {
            case 0:
              context.read<MyQuestStore>().active!.remove(questInfo);
              break;
            case 1:
              if (questInfo.status != 3)
                context.read<MyQuestStore>().active!.remove(questInfo);
              break;
            case 3:
              context.read<MyQuestStore>().active!.remove(questInfo);
              break;
            case 4:
              context.read<MyQuestStore>().invited!.remove(questInfo);
              context.read<MyQuestStore>().requested!.remove(questInfo);
              break;
            case 5:
              context.read<MyQuestStore>().active!.remove(questInfo);
              break;
            case 6:
              context.read<MyQuestStore>().performed!.remove(questInfo);
              break;
          }
          switch (questInfo.status) {
            case 0:
              context.read<MyQuestStore>().active!.add(questInfo);
              break;
            case 1:
              context.read<MyQuestStore>().active!.add(questInfo);
              break;
            case 2:
              context.read<MyQuestStore>().active!.remove(questInfo);
              break;
            case 3:
              context.read<MyQuestStore>().active!.add(questInfo);
              break;
            case 4:
              context.read<MyQuestStore>().invited!.add(questInfo);
              context.read<MyQuestStore>().requested!.add(questInfo);
              break;
            case 5:
              context.read<MyQuestStore>().active!.add(questInfo);
              break;
            case 6:
              context.read<MyQuestStore>().performed!.add(questInfo);
              break;
          }
        }
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
                Text(
                  questInfo.user.firstName + " " + questInfo.user.lastName,
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
            SizedBox(
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
                      Text(
                        "150 from you",
                        style: TextStyle(
                          color: Color(0xFF7C838D),
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

  Widget getQuestHeader(QuestItemPriorityType itemType, BuildContext context) {
    Widget returnWidget = Container();
    switch (itemType) {
      case QuestItemPriorityType.Active:
        if (questInfo.status == 3) {
          returnWidget = Container(
            margin: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 7.5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.red,
            ),
            child: Row(
              children: [
                Text(
                  "quests.disputeQuest".tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        } else if (questInfo.status == 5) {
          returnWidget = Container(
            margin: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 7.5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.green,
            ),
            child: Row(
              children: [
                Text(
                  "quests.employerConfirmationPending".tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        } else {
          returnWidget = Container(
            margin: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 7.5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColors.green,
            ),
            child: Row(
              children: [
                Text(
                  "quests.active".tr(),
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                Text(
                  "quests.runtime".tr(),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "14:10:23",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        }
        break;
      case QuestItemPriorityType.Invited:
        returnWidget = Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7.5,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: Color(0xFFE8D20D)),
          child: Row(
            children: [
              Text(
                "quests.youInvited".tr(),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
        break;
      case QuestItemPriorityType.Requested:
        returnWidget = Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7.5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Color(0xFFF7F8FA),
          ),
          child: Row(
            children: [
              Text(
                "quests.requested".tr(),
                style: TextStyle(
                  color: Color(0xFFAAB0B9),
                ),
              ),
            ],
          ),
        );
        break;
      case QuestItemPriorityType.Performed:
        if (questInfo.status == 5) {
          returnWidget = Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 7.5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(0xFF0083C7),
            ),
            child: Row(
              children: [
                Text(
                  "quests.waitConfirm".tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        } else {
          returnWidget = Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 7.5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(0xFF0083C7),
            ),
            child: Row(
              children: [
                questInfo.status == 5
                    ? Text(
                        "quests.employerConfirmationPending".tr(),
                      )
                    : Text(
                        "quests.performed".tr(),
                        style: TextStyle(color: Colors.white),
                      ),
              ],
            ),
          );
        }
        break;
      case QuestItemPriorityType.Starred:
        returnWidget = SizedBox(
          height: 16,
        );
        break;
    }
    return returnWidget;
  }
}
