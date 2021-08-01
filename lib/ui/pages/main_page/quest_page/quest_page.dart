import 'package:app/log_service.dart';
import 'package:app/ui/pages/main_page/create_quest_page/create_quest_page.dart';
import 'package:app/ui/pages/main_page/my_quests_page/my_quests_item.dart';
import 'package:app/ui/pages/main_page/notification_page/notification_page.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_quick_info.dart';
import 'package:app/ui/pages/main_page/quest_page/store/quests_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/work_quest_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import "package:provider/provider.dart";
import 'package:flutter/animation.dart';
import '../../../../enums.dart';

class QuestPage extends StatefulWidget {
  @override
  _QuestPageState createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  Location _location = Location();

  late GoogleMapController _controller;
  CameraPosition? _initialCameraPosition;
  QuestsStore? questsStore;
  ProfileMeStore? profileMeStore;
  final QuestItemPriorityType questItemPriorityType =
      QuestItemPriorityType.Starred;
  final scrollKey = new GlobalKey();

  @override
  void initState() {
    questsStore = context.read<QuestsStore>();
    profileMeStore = context.read<ProfileMeStore>();
    profileMeStore!.getProfileMe();
    questsStore!.getQuests();
    questsStore!.loadIcons(context);
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (_) => Scaffold(
              body: questsStore!.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _initialCameraPosition == null
                      ? getBody()
                      : questsStore!.isMapOpened()
                          ? Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                GoogleMap(
                                  mapType: MapType.normal,
                                  rotateGesturesEnabled: false,
                                  initialCameraPosition:
                                      _initialCameraPosition!,
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: false,
                                  markers: questsStore!.getMapMakers(),
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller = controller;
                                  },
                                  onTap: (point) {
                                    if (questsStore!.selectQuestInfo != null)
                                      questsStore!.selectQuestInfo = null;
                                  },
                                ),
                                QuestQuickInfo(questsStore!.selectQuestInfo),
                              ],
                            )
                          : getBody(),
              floatingActionButton: AnimatedContainer(
                padding: EdgeInsets.only(
                    bottom: questsStore!.selectQuestInfo != null ? 324.0 : 0.0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0),
                      child: GestureDetector(
                        onTap: () {
                          print("value should be changed");
                          if (questsStore!.selectQuestInfo != null)
                            questsStore!.selectQuestInfo = null;
                          setState(() {
                            questsStore!.changeValue();
                          });
                        },
                        child: Container(
                          // onPressed: _onMyLocationPressed,
                          padding: const EdgeInsets.only(
                              top: 11, bottom: 11, left: 17, right: 15),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(44),
                          ),
                          child: Row(
                            children: [
                              questsStore!.isMapOpened()
                                  ? Icon(
                                      Icons.list,
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      Icons.map_outlined,
                                      color: Colors.white,
                                    ),
                              SizedBox(
                                width: 12,
                              ),
                              questsStore!.isMapOpened()
                                  ? Text(
                                      "List",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      "Map",
                                      style: TextStyle(color: Colors.white),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    if (questsStore!.isMapOpened())
                      FloatingActionButton(
                        onPressed: questsStore!.selectQuestInfo == null
                            ? _onMyLocationPressed
                            : () => questsStore!.selectQuestInfo = null,
                        child: Icon(
                          questsStore!.selectQuestInfo == null
                              ? Icons.location_on
                              : Icons.close,
                        ),
                      ),
                  ],
                ),
              ),
            ));
  }

  Widget getBody() {
    // if(profileMeStore!.userData.role == UserRole.Worker){
    //
    // }
    return CustomScrollView(
      //controller: _scrollController,
      slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: Row(
            children: [
              Expanded(
                child: Text("Quests"),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, NotificationPage.routeName);
                },
                child: Icon(
                  Icons.notifications_none_outlined,
                ),
              ),
              const SizedBox(
                width: 20.0,
              )
            ],
          ),
        ),
        SliverAppBar(
          pinned: true,
          title: TextFormField(
            maxLines: 1,
            onChanged: questsStore!.setSearchWord,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                size: 25.0,
              ),
              hintText: "City / Street / Place",
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              SizedBox(
                height: 20,
              ),
              if (profileMeStore!.userData!.role == UserRole.Employer)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _getDivider(),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, CreateQuestPage.routeName);
                        },
                        child: Text("Create new quest"),
                      ),
                    ),
                  ],
                ),
              _getDivider(),
              ListView.separated(
                key: scrollKey,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) {
                  return _getDivider();
                },
                padding: EdgeInsets.zero,
                itemCount: questsStore!.searchWord.isEmpty // needs fix with search result list
                    ? questsStore!.questsList!.length
                    : questsStore!.questsList!.length, // questsStore!.searchResultList!.length
                itemBuilder: (_, index) {
                  return MyQuestsItem(
                    questsStore!.questsList![index],
                    itemType: this.questItemPriorityType,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getDivider() {
    return SizedBox(
      height: 10,
      child: Container(
        color: Color(0xFFF7F8FA),
      ),
    );
  }

  Future<void> _onMyLocationPressed() async {
    // final _permissionGranted = await _location.requestPermission();
    // println("Location permission => $_permissionGranted");
    // if (_permissionGranted == PermissionStatus.deniedForever) {
    //   showCupertinoDialog(
    //     context: context,
    //     builder: (context) {
    //       return CupertinoAlertDialog(
    //         title: Text("Access to geolocation is prohibited"),
    //         content: Text(
    //           "Please open settings and allow WorkQuest to use your location",
    //         ),
    //         actions: [
    //           CupertinoDialogAction(
    //             child: Text("Close"),
    //             onPressed: Navigator.of(context).pop,
    //           ),
    //           CupertinoDialogAction(
    //             child: Text("Settings"),
    //             onPressed: () {},
    //           ),
    //         ],
    //       );
    //     },
    //   );
    //   return;
    // }

    final myLocation = await _location.getLocation();

    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(myLocation.latitude!, myLocation.longitude!),
        zoom: 17.0,
      ),
    ));
  }

  Future<void> _getCurrentLocation() async {
    final _permissionGranted = await _location.requestPermission();
    println("Location permission => $_permissionGranted");
    if (_permissionGranted == PermissionStatus.deniedForever) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Access to geolocation is prohibited"),
            content: Text(
              "Please open settings and allow WorkQuest to use your location",
            ),
            actions: [
              CupertinoDialogAction(
                child: Text("Close"),
                onPressed: Navigator.of(context).pop,
              ),
              CupertinoDialogAction(
                child: Text("Settings"),
                onPressed: () {},
              ),
            ],
          );
        },
      );

      _initialCameraPosition = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(37.43296265331129, -122.08832357078792),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414,
      );

      this.setState(() {});
      return;
    }

    final myLocation = await _location.getLocation();

    _initialCameraPosition = CameraPosition(
      bearing: 0,
      target: LatLng(myLocation.latitude!, myLocation.longitude!),
      zoom: 17.0,
    );

    this.setState(() {});
    return;
  }
}
