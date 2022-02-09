import 'package:app/constants.dart';
import 'package:app/enums.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/create_review_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/image_viewer_widget.dart';
import 'package:app/ui/widgets/priority_view.dart';
import 'package:app/ui/widgets/running_line.dart';
import 'package:app/ui/widgets/workplace_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:provider/provider.dart";
import 'package:maps_launcher/maps_launcher.dart';

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

  bool isLoading = false;

  @protected
  List<Widget>? actionAppBar() {
    return null;
  }

  @override
  void initState() {
    profile = context.read<ProfileMeStore>();
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
      body: Stack(children: [
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
      ]),
    );
  }

  Widget _getBody() {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: AbsorbPointer(
        absorbing: isLoading,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: widget.questInfo.userId == profile!.userData!.id
                        ? Text(
                            "quests.yourQuest".tr(),
                          )
                        : GestureDetector(
                            onTap: () async {
                              setState(() {
                                this.isLoading = true;
                              });
                              await profile!
                                  .getQuestHolder(widget.questInfo.userId)
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
                                    widget.questInfo.user.avatar.url,
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SizedBox(
                                    height: 20,
                                    child: RunningLine(
                                      children: [
                                        Text(
                                          "${widget.questInfo.user.firstName} ${widget.questInfo.user.lastName}",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  WorkplaceView(widget.questInfo.workplace),
                  const SizedBox(
                    width: 5,
                  ),
                  tagEmployment(),
                ],
              ),
              const SizedBox(height: 17),
              Row(
                children: [
                  if (widget.questInfo.userId != profile!.userData!.id)
                    Icon(
                      Icons.location_on_rounded,
                      color: Color(0xFF7C838D),
                    ),
                  const SizedBox(width: 9),
                  Flexible(
                    child: Text(
                      widget.questInfo.locationPlaceName,
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
                profile!.parser(widget.questInfo.questSpecializations),
              ),
              if (widget.questInfo.assignedWorker != null &&
                  (widget.questInfo.status == 1 ||
                      widget.questInfo.status == 5))
                inProgressBy(),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {},
                child: Text(
                  widget.questInfo.title,
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
              Text(widget.questInfo.description),
              const SizedBox(
                height: 15,
              ),
              if (widget.questInfo.medias.isNotEmpty) ...[
                Text(
                  "quests.questMaterials".tr(),
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF1D2127),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ImageViewerWidget(widget.questInfo.medias, Color(0xFF1D2127)),
              ],
              Text(
                DateFormat('dd MMMM yyyy, kk:mm')
                    .format(widget.questInfo.createdAt),
                style: TextStyle(
                  color: Color(0xFFAAB0B9),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  MapsLauncher.launchCoordinates(
                    widget.questInfo.locationCode.latitude,
                    widget.questInfo.locationCode.longitude,
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
                            widget.questInfo.locationCode.latitude,
                            widget.questInfo.locationCode.longitude,
                          ),
                          zoom: 15.0,
                        ),
                        myLocationButtonEnabled: false,
                      ),
                      SvgPicture.asset(
                        "assets/marker.svg",
                        width: 22,
                        height: 29,
                        color:
                            Constants.priorityColors[widget.questInfo.priority],
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
              if (profile!.userData!.role == UserRole.Employer)
                Align(
                  alignment: Alignment.topRight,
                  child: PriorityView(widget.questInfo.priority),
                ),
              getBody(),
              if (widget.questInfo.status == 6 &&
                  widget.questInfo.yourReview == null &&
                  (widget.questInfo.userId == profile!.userData!.id ||
                      widget.questInfo.assignedWorker?.id ==
                          profile!.userData!.id))
                isLoading
                    ? Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : Observer(
                        builder: (_) => TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              CreateReviewPage.routeName,
                              arguments: widget.questInfo,
                            );
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
                                if (states.contains(MaterialState.pressed))
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
