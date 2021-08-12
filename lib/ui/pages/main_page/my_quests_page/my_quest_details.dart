import 'package:app/enums.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/create_quest_page/create_quest_page.dart';
import 'package:app/ui/pages/main_page/raise_views_page/raise_views_page.dart';
import 'package:app/ui/widgets/image_viewer_widget.dart';
import 'package:app/ui/widgets/priority_view.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyQuestDetails extends StatefulWidget {
  static const String routeName = "/myQuestDetails";
  const MyQuestDetails(this.questInfo, this.role);
  final BaseQuestResponse questInfo;
  final UserRole? role;
  @override
  _MyQuestDetailsState createState() => _MyQuestDetailsState();
}

class _MyQuestDetailsState extends State<MyQuestDetails>
    with TickerProviderStateMixin {
  AnimationController? controller;
  int selectedResponders = -1;
  bool sendRequestBodyHide = true;
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
  void initState() {
    super.initState();
    controller = BottomSheet.createAnimationController(this);
    controller!.duration = Duration(seconds: 1);
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
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.share_outlined,
              ),
              onPressed: () {},
            ),
            if (widget.role == UserRole.Employer)
              PopupMenuButton<String>(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                onSelected: (value) {
                  switch (value) {
                    case "Raise views":
                      Navigator.pushNamed(context, RaiseViews.routeName,
                          arguments: widget.questInfo);
                      break;
                    case "Edit":
                      Navigator.pushNamed(context, CreateQuestPage.routeName,
                          arguments: widget.questInfo);
                      break;
                    case "Delete":
                      print("[tag] Delete");
                      break;
                    default:
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Raise views', 'Edit', 'Delete'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
          ]),
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
            if (widget.role == UserRole.Employer) inProgressBy(),
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
                return "${t.day} ${months[t.month]} ${t.year}, $h:$m";
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
            if (widget.role == UserRole.Worker) ...<Widget>[
              const SizedBox(height: 20),
              Text(
                "${widget.questInfo.price} WUSD",
                textAlign: TextAlign.end,
                style: const TextStyle(
                    color: Color(0xFF00AA5B),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: bottomForm,
                child: const Text("Send a request",
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
              )
            ],
            if (widget.role == UserRole.Employer) respondedList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  bottomForm() => showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6.0), topRight: Radius.circular(6.0)),
          ),
          context: context,
          backgroundColor: Colors.white,
          transitionAnimationController: controller,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 10.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 5.0,
                      width: 70.0,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 23),
                      Text(
                        "Write a few words to the employer",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: 'Hello...',
                        ),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 15),
                      DottedBorder(
                        padding: EdgeInsets.all(0),
                        color: Color(0xFFe9edf2),
                        strokeWidth: 3.0,
                        child: Container(
                          height: 66,
                          padding: EdgeInsets.only(left: 20, right: 10),
                          color: Color(0xFFf7f8fa),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Upload a images or videos"),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.add_a_photo))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Send a request",
                            style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                              Size(double.maxFinite, 43)),
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
                      const SizedBox(height: 15),
                    ],
                  ),
                ],
              ),
            );
          }).whenComplete(() {
        controller = BottomSheet.createAnimationController(this);
      });

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
  Color.fromRGBO(223, 51, 51, 1),
];
