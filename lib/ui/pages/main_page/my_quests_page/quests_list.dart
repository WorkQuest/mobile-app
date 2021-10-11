import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/quest_page/create_quest_page/create_quest_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../enums.dart';
import 'my_quests_item.dart';

class QuestsList extends StatelessWidget {
  final QuestItemPriorityType questItemPriorityType;

  final List<BaseQuestResponse>? questsList;

  final bool hasCreateButton;

  const QuestsList(this.questItemPriorityType, this.questsList,
      {this.hasCreateButton = false});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        color: const Color(0xFFF7F8FA),
        child: questsList == null
            ? getLoadingBody()
            : questsList!.isNotEmpty
                ? getBody()
                : getEmptyBody(context),
      ),
    );
  }

  Widget getBody() {
    return ListView.builder(
      itemCount: hasCreateButton ? questsList!.length + 1 : questsList!.length,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, index) {
        if (hasCreateButton) if (index == 0) {
          return Container(
            margin: EdgeInsets.only(top: 10.0),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed(CreateQuestPage.routeName);
                    },
                    child: Text(
                      "quests.addNewQuest".tr(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return MyQuestsItem(
          questsList![(hasCreateButton) ? index - 1 : index],
          itemType: questItemPriorityType,
        );
      },
    );
  }

  Widget getEmptyBody(BuildContext context) {
    return Center(
      child: Column(
        children: [
          if (hasCreateButton)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .pushNamed(CreateQuestPage.routeName);
                },
                child: Text(
                  "quests.addNewQuest".tr(),
                ),
              ),
            ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/empty_quest_icon.svg",
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  "quests.youDontHaveAny".tr() +
                      " ${questItemPriorityType.toString().split(".").last} " +
                      "quests.questYet".tr(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getLoadingBody() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
