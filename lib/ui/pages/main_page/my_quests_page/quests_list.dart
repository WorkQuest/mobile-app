import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/quest_page/create_quest_page/create_quest_page.dart';
import 'package:app/ui/widgets/platform_activity_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mobx/mobx.dart';

import '../../../../enums.dart';
import 'my_quests_item.dart';

class QuestsList extends StatelessWidget {
  final QuestItemPriorityType questItemPriorityType;

  final Function(bool)? onCreate;

  ObservableList<BaseQuestResponse> questsList = ObservableList.of([]);

  final Future<dynamic>? update;

  final ScrollPhysics physics;

  final bool isLoading;

  QuestsList(this.questItemPriorityType, this.questsList,
      {this.onCreate,
      this.update,
      this.physics = const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Container(
        color: const Color(0xFFF7F8FA),
        child: questsList.isEmpty
            ? isLoading
                ? getLoadingBody()
                : getEmptyBody(context)
            : getBody(),
      ),
    );
  }

  Widget getBody() {
    return Align(
      alignment: Alignment.topCenter,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: onCreate != null ? questsList.length + 1 : questsList.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, index) {
          if (onCreate != null) if (index == 0) {
            return Container(
              margin: EdgeInsets.only(top: 10.0),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        bool? status =
                            await Navigator.of(context, rootNavigator: true)
                                .pushNamed<bool>(CreateQuestPage.routeName);
                        onCreate!(status ?? false);
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
            questsList[(onCreate != null) ? index - 1 : index],
            itemType: questItemPriorityType,
          );
        },
      ),
    );
  }

  Widget getEmptyBody(BuildContext context) {
    return Column(
      children: [
        if (onCreate != null)
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
          child: Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
        ),
      ],
    );
  }

  Widget getLoadingBody() {
    return Center(
      child: PlatformActivityIndicator(),
    );
  }
}
