import 'dart:math';

import 'package:app/constants.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/pay_period_view.dart';
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

class MyQuestsItem extends StatefulWidget {
  final BaseQuestResponse questInfo;
  final bool isExpanded;
  final QuestsType itemType;
  final bool showStar;
  final UserRole? myRole;

  const MyQuestsItem({
    required this.questInfo,
    required this.itemType,
    this.myRole,
    this.isExpanded = false,
    this.showStar = true,
  });

  @override
  State<MyQuestsItem> createState() => _MyQuestsItemState();
}

class _MyQuestsItemState extends State<MyQuestsItem> {
  @override
  Widget build(BuildContext context) {
    final myQuestStore = GetIt.I.get<MyQuestStore>();
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context, rootNavigator: true).pushNamed(
          QuestDetails.routeName,
          arguments: QuestArguments(questInfo: widget.questInfo, id: null),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: _getColorBorder(
              widget.questInfo.raiseView?.status,
              widget.questInfo.raiseView?.type,
            ),
          ),
          color: Colors.white,
        ),
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.isExpanded)
              QuestHeader(
                itemType: widget.itemType,
                questStatus: widget.questInfo.status,
                rounded: true,
                responded: widget.questInfo.responded ??
                    widget.questInfo.questChat?.response,
                invited: widget.questInfo.invited,
                role: widget.myRole,
              ),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: UserAvatar(
                    width: 30,
                    height: 30,
                    url: widget.questInfo.user?.avatar?.url ??
                        Constants.defaultImageNetwork,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    widget.questInfo.user!.firstName +
                        " " +
                        widget.questInfo.user!.lastName,
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.questInfo.responded != null)
                  if ((widget.questInfo.responded!.workerId ==
                                  context.read<ProfileMeStore>().userData!.id &&
                              (widget.questInfo.status == 1 ||
                                  widget.questInfo.status == 2) ||
                          widget.questInfo.invited != null &&
                              widget.questInfo.invited?.status == 1) &&
                      context.read<ProfileMeStore>().userData!.role ==
                          UserRole.Worker)
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        Text("quests.youResponded".tr()),
                      ],
                    ),
                if (widget.questInfo.invited != null &&
                    widget.questInfo.invited?.status == 0)
                  Row(
                    children: [
                      const SizedBox(width: 5),
                      Text("quests.youInvited".tr()),
                    ],
                  ),
                if (widget.showStar)
                  IconButton(
                    icon: Icon(
                      Icons.star,
                      color: widget.questInfo.star
                          ? Color(0xFFE8D20D)
                          : Color(0xFFE9EDF2),
                    ),
                    onPressed: () async {
                      await myQuestStore.setStar(
                        widget.questInfo,
                        !widget.questInfo.star,
                      );
                      setState(() {});
                    },
                  ),
              ],
            ),
            const SizedBox(height: 17.5),
            if (widget.questInfo.userId !=
                    context.read<ProfileMeStore>().userData!.id &&
                widget.questInfo.status != 5 &&
                widget.questInfo.status != 6)
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
                          widget.questInfo.locationPlaceName,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: Color(0xFF7C838D),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            Row(
              children: [
                if (widget.questInfo.raiseView != null &&
                    widget.questInfo.raiseView!.status != null &&
                    widget.questInfo.raiseView!.status == 0)
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
                    widget.questInfo.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFF1D2127),
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.questInfo.description,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF4C5767),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    PriorityView(
                      widget.questInfo.priority != 0
                          ? widget.questInfo.priority - 1
                          : 0,
                    ),
                    const SizedBox(width: 5),
                    PayPeriodView(widget.questInfo.payPeriod),
                  ],
                ),
                Flexible(
                  child: Text(
                    _getPrice(widget.questInfo.price) + "  WUSD",
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
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Color _getColorBorder(int? status, int? type) {
    if (status != null && status != 0) {
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
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: const _ShimmerItem(
                  width: 30,
                  height: 30,
                ),
              ),
              const SizedBox(width: 5),
              const _ShimmerItem(
                width: 140,
                height: 20,
              ),
              Row(
                children: [
                  const SizedBox(width: 5),
                  const _ShimmerItem(width: 40, height: 20),
                ],
              ),
            ],
          ),
          const SizedBox(height: 17.5),
          Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFF7C838D),
                  ),
                  const SizedBox(width: 9),
                  const _ShimmerItem(width: 60, height: 20),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
          const _ShimmerItem(width: 50, height: 20),
          const SizedBox(height: 10),
          const _ShimmerItem(width: 250, height: 40),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _ShimmerItem(width: 60, height: 20),
              SizedBox(width: 50),
              const _ShimmerItem(width: 70, height: 20),
            ],
          ),
          const SizedBox(height: 15),
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
