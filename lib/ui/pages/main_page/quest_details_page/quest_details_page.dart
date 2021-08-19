import 'package:app/constants.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/widgets/image_viewer_widget.dart';
import 'package:app/ui/widgets/priority_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class QuestDetails extends StatefulWidget {
  static const String routeName = "/QuestDetails";
  const QuestDetails(this.questInfo);
  final BaseQuestResponse questInfo;
  @override
  QuestDetailsState createState() => QuestDetailsState();
}

class QuestDetailsState<T extends QuestDetails> extends State<T>
    with TickerProviderStateMixin {
  int selectedResponders = -1;
  bool sendRequestBodyHide = true;

  @protected
  List<Widget>? actionAppBar() {
    return null;
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
                  widget.questInfo.user.firstName +
                      widget.questInfo.user.lastName,
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                PriorityView(widget.questInfo.priority),
              ],
            ),
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
                  style: TextStyle(color: Color(0xFF7C838D)),
                ),
              ],
            ),
            const SizedBox(height: 17),
            tagItem("Painting works"),
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
            const SizedBox(height: 15),
            Text(widget.questInfo.description),
            const SizedBox(height: 15),
            if (widget.questInfo.medias.isNotEmpty) ...[
              const Text(
                "Quest materials",
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF1D2127),
                    fontWeight: FontWeight.w500),
              ),
              ImageViewerWidget(widget.questInfo.medias),
            ],
            Text(
              (DateTime t) {
                String h = t.hour < 10 ? '0${t.hour}' : t.hour.toString();
                String m = t.minute < 10 ? '0${t.minute}' : t.minute.toString();
                return "${t.day} ${Constants.months[t.month]} ${t.year}, $h:$m";
              }(widget.questInfo.createdAt), // For convenience =D
              style: TextStyle(color: Color(0xFFAAB0B9), fontSize: 12),
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
                      target: LatLng(widget.questInfo.location.latitude,
                          widget.questInfo.location.longitude),
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

  Widget tagItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: Color(0xFF0083C7).withOpacity(0.1),
        borderRadius: BorderRadius.circular(44),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFF0083C7),
          fontSize: 16,
        ),
      ),
    );
  }
}
