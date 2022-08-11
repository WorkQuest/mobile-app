import 'package:app/constants.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/widgets/pay_period_view.dart';
import 'package:app/ui/widgets/priority_view.dart';
import 'package:app/ui/widgets/quest_header.dart';
import 'package:app/ui/widgets/user_avatar.dart';
import 'package:app/utils/quest_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class MyQuestsItem extends StatefulWidget {
  final BaseQuestResponse questInfo;
  final bool isExpanded;
  final QuestsType itemType;
  final bool showStar;

  const MyQuestsItem({
    required this.questInfo,
    required this.itemType,
    this.isExpanded = false,
    this.showStar = true,
  });

  @override
  State<MyQuestsItem> createState() => _MyQuestsItemState();
}

class _MyQuestsItemState extends State<MyQuestsItem> {
  late final MyQuestStore store;

  @override
  void initState() {
    super.initState();
    store = context.read<MyQuestStore>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.of(context, rootNavigator: true).pushNamed(
          QuestDetails.routeName,
          arguments: QuestArguments(id: widget.questInfo.id),
        );
        if (result != null && result as bool) {
          store.deleteQuestFromList(widget.itemType, widget.questInfo.id);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: QuestUtils.getColorBorder(
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
                responded:
                    widget.questInfo.responded ?? widget.questInfo.questChat?.response,
                role: store.role,
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
                  if (store.isResponded(widget.questInfo))
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        Text("quests.youResponded".tr()),
                      ],
                    ),
                if (store.isInvited(widget.questInfo))
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
                          ? AppColor.gold
                          : Color(0xFFE9EDF2),
                    ),
                    onPressed: () async {
                      await store.setStar(
                        widget.questInfo,
                        !widget.questInfo.star,
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 17.5),
            if (store.isLocation(widget.questInfo))
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFF7C838D),
                      ),
                      const SizedBox(width: 9),
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
                if (store.isRaised(widget.questInfo))
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/arrow_raise_icon.svg',
                        height: 18,
                        width: 18,
                      ),
                      const SizedBox(width: 5),
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
                      widget.questInfo.priority != 0 ? widget.questInfo.priority - 1 : 0,
                    ),
                    const SizedBox(width: 5),
                    PayPeriodView(widget.questInfo.payPeriod),
                  ],
                ),
                Flexible(
                  child: Text(
                    QuestUtils.getPrice(widget.questInfo.price) + "  WUSD",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: AppColor.green,
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
}
