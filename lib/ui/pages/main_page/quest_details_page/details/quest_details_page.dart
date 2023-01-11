import 'package:app/constants.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/create_review_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/store/quest_details_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/image_viewer_widget.dart';
import 'package:app/ui/widgets/workplace_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:provider/provider.dart";
import 'package:maps_launcher/maps_launcher.dart';

import '../../../../widgets/priority_view.dart';

class QuestDetails extends StatefulWidget {
  static const String routeName = "/QuestDetails";

  const QuestDetails(this.questInfo);

  final BaseQuestResponse questInfo;

  @override
  QuestDetailsState createState() => QuestDetailsState();
}

class QuestDetailsState<T extends QuestDetails> extends State<T>
    with TickerProviderStateMixin {
  ProfileMeStore? profile;
  late QuestDetailsStore storeQuest;

  bool isLoading = false;

  @protected
  List<Widget>? actionAppBar() {
    return null;
  }

  @override
  void initState() {
    storeQuest = context.read<QuestDetailsStore>();
    storeQuest.initQuest(widget.questInfo);
    profile = context.read<ProfileMeStore>();
    storeQuest.questInfo!.yourReview != null
        ? profile!.review = true
        : profile!.review = false;
    super.initState();
  }

  @protected
  Widget getBody() {
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: actionAppBar(),
      ),
      body: Stack(
        children: [
          _getBody(),
          if (isLoading)
            Center(
              child: Transform.scale(
                scale: 1.5,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2.0,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _getBody() {
    return Observer(
      builder: (_) => RefreshIndicator(
        onRefresh: () => storeQuest.updateQuest(),
        child: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: AbsorbPointer(
            absorbing: isLoading,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Observer(
                builder: (_) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    storeQuest.questInfo!.userId == profile!.userData!.id
                        ? Text(
                            "quests.yourQuest".tr(),
                          )
                        : GestureDetector(
                            onTap: () async {
                              setState(() {
                                this.isLoading = true;
                              });
                              await profile!
                                  .getQuestHolder(storeQuest.questInfo!.userId)
                                  .then(
                                    (value) => Navigator.of(context,
                                            rootNavigator: true)
                                        .pushNamed(
                                      UserProfile.routeName,
                                      arguments: profile!.questHolder,
                                    ),
                                  );
                              this.isLoading = false;
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    storeQuest.questInfo!.user.avatar?.url ??
                                        "https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs",
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "${storeQuest.questInfo!.user.firstName} ${storeQuest.questInfo!.user.lastName}",
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
                        if (storeQuest.questInfo!.userId !=
                            profile!.userData!.id)
                          Icon(
                            Icons.location_on_rounded,
                            color: Color(0xFF7C838D),
                          ),
                        const SizedBox(width: 9),
                        Flexible(
                          child: Text(
                            storeQuest.questInfo!.locationPlaceName,
                            // "150 from you",
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: Color(0xFF7C838D),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 17),
                    tagItem(
                      profile!.parser(
                        storeQuest.questInfo!.questSpecializations,
                      ),
                    ),
                    if (storeQuest.questInfo!.assignedWorker != null &&
                        (storeQuest.questInfo!.status == 1 ||
                            storeQuest.questInfo!.status == 5))
                      inProgressBy(),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        storeQuest.questInfo!.title,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D2127),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(storeQuest.questInfo!.description),
                    const SizedBox(
                      height: 15,
                    ),
                    if (storeQuest.questInfo!.medias.isNotEmpty) ...[
                      Text(
                        "quests.questMaterials".tr(),
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF1D2127),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      ImageViewerWidget(
                        storeQuest.questInfo!.medias,
                        Color(0xFF1D2127),
                      ),
                    ],
                    Text(
                      DateFormat('dd MMMM yyyy, kk:mm')
                          .format(storeQuest.questInfo!.createdAt),
                      style: TextStyle(
                        color: Color(0xFFAAB0B9),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        MapsLauncher.launchCoordinates(
                          storeQuest.questInfo!.locationCode.latitude,
                          storeQuest.questInfo!.locationCode.longitude,
                        );
                      },
                      child: Container(
                        height: 215,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
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
                                  storeQuest.questInfo!.locationCode.latitude,
                                  storeQuest.questInfo!.locationCode.longitude,
                                ),
                                zoom: 15.0,
                              ),
                              myLocationButtonEnabled: false,
                            ),
                            SvgPicture.asset(
                              "assets/marker.svg",
                              width: 22,
                              height: 29,
                              color: Constants.priorityColors[
                                  storeQuest.questInfo!.priority],
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        WorkplaceView(storeQuest.questInfo!.workplace),
                        SizedBox(
                          width: 5,
                        ),
                        tagEmployment(),
                        SizedBox(
                          width: 5,
                        ),
                        PriorityView(
                          storeQuest.questInfo!.priority != 0
                              ? storeQuest.questInfo!.priority - 1
                              : 0,
                          true,
                        ),
                      ],
                    ),
                    getBody(),
                    const SizedBox(
                      height: 20,
                    ),
                    if (storeQuest.questInfo!.status == 6 &&
                        !profile!.review &&
                        (storeQuest.questInfo!.userId ==
                                profile!.userData!.id ||
                            storeQuest.questInfo!.assignedWorker?.id ==
                                profile!.userData!.id))
                      Observer(
                        builder: (_) => isLoading
                            ? Center(
                                child: CircularProgressIndicator.adaptive(),
                              )
                            : TextButton(
                                onPressed: () async {
                                  await Navigator.pushNamed(
                                    context,
                                    CreateReviewPage.routeName,
                                    arguments: storeQuest.questInfo,
                                  );
                                  widget.questInfo.yourReview != null
                                      ? profile!.review = true
                                      : profile!.review = false;
                                },
                                child: Text(
                                  "quests.addReview".tr(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(
                                    Size(double.maxFinite, 43),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.5);
                                      return const Color(0xFF0083C7);
                                    },
                                  ),
                                ),
                              ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget inProgressBy() {
    return const SizedBox();
  }

  Widget tagItem(List<String> skills) {
    return Wrap(
      children: skills
          .map(
            (item) => ActionChip(
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 10.0,
              ),
              onPressed: () => null,
              label: Text(
                item,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Color(0xFF0083C7),
                ),
              ),
              backgroundColor: Color(0xFF0083C7).withOpacity(0.1),
            ),
          )
          .toList(),
    );
  }

  Widget tagEmployment() {
    String employment = "";
    switch (widget.questInfo.employment) {
      case "fullTime":
        employment = "Full time";
        break;
      case "partTime":
        employment = "Part time";
        break;
      case "fixedTerm":
        employment = "Fixed term";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFF22CC14).withOpacity(0.1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        employment,
        style: TextStyle(
          color: Color(0xFF22CC14),
        ),
      ),
    );
  }
}
