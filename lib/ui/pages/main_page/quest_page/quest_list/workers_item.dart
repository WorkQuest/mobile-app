import 'package:app/constants.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/store/quests_store.dart';
import 'package:app/utils/quest_util.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../widgets/user_avatar.dart';
import '../../../../widgets/user_rating.dart';

class WorkersItem extends StatelessWidget {
  const WorkersItem(this.workersInfo, this.questsStore, {this.showRating = false});

  final ProfileMeResponse workersInfo;
  final QuestsStore questsStore;
  final bool showRating;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context, rootNavigator: true).pushNamed(
          UserProfile.routeName,
          arguments: ProfileArguments(
            role: workersInfo.role,
            userId: workersInfo.id,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: QuestUtils.getColorBorder(
              workersInfo.raiseView?.status,
              workersInfo.raiseView?.type,
            ),
          ),
          color: Colors.white,
        ),
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: UserAvatar(
                    width: 61,
                    height: 61,
                    url: workersInfo.avatar?.url,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        workersInfo.firstName + " " + workersInfo.lastName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          if (workersInfo.raiseView != null &&
                              workersInfo.raiseView!.status != null &&
                              workersInfo.raiseView!.status == 0)
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
                          UserRating(
                            workersInfo.ratingStatistic != null
                                ? workersInfo.ratingStatistic!.status!
                                : 3,
                            isWorker: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (showRating)
                  Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${workersInfo.ratingStatistic?.averageMark.toStringAsFixed(1) ?? 0.0}",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 23,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          Icons.star,
                          color: AppColor.gold,
                        )
                      ],
                    ),
                  )
              ],
            ),
            const SizedBox(height: 10),
            if (workersInfo.userSpecializations.isNotEmpty)
              tagSkills(
                questsStore.parser(workersInfo.userSpecializations),
              ),
            const SizedBox(height: 10),
            Text("workers.aboutMe".tr()),
            const SizedBox(height: 5),
            Text(
              workersInfo.additionalInfo?.description ?? "modals.noDescription".tr(),
              style: TextStyle(
                color: Color(0xFFAAB0B9),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            workersInfo.locationPlaceName != null
                ? Text(
                    workersInfo.locationPlaceName ?? "",
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Color(0xFF7C838D),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 10),
            Text("settings.costPerHour".tr()),
            const SizedBox(height: 5),
            Text(
              "${workersInfo.costPerHour}  WUSD",
              style: TextStyle(
                color: Color(0xFF00AA5B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.fade,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget tagSkills(List<String> skills) {
    String skillsLine = '';
    skills.map((e) => skillsLine += e == skills.last ? e.tr() : '${e.tr()}, ').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("workers.specializations".tr()),
        const SizedBox(height: 5),
        Text(
          skillsLine.tr(),
          style: const TextStyle(
            fontSize: 16.0,
            color: Color(0xFF0083C7),
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        )
      ],
    );
  }
}
