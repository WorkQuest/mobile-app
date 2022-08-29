import 'dart:async';
import 'package:app/constants.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_map/store/search_map_store.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_map/widgets/quick_info_widget.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_map/widgets/search_bar_widget.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

class SearchMap extends StatefulWidget {
  final Function() changePage;
  final CameraPosition position;
  final Function(CameraPosition) callbackPosition;

  SearchMap(this.changePage, this.position, this.callbackPosition);

  @override
  _SearchMapState createState() => _SearchMapState();
}

class _SearchMapState extends State<SearchMap> {
  late SearchMapStore mapStore;
  late GoogleMapController _controller;
  final GeolocatorPlatform _geoLocatorPlatform = GeolocatorPlatform.instance;

  @override
  void initState() {
    mapStore = context.read<SearchMapStore>();
    mapStore.createMarkerLoader(context);
    mapStore.initialCameraPosition = widget.position;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GoogleMap(
                  onCameraMove: _onCameraMove,
                  onMapCreated: _onMapCreated,
                  onCameraIdle: mapStore.clusterManager.updateMap,
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  rotateGesturesEnabled: false,
                  myLocationEnabled: true,
                  minMaxZoomPreference: MinMaxZoomPreference(4, 17),
                  initialCameraPosition: mapStore.initialCameraPosition!,
                  myLocationButtonEnabled: false,
                  markers: mapStore.markers,
                ),
                QuestQuickInfo(),
                Observer(
                  builder: (_) => SearchBarMapWidget(
                    onTap: _onPressedOnSearchMap,
                    hintText: mapStore.address.isNotEmpty
                        ? mapStore.address
                        : "quests.ui.search".tr(),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: AnimatedPadding(
          padding: EdgeInsets.only(
              left: 25, bottom: mapStore.hideInfo ? 0.0 : 324.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton(
                heroTag: "QuestMapLftActionButton",
                onPressed: widget.changePage,
                child: const Icon(Icons.list, color: Colors.white),
              ),
              FloatingActionButton(
                heroTag: "QuestMapRightActionButton",
                onPressed: mapStore.hideInfo
                    ? _onMyLocationPressed
                    : mapStore.closeInfo,
                child:
                    Icon(mapStore.hideInfo ? Icons.location_on : Icons.close),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onPressedOnSearchMap() {
    mapStore.getPrediction(context, _controller);
  }

  _onCameraMove(CameraPosition position) {
    if (mapStore.debounce != null) mapStore.debounce!.cancel();
    mapStore.debounce = Timer(
      const Duration(milliseconds: 200),
      () async {
        LatLngBounds bounds = await _controller.getVisibleRegion();
        mapStore.getQuestsOnMap(bounds);
      },
    );
    mapStore.clusterManager.onCameraMove(position);
    widget.callbackPosition.call(position);
  }

  _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    LatLngBounds bounds = await _controller.getVisibleRegion();
    await mapStore.getQuestsOnMap(bounds);
    mapStore.clusterManager.setMapId(controller.mapId);
    widget.callbackPosition.call(mapStore.initialCameraPosition!);
  }

  Future<void> _onMyLocationPressed() async {
    final hasPermission = await _handlePermission();
    setState(() {});
    if (hasPermission) {
      await updatePosition();
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 0,
            target: LatLng(
              mapStore.locationPosition?.latitude ?? 90.0,
              mapStore.locationPosition?.longitude ?? 90,
            ),
            zoom: 17.0,
          ),
        ),
      );
    }
  }

  Future<void> updatePosition() async {
    _geoLocatorPlatform.getCurrentPosition().then((position) {
      mapStore.locationPosition = position;
    });

    await _geoLocatorPlatform.getLastKnownPosition().then((position) {
      mapStore.locationPosition = position;
    });
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await _geoLocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      updatePosition();
      return false;
    }

    permission = await _geoLocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geoLocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _requestPermissionDialog();
      return false;
    }
    return true;
  }

  Future<void> _requestPermissionDialog() {
    return AlertDialogUtils.showAlertDialog(
      context,
      title: Text(
        "quests.ui.access".tr(),
      ),
      content: Text(
        "quests.ui.openSettings".tr(),
      ),
      needCancel: true,
      titleOk: "ui.profile.settings".tr(),
      colorCancel: Colors.red,
      colorOk: AppColor.enabledButton,
      onTabOk: () {
        _geoLocatorPlatform.openAppSettings();
      },
    );
  }
}
