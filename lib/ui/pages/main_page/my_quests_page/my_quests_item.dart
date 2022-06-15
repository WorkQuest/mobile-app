import 'dart:math';

import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/priority_view.dart';
import 'package:app/ui/widgets/quest_header.dart';
import 'package:app/ui/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import "package:provider/provider.dart";
import '../../../../enums.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../widgets/shimmer.dart';

class MyQuestsItem extends StatelessWidget {
  final BaseQuestResponse questInfo;
  final bool isExpanded;
  final QuestItemPriorityType itemType;
  final bool showStar;
  final String defaultImage =
      'https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs';

  const MyQuestsItem(
    this.questInfo, {
    this.itemType = QuestItemPriorityType.Active,
    this.isExpanded = false,
    this.showStar = false,
  });

  @override
  Widget build(BuildContext context) {
    final myQuestStore = GetIt.I.get<MyQuestStore>();
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context, rootNavigator: true).pushNamed(
          QuestDetails.routeName,
          arguments: QuestArguments(questInfo: questInfo, id: null),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: questInfo.raiseView != null
                ? _getColorBorder(
                    questInfo.raiseView!.status,
                    questInfo.raiseView!.type,
                  )
                : Colors.transparent,
          ),
          color: Colors.white,
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
                itemType: itemType,
                questStatus: questInfo.status,
                rounded: true,
                responded: false,
                forMe: true,
              ),
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: UserAvatar(
                      width: 30,
                      height: 30,
                      url: questInfo.user!.avatar?.url,
                    )),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Text(
                    questInfo.user!.firstName + " " + questInfo.user!.lastName,
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (questInfo.responded != null)
                  if (questInfo.responded!.workerId == context.read<ProfileMeStore>().userData!.id &&
                          (questInfo.status == 1 || questInfo.status == 2) ||
                      questInfo.invited != null && questInfo.invited?.status == 1)
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
            if (questInfo.userId != context.read<ProfileMeStore>().userData!.id &&
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
            Row(
              children: [
                if (questInfo.raiseView != null &&
                    questInfo.raiseView!.status != null &&
                    questInfo.raiseView!.status == 0)
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/arrow_raise_icon.svg',
                        height: 18,
                        width: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                Expanded(
                  child: Text(
                    questInfo.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF1D2127),
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
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
                    _getPrice(questInfo.price) + "  WUSD",
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

  Color _getColorBorder(int? status, int? type) {
    if (status != null && status == 0) {
      switch (type) {
        case 0:
          return Color(0xFFF6CF00);
        case 1:
          return Color(0xFFF6CF00);
        case 2:
          return Color(0xFFBBC0C7);
        case 3:
          return Color(0xFFB79768);
        default:
          return Colors.transparent;
      }
    } else {
      return Colors.transparent;
    }
  }

  _getPrice(String value) {
    try {
      return (BigInt.parse(value).toDouble() * pow(10, -18)).toStringAsFixed(2);
    } catch (e) {
      return '0.00';
    }
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

  String _getPrice(String value) {
    try {
      return (BigInt.parse(value).toDouble() * pow(10, -18)).toStringAsFixed(2);
    } catch (e) {
      return '0.00';
    }
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
