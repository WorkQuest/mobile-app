import 'dart:async';
import 'package:app/ui/pages/main_page/quest_page/quest_map/store/quest_map_store.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_quick_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

import '../../settings_page/pages/SMS_verification_page/store/sms_verification_store.dart';

class QuestMap extends StatefulWidget {
  final void Function() changePage;

  QuestMap(this.changePage);

  @override
  _QuestMapState createState() => _QuestMapState();
}

class _QuestMapState extends State<QuestMap> {
  QuestMapStore? mapStore;
  late GoogleMapController _controller;
  bool hasPermission = false;
  final GeolocatorPlatform _geoLocatorPlatform = GeolocatorPlatform.instance;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;

  @override
  void initState() {
    mapStore = context.read<QuestMapStore>();
    mapStore!.createMarkerLoader(context);
    context.read<SMSVerificationStore>().initTime();
    _getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        body: mapStore?.initialCameraPosition == null
            ? Center(child: CircularProgressIndicator())
            : Visibility(
                visible: hasPermission,
                maintainState: false,
                replacement: GoogleMap(
                  mapType: MapType.normal,
                  rotateGesturesEnabled: false,
                  initialCameraPosition: mapStore!.initialCameraPosition!,
                  minMaxZoomPreference: MinMaxZoomPreference(4, 20),
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    GoogleMap(
                      onCameraMove: (CameraPosition position) {
                        if (mapStore?.debounce != null)
                          mapStore!.debounce!.cancel();
                        mapStore!.debounce = Timer(
                          const Duration(milliseconds: 200),
                          () async {
                            LatLngBounds bounds =
                                await _controller.getVisibleRegion();
                            mapStore!.getQuestsOnMap(bounds);
                          },
                        );
                      },
                      mapType: MapType.normal,
                      rotateGesturesEnabled: false,
                      myLocationEnabled: true,
                      initialCameraPosition: mapStore!.initialCameraPosition!,
                      myLocationButtonEnabled: false,
                      markers: mapStore!.markers.toSet(),
                      minMaxZoomPreference: MinMaxZoomPreference(4, 17),
                      onMapCreated: (GoogleMapController controller) async {
                        _controller = controller;
                        LatLngBounds bounds =
                            await _controller.getVisibleRegion();
                        mapStore!.getQuestsOnMap(bounds);
                        _onMyLocationPressed();
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

  Future<void> _getLocation() async {
    hasPermission = await _handlePermission();

    setState(() {});

    if (!hasPermission) {
      print('!hasPermission');
      mapStore!.initialCameraPosition = CameraPosition(
        bearing: 0,
        target: LatLng(59.42571345925132, 24.73492567301246),
        zoom: 19,
      );
      return;
    }
    await updatePosition();

    mapStore!.initialCameraPosition = CameraPosition(
      bearing: 0,
      target: LatLng(
        mapStore!.locationPosition?.latitude ?? 90.0,
        mapStore!.locationPosition?.longitude ?? 90.0,
      ),
      zoom: 17.0,
    );
    return;
  }

  Future<void> _onMyLocationPressed() async {
    hasPermission = await _handlePermission();
    setState(() {});
    if (hasPermission) {
      await updatePosition();
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
            target: LatLng(
              mapStore?.locationPosition?.latitude ?? 90.0,
              mapStore!.locationPosition?.longitude ?? 90,
            ),
            zoom: 17.0,
          ),
        ),
      );
    }
  }

  Future<void> updatePosition() async {
    _geoLocatorPlatform.getCurrentPosition().then((position) {
      mapStore?.locationPosition = position;
    });

    await _geoLocatorPlatform.getLastKnownPosition().then((position) {
      mapStore?.locationPosition = position;
    });
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geoLocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      return false;
    }

    permission = await _geoLocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geoLocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _requestPermissionDialog();
      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return true;
  }

  Future<void> _requestPermissionDialog() {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "quests.ui.access".tr(),
          ),
          content: Text(
            "quests.ui.openSettings".tr(),
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
              onPressed: () async {
                Navigator.pop(context);
                await _geoLocatorPlatform.openAppSettings();
                print("pop");
                await _onMyLocationPressed();
              },
            ),
          ],
        );
      },
    );
  }
}
