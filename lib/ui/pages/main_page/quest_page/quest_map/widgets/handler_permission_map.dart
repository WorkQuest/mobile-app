import 'package:app/constants.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_map/quest_map.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const _defaultPosition = CameraPosition(
  bearing: 0,
  target: LatLng(59.43634169219954, 24.72916993898239),
  zoom: 17.0,
);

class HandlerPermissionMapWidget extends StatefulWidget {
  final Function() changePage;

  const HandlerPermissionMapWidget({
    Key? key,
    required this.changePage,
  }) : super(key: key);

  @override
  State<HandlerPermissionMapWidget> createState() => _HandlerPermissionMapWidgetState();
}

class _HandlerPermissionMapWidgetState extends State<HandlerPermissionMapWidget> with WidgetsBindingObserver {
  GeolocatorPlatform _geoLocatorPlatform = GeolocatorPlatform.instance;
  late Future<CameraPosition?> _positionOnMap;

  CameraPosition? _currentPosition;

  bool get hasPosition => _currentPosition != null;

  AppLifecycleState? state;

  Future<CameraPosition?> getPosition() async {
    try {
      await Future.delayed(Duration.zero);
      if (hasPosition) {
        setState(() {});
        return _currentPosition;
      }
      LocationPermission permission = await _geoLocatorPlatform.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await _geoLocatorPlatform.requestPermission();
        if (permission == LocationPermission.denied) {
          return _defaultPosition;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _requestPermissionDialog();
        return _defaultPosition;
      }



      final position = await _geoLocatorPlatform.getCurrentPosition();
      return CameraPosition(
        bearing: 0,
        target: LatLng(position.latitude, position.longitude),
        zoom: 17.0,
      );
    } catch (e, trace) {
      print('HandlerPermissionMap getPosition: $e\n$trace');
      return _defaultPosition;
    }
  }

  @override
  void initState() {
    _positionOnMap = getPosition();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (this.state != null) {
      if (state == AppLifecycleState.resumed && this.state == AppLifecycleState.paused) {
        _positionOnMap = getPosition();
      }
    }
    this.state = state;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CameraPosition?>(
      future: _positionOnMap,
      builder: (context, AsyncSnapshot<CameraPosition?> snapshot) {
        final position = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting || position == null) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return QuestMap(
            widget.changePage,
            position,
            (position) => _currentPosition = position,
          );
        }
        return Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }

  _requestPermissionDialog() {
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
