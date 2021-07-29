import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/widgets/priority_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyQuestDetails extends StatefulWidget {
  static const String routeName = "/myQuestDetails";

  const MyQuestDetails(this.questInfo);

  final BaseQuestResponse questInfo;

  @override
  _MyQuestDetailsState createState() => _MyQuestDetailsState();
}

class _MyQuestDetailsState extends State<MyQuestDetails> {
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
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
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
                  borderRadius: BorderRadius.circular(37),
                  child: Image.network(
                    widget.questInfo.user.avatar.url,
                    width: 30,
                    height: 30,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.questInfo.user.firstName + widget.questInfo.user.lastName,
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                PriorityView(1),
              ],
            ),
            SizedBox(
              height: 17,
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: Color(0xFF7C838D),
                ),
                SizedBox(
                  width: 9,
                ),
                Text(
                  "150 from you",
                  style: TextStyle(color: Color(0xFF7C838D)),
                ),
              ],
            ),
            SizedBox(
              height: 17,
            ),
            tagItem("Painting works"),
            SizedBox(
              height: 15,
            ),
            Text(
              widget.questInfo.title,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D2127),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              widget.questInfo.description,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Quest materials",
              style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF1D2127),
                  fontWeight: FontWeight.w500),
            ),
            // Container(height: 215, child: ScreenCoordinate(x: 1, y: 2)),
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
                    color: priorityColors[widget.questInfo.priority],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

const List<Color> priorityColors = [
  Color.fromRGBO(34, 204, 20, 1),
  Color.fromRGBO(34, 204, 20, 1),
  Color.fromRGBO(232, 210, 13, 1),
  Color.fromRGBO(223, 51, 51, 1)
];