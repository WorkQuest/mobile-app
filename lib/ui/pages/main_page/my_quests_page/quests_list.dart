import 'package:app/model/quests_models/base_quest_response.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobx/mobx.dart';

import '../../../../enums.dart';
import 'my_quests_item.dart';

enum FromQuestList { questSearch, myQuest }

class QuestsList extends StatelessWidget {
  ObservableList<BaseQuestResponse> questsList = ObservableList.of([]);
  final QuestsType questItemPriorityType;
  final Future<dynamic>? update;
  final ScrollPhysics physics;
  final FromQuestList from;
  final bool isLoading;
  final bool short;
  final UserRole role;

  QuestsList(
    this.questItemPriorityType,
    this.questsList, {
    this.update,
    this.physics = const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
    required this.isLoading,
    required this.from,
    this.short = false,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => questsList.isEmpty
          ? Center(
              child: isLoading ? getLoadingBody() : getEmptyBody(context),
            )
          : getBody(),
    );
  }

  Widget getBody() {
    return ListView.builder(
      physics: physics,
      shrinkWrap: true,
      key: new PageStorageKey<QuestsType>(questItemPriorityType),
      itemCount: questsList.length,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, index) {
        return Column(
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Color(0xFFF7F8FA),
              ),
            ),
            MyQuestsItem(
              questInfo: questsList[index],
              myRole: role,
              itemType: questItemPriorityType,
              showStar: from == FromQuestList.myQuest,
            ),
            if (short && index == 2)
              Column(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F8FA),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget getEmptyBody(BuildContext context) {
    return SingleChildScrollView(
      physics: physics,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/empty_quest_icon.svg"),
          const SizedBox(height: 10.0),
          Text(
            "quests.youDontHaveAny".tr() +
                " ${questItemPriorityType.name} " +
                "quests.questYet".tr(),
            style: TextStyle(
              color: Color(0xFFD8DFE3),
            ),
          ),
        ],
      ),
    );
  }

  Widget getLoadingBody() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 6,
          child: Container(
            color: Color(0xFFF7F8FA),
          ),
        );
      },
      padding: EdgeInsets.zero,
      itemCount: 8,
      itemBuilder: (_, index) {
        return const ShimmerMyQuestItem();
      },
    );
  }
}
