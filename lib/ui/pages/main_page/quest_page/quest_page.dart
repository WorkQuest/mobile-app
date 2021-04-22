import 'dart:async';

import 'package:app/log_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class QuestPage extends StatefulWidget {
  @override
  _QuestPageState createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> {
  Location _location = Location();

  late GoogleMapController _controller;
  CameraPosition? _initialCameraPosition;

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _initialCameraPosition == null
          ? SizedBox()
          : GoogleMap(
              mapType: MapType.normal,
              rotateGesturesEnabled: false,
              initialCameraPosition: _initialCameraPosition!,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onMyLocationPressed,
        child: Icon(
          Icons.location_on,
        ),
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
