import 'package:app/constants.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/store/quests_store.dart';
import 'package:app/ui/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

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
          arguments: workersInfo,
        );
      },
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(
          top: 10,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: FadeInImage.assetNetwork(
                    width: 61,
                    height: 61,
                    fit: BoxFit.cover,
                    image: workersInfo.avatar!.url,
                    placeholder: 'assets/white_back.jpeg',
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        workersInfo.firstName + " " + workersInfo.lastName,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      tagStatus(
                          workersInfo.ratingStatistic?.status.toString() ?? "noStatus"),
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
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 23),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.star,
                          color: AppColor.star,
                        )
                      ],
                    ),
                  )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (workersInfo.userSpecializations.isNotEmpty)
              tagSkills(
                questsStore.parser(workersInfo.userSpecializations),
              ),
            const SizedBox(height: 10),
            Text(
              "workers.aboutMe".tr(),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              workersInfo.additionalInfo?.description ?? "modals.noDescription".tr(),
              style: TextStyle(
                color: Color(0xFFAAB0B9),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            workersInfo.additionalInfo!.address != null
                ? Text(
                    workersInfo.additionalInfo?.address ?? "",
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Color(0xFF7C838D),
                    ),
                  )
                : SizedBox(),
            const SizedBox(
              height: 10,
            ),
            Text(
              "settings.costPerHour".tr(),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "${workersInfo.wagePerHour}  WUSD",
              style: TextStyle(
                color: Color(0xFF00AA5B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.fade,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget tagStatus(String status) {
    WorkerBadge? badge = Constants.workerRatingTag[status];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: badge?.color,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        badge?.title ?? "",
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget tagSkills(List<String> skills) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "workers.specializations".tr(),
        ),
        const SizedBox(
          height: 5,
        ),
        Wrap(
          children: skills
              .map(
                (item) => Text(
                  item == skills.last ? item : item + ",",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color(0xFF0083C7),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class ShimmerWorkersItem extends StatelessWidget {
  const ShimmerWorkersItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(
        top: 10,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.stand(
                child: Container(
                  height: 61,
                  width: 61,
                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Shimmer.stand(
                      child: Container(
                        height: 20,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Shimmer.stand(
                        child: Container(
                          height: 20,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Shimmer.stand(
                      child: Container(
                        height: 20,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.stand(
                child: Container(
                  height: 20,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Wrap(children: [
                Shimmer.stand(
                  child: Container(
                    height: 20,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Shimmer.stand(
                  child: Container(
                    height: 20,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Shimmer.stand(
                  child: Container(
                    height: 20,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.white,
                    ),
                  ),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 15),
          Shimmer.stand(
            child: Container(
              height: 20,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Shimmer.stand(
            child: Container(
              height: 20,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          Shimmer.stand(
            child: Container(
              height: 20,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Shimmer.stand(
            child: Container(
              height: 20,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
