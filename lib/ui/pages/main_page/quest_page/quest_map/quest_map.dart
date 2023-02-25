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

  @override
  void initState() {
    mapStore = context.read<QuestMapStore>();
    mapStore!.createMarkerLoader(context);
    _getLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        body: mapStore?.initialCameraPosition == null
            ? Center(child: CircularProgressIndicator.adaptive())
            : Visibility(
                visible: hasPermission,
                maintainState: false,
                replacement: GoogleMap(
                  mapType: MapType.normal,
                  rotateGesturesEnabled: false,
                  initialCameraPosition: mapStore!.initialCameraPosition!,
                  zoomControlsEnabled: false,
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
                        mapStore!.clusterManager.onCameraMove(position);
                      },
                      mapType: MapType.normal,
                      zoomControlsEnabled: false,
                      rotateGesturesEnabled: false,
                      myLocationEnabled: true,
                      initialCameraPosition: mapStore!.initialCameraPosition!,
                      myLocationButtonEnabled: false,
                      markers: mapStore!.markers,
                      onCameraIdle: mapStore!.clusterManager.updateMap,
                      onMapCreated: (GoogleMapController controller) async {
                        _controller = controller;
                        LatLngBounds bounds =
                            await _controller.getVisibleRegion();
                        await mapStore!.getQuestsOnMap(bounds);
                        mapStore!.clusterManager.setMapId(controller.mapId);
                        _onMyLocationPressed();
                      },
                    ),
                    QuestQuickInfo(),
                    searchBar(),
                  ],
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: AnimatedPadding(
          padding: EdgeInsets.only(
            left: 25,
            bottom: mapStore!.hideInfo ? 0.0 : 324.0,
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
                onPressed: mapStore!.hideInfo
                    ? _onMyLocationPressed
                    : mapStore!.closeInfo,
                child: Icon(
                  mapStore!.hideInfo ? Icons.location_on : Icons.close,
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
              builder: (_) => TextFormField(
                onTap: (){
                  mapStore!.getPrediction(context, _controller);
                },
                readOnly: true,
                decoration: InputDecoration(
                  fillColor: Color(0xFFF7F8FA),

                  hintText:mapStore!.address.isNotEmpty
                      ?  mapStore!.address
                      : "quests.ui.search".tr(),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 25.0,
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
      mapStore!.initialCameraPosition = CameraPosition(
        bearing: 192.0,
        target: LatLng(37.4, -122.0),
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
