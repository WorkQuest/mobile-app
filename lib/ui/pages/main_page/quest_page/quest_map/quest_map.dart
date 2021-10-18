import 'dart:async';
import 'package:app/ui/pages/main_page/quest_page/quest_map/store/quest_map_store.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_quick_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

class QuestMap extends StatefulWidget {
  final void Function() changePage;

  QuestMap(this.changePage);

  @override
  _QuestMapState createState() => _QuestMapState();
}

class _QuestMapState extends State<QuestMap> {
  Location _location = Location();
  QuestMapStore? mapStore;
  CameraPosition? _initialCameraPosition;
  late GoogleMapController _controller;

  @override
  void initState() {
    mapStore = context.read<QuestMapStore>();
    mapStore!.createMarkerLoader(context);
    _getCurrentLocation();
    super.initState();
  }

  bool isLoading() {
    if (_initialCameraPosition == null) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        body: isLoading()
            ? Center(child: CircularProgressIndicator())
            : Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GoogleMap(
                    onCameraMove: (CameraPosition position) {
                      if (mapStore?.debounce != null)
                        mapStore!.debounce!.cancel();
                      mapStore!.debounce = Timer(
                        const Duration(milliseconds: 50),
                        () async {
                          LatLngBounds bounds =
                              await _controller.getVisibleRegion();
                          mapStore!.getQuests(bounds);
                        },
                      );
                    },
                    mapType: MapType.normal,
                    rotateGesturesEnabled: false,
                    initialCameraPosition: _initialCameraPosition!,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    markers: mapStore!.markers.toSet(),
                    onMapCreated: (GoogleMapController controller) async {
                      _controller = controller;
                      LatLngBounds bounds =
                          await _controller.getVisibleRegion();
                      mapStore!.getQuests(bounds);
                    },
                    onTap: (point) {
                      if (mapStore!.infoPanel != InfoPanel.Nope)
                        mapStore!.onCloseQuest();
                    },
                  ),
                  QuestQuickInfo(),
                  searchBar(),
                ],
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: AnimatedContainer(
          padding: EdgeInsets.only(
            left: 25,
            bottom: mapStore!.infoPanel != InfoPanel.Nope ? 324.0 : 0.0,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                heroTag: "QuestMapLftActionButton",
                onPressed: widget.changePage,
                child: const Icon(
                  Icons.list,
                  color: Colors.white,
                ),
              ),
              FloatingActionButton(
                heroTag: "QuestMapRightActionButton",
                onPressed: mapStore!.infoPanel == InfoPanel.Nope
                    ? _onMyLocationPressed
                    : mapStore!.onCloseQuest,
                child: Icon(
                  mapStore!.infoPanel == InfoPanel.Nope
                      ? Icons.location_on
                      : Icons.close,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchBar() => Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 54),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Observer(
              builder: (_) => GestureDetector(
                onTap: () {
                  mapStore!.getPrediction(context, _controller);

                },
                child: Container(
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.search,
                          size: 25.0,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          child: mapStore!.address.isNotEmpty
                              ? Text(
                                  mapStore!.address,
                                  overflow: TextOverflow.fade,
                                )
                              : Text(
                                  "quests.ui.search".tr(),
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                    color: Color(0xFFD8DFE3),
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Future<void> _getCurrentLocation() async {
    final _permissionGranted = await _location.requestPermission();
    print("Location permission => $_permissionGranted");
    if (_permissionGranted == PermissionStatus.deniedForever) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              "quests.access".tr(),
            ),
            content: Text(
              "quests.openSettings".tr(),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  "meta.close".tr(),
                ),
                onPressed: Navigator.of(context).pop,
              ),
              CupertinoDialogAction(
                child: Text(
                  "ui.profile.settings".tr(),
                ),
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

  Future<void> _onMyLocationPressed() async {
    final myLocation = await _location.getLocation();
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(myLocation.latitude!, myLocation.longitude!),
        zoom: 17.0,
      ),
    ));
  }
}
