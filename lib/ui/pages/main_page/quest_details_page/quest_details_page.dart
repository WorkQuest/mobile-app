import 'package:app/constants.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/widgets/image_viewer_widget.dart';
import 'package:app/ui/widgets/priority_view.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import "package:provider/provider.dart";

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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_sharp,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: actionAppBar(),
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.questInfo.userId == profile!.userData!.id
                    ? Text(
                        "quests.yourQuest".tr(),
                      )
                    : Container(
                        alignment: Alignment.topLeft,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          runAlignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.center,
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
                            Text(
                              "${widget.questInfo.user.firstName} ${widget.questInfo.user.lastName}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    PriorityView(widget.questInfo.priority),
                    const SizedBox(width: 10),
                    tagEmployment(),
                  ],
                ),
              ],
            ),
            if (widget.questInfo.userId != profile!.userData!.id)
              Column(
                children: [
                  const SizedBox(height: 17),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFF7C838D),
                      ),
                      const SizedBox(width: 9),
                      Text(
                        "150 from you",
                        style: TextStyle(
                          color: Color(0xFF7C838D),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 17),
            tagItem(
              profile!.parser(widget.questInfo.questSpecializations),
            ),
            if (widget.questInfo.assignedWorker != null &&
                (widget.questInfo.status == 1 || widget.questInfo.status == 5))
              inProgressBy(),
            const SizedBox(height: 15),
            Text(
              widget.questInfo.title,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D2127),
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
              ImageViewerWidget(widget.questInfo.medias),
            ],
            Text(
              Utils.dateTimeFormatter(widget.questInfo.createdAt),
              style: TextStyle(
                color: Color(0xFFAAB0B9),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            Container(
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
                        widget.questInfo.location.latitude,
                        widget.questInfo.location.longitude,
                      ),
                      zoom: 15.0,
                    ),
                    myLocationButtonEnabled: false,
                  ),
                  SvgPicture.asset(
                    "assets/marker.svg",
                    width: 22,
                    height: 29,
                    color: Constants.priorityColors[widget.questInfo.priority],
                  ),
                ],
              ),
            ),
            getBody(),
            const SizedBox(height: 20),
          ],
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
            (item) => new ActionChip(
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
