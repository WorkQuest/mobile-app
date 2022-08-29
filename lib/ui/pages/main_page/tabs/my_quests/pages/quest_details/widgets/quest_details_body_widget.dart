import 'package:app/constants.dart';
import 'package:app/di/injector.dart';
import 'package:app/enums.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_details/pages/user_profile_page/user_profile_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/quest_details/pages/map_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/quest_details/widgets/tag_item_widget.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/image_viewer_widget.dart';
import 'package:app/ui/widgets/pay_period_view.dart';
import 'package:app/ui/widgets/priority_view.dart';
import 'package:app/utils/quest_util.dart';
import 'package:app/utils/skill_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class QuestDetailsBodyWidget extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final BaseQuestResponse? quest;
  final Widget inProgressBy;
  final Widget questHeader;
  final Widget bottomBody;
  final Widget review;

  const QuestDetailsBodyWidget({
    Key? key,
    required this.onRefresh,
    required this.quest,
    required this.questHeader,
    required this.inProgressBy,
    required this.bottomBody,
    required this.review,
  }) : super(key: key);

  String get myId => getIt.get<ProfileMeStore>().userData!.id;

  bool get showProgressBy =>
      quest!.assignedWorker != null &&
      (quest!.status == QuestConstants.questCreated || quest!.status == QuestConstants.questDone);

  @override
  Widget build(BuildContext context) {
    return quest == null
        ? Center(
            child: Transform.scale(
              scale: 1.5,
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 2.0,
              ),
            ),
          )
        : RefreshIndicator(
            onRefresh: onRefresh,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                children: [
                  questHeader,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        quest!.userId == myId
                            ? Text("quests.yourQuest".tr())
                            : GestureDetector(
                                onTap: () => _onPressedPushProfileEmployer(context),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        quest!.user!.avatar?.url ?? Constants.defaultImageNetwork,
                                        width: 30,
                                        height: 30,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        "${quest!.user!.firstName} "
                                        "${quest!.user!.lastName}",
                                        style: TextStyle(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        const SizedBox(height: 17),
                        Row(
                          children: [
                            if (quest!.userId != myId)
                              Icon(
                                Icons.location_on_rounded,
                                color: Color(0xFF7C838D),
                              ),
                            const SizedBox(width: 9),
                            Flexible(
                              child: Text(
                                quest!.locationPlaceName,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  color: Color(0xFF7C838D),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 17),
                        TagItemWidget(
                          skills: SkillUtils.parser(quest!.questSpecializations),
                        ),
                        if (showProgressBy) inProgressBy,
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            quest!.title,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D2127),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(quest!.description),
                        const SizedBox(height: 15),
                        if (quest!.medias?.isNotEmpty ?? false) ...[
                          Text(
                            "quests.questMaterials".tr(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF1D2127),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ImageViewerWidget(
                            quest!.medias!,
                            Color(0xFF1D2127),
                            null,
                          ),
                        ],
                        Text(
                          DateFormat('dd MMMM yyyy, kk:mm').format(quest!.createdAt!.toLocal()),
                          style: TextStyle(
                            color: Color(0xFFAAB0B9),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () => _onPressedPushMapPage(context),
                          child: Container(
                            height: 215,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Container(color: Colors.black),
                                    ),
                                    GoogleMap(
                                      mapType: MapType.normal,
                                      tiltGesturesEnabled: false,
                                      rotateGesturesEnabled: false,
                                      zoomControlsEnabled: false,
                                      scrollGesturesEnabled: false,
                                      zoomGesturesEnabled: false,
                                      initialCameraPosition: CameraPosition(
                                        bearing: 0,
                                        target: LatLng(
                                          quest!.locationCode!.latitude,
                                          quest!.locationCode!.longitude,
                                        ),
                                        zoom: 15.0,
                                      ),
                                      myLocationButtonEnabled: false,
                                    ),
                                  ],
                                ),
                                SvgPicture.asset(
                                  "assets/marker.svg",
                                  width: 22,
                                  height: 29,
                                  color: Constants.priorityColors[quest!.priority],
                                ),
                                Container(
                                  color: Colors.transparent,
                                  height: double.maxFinite,
                                  width: double.maxFinite,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                PriorityView(
                                  quest!.priority != 0 ? quest!.priority - 1 : 0,
                                ),
                                const SizedBox(width: 5),
                                PayPeriodView(quest!.payPeriod),
                              ],
                            ),
                            const SizedBox(width: 50),
                            Flexible(
                              child: Text(
                                QuestUtils.getPrice(quest!.price) + "  WUSD",
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
                        bottomBody,
                        review,
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  _onPressedPushProfileEmployer(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushNamed(
      UserProfile.routeName,
      arguments: ProfileArguments(
        role: UserRole.Employer,
        userId: quest!.userId,
      ),
    );
  }

  _onPressedPushMapPage(BuildContext context) {
    Navigator.of(context).pushNamed(
      MapPage.routeName,
      arguments: quest!,
    );
  }
}
