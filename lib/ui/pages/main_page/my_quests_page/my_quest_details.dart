import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/widgets/image_viewer_widget.dart';
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
  int selectedResponders = -1;
  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

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
    print(widget.questInfo.toJson());
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
                const SizedBox(width: 10),
                Text(
                  widget.questInfo.user.firstName +
                      widget.questInfo.user.lastName,
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                PriorityView(1),
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
            Text(
              "Quest materials",
              style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF1D2127),
                  fontWeight: FontWeight.w500),
            ),
            ImageViewerWidget([
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhwLMUTqqY2BADUh6b1tIn8kTD3tvUz9l6gw&usqp=CAU',
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQZWElbaF0pNId-dQDH-lbGmCuMW9nMK2mEQ&usqp=CAU',
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2Li261EJEg_W2sNpMl-LsEQ3p0aHVrDR0sA&usqp=CAU',
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRbsZs3HAIsLZ62rqmMj17W3TOxeLexZAvwCA&usqp=CAU'
            ]),
            Text(
              (DateTime t) {
                String h = t.hour < 10 ? '0${t.hour}' : t.hour.toString();
                String m = t.minute < 10 ? '0${t.minute}' : t.minute.toString();
                return "${t.day} ${months[t.month]} $h:$m";
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
                    color: priorityColors[widget.questInfo.priority],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "1500 WUSD",
              textAlign: TextAlign.end,
              style: const TextStyle(
                  color: Color(0xFF00AA5B),
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {},
              child: const Text("Show more",
                  style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                fixedSize:
                    MaterialStateProperty.all(Size(double.maxFinite, 43)),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
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
            respondedList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget respondedList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "Responded",
          style: TextStyle(
              fontSize: 18,
              color: Color(0xFF1D2127),
              fontWeight: FontWeight.w500),
        ),
        for (var i = 0; i < 5; i++) selectableMember(i),
        const Text(
          "You invited",
          style: TextStyle(
              fontSize: 18,
              color: Color(0xFF1D2127),
              fontWeight: FontWeight.w500),
        ),
        for (var i = 5; i < 7; i++) selectableMember(i),
      ],
    );
  }

  Widget selectableMember(int index) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.5,
            child: Radio(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: index,
              groupValue: selectedResponders,
              onChanged: (i) {
                setState(() {
                  selectedResponders = index;
                });
              },
            ),
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            child: Image.asset(
              "assets/profile_avatar_test.jpg",
              fit: BoxFit.fitHeight,
              height: 50,
              width: 50,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rosalia Vans",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6CF00),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  "HIGHER LEVEL",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget inProgressBy() {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "In progress by:",
            style: TextStyle(color: const Color(0xFF7C838D), fontSize: 12),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: Image.asset(
                  "assets/profile_avatar_test.jpg",
                  fit: BoxFit.fitHeight,
                  height: 30,
                  width: 30,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Rosalia Vans",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
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
