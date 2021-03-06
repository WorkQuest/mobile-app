import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/priority_view.dart';
import 'package:app/ui/widgets/quest_header.dart';
import 'package:app/ui/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../../../enums.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../widgets/shimmer.dart';

const defaultImage =
    'https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs';

class MyQuestsItem extends StatelessWidget {
  final QuestItemPriorityType itemType;
  final BaseQuestResponse questInfo;
  final bool isExpanded;
  final bool showStar;

  const MyQuestsItem(
    this.questInfo, {
    this.isExpanded = false,
    this.showStar = false,
    this.itemType = QuestItemPriorityType.Active,

  });

  @override
  Widget build(BuildContext context) {
    final myQuestStore = GetIt.I.get<MyQuestStore>();
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context, rootNavigator: true).pushNamed(
          QuestDetails.routeName,
          arguments: questInfo,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.only(
          top: 10,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isExpanded)
              QuestHeader(
                itemType,
                questInfo.status,
                true,
                false,
                true,
              ),
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: UserAvatar(
                      width: 30,
                      height: 30,
                      url: questInfo.user.avatar?.url,
                    )),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    questInfo.user.firstName + " " + questInfo.user.lastName,
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (questInfo.responded != null)
                  if (questInfo.responded!.workerId ==
                              context.read<ProfileMeStore>().userData!.id &&
                          (questInfo.status == 0 || questInfo.status == 4) ||
                      questInfo.invited != null &&
                          questInfo.invited?.status == 1)
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
                if (showStar)
                  IconButton(
                    icon: Icon(
                      Icons.star,
                      color: Color(0xFFE8D20D),
                    ),
                    onPressed: () {
                      myQuestStore.deleteQuest(questInfo.id);
                      myQuestStore.addQuest(
                        questInfo,
                        questInfo.star ? true : false,
                      );
                      myQuestStore.setStar(questInfo, false);
                    },
                  ),
                if (questInfo.invited != null && questInfo.invited?.status == 0)
                  Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "quests.youInvited".tr(),
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
                PriorityView(
                  questInfo.priority != 0 ? questInfo.priority - 1 : 0,
                  true,
                ),
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
}

class ShimmerMyQuestItem extends StatelessWidget {
  const ShimmerMyQuestItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.only(
        top: 10,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: const _ShimmerItem(
                  width: 30,
                  height: 30,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              const _ShimmerItem(
                width: 140,
                height: 20,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  const _ShimmerItem(width: 40, height: 20),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 17.5,
          ),
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
                  const _ShimmerItem(width: 60, height: 20),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          const _ShimmerItem(width: 50, height: 20),
          SizedBox(
            height: 10,
          ),
          const _ShimmerItem(width: 250, height: 40),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _ShimmerItem(width: 60, height: 20),
              SizedBox(width: 50),
              const _ShimmerItem(width: 70, height: 20),
            ],
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}

class _ShimmerItem extends StatelessWidget {
  final double width;
  final double height;

  const _ShimmerItem({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.stand(
      child: Container(
        child: SizedBox(
          height: height,
          width: width,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
      ),
    );
  }
}
