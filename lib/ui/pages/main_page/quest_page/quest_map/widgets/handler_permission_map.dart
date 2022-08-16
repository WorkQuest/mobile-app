import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HandlerPermissionMapWidget extends StatefulWidget {
  final Function(CameraPosition) callbackPosition;
  final Widget child;

  const HandlerPermissionMapWidget({
    Key? key,
    required this.callbackPosition,
    required this.child,
  }) : super(key: key);

  @override
  State<HandlerPermissionMapWidget> createState() => _HandlerPermissionMapWidgetState();
}

class _HandlerPermissionMapWidgetState extends State<HandlerPermissionMapWidget> with WidgetsBindingObserver {
  GeolocatorPlatform _geoLocatorPlatform = GeolocatorPlatform.instance;
  late Future<CameraPosition?> _positionOnMap;

  CameraPosition? _currentPosition;

  bool get hasPosition => _currentPosition != null;

  Future<CameraPosition?> getPosition() async {
    if (hasPosition) {
      return _currentPosition;
    }
    LocationPermission permission = await _geoLocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geoLocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return CameraPosition(
          bearing: 0,
          target: LatLng(59.43634169219954, 24.72916993898239),
          zoom: 17.0,
        );
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _requestPermissionDialog();
      return null;
    }

    final position = await _geoLocatorPlatform.getCurrentPosition();
    return CameraPosition(
      bearing: 0,
      target: LatLng(position.latitude, position.longitude),
      zoom: 17.0,
    );
  }

  @override
  void initState() {
    _positionOnMap = getPosition();
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _positionOnMap = getPosition();
    }
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
          _currentPosition = position;
          widget.callbackPosition.call(position);
          return widget.child;
        }
        print('FutureBuilder skip all states');
        return Center(child: CircularProgressIndicator.adaptive());
      },
    );
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
                _geoLocatorPlatform.openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }
}
