import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage(this.quest);

  static const String routeName = "/mapPage";

  final BaseQuestResponse quest;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Set<Marker> markers = new Set();

  @override
  void initState() {
    markers.add(Marker(
      markerId: MarkerId("MarkerId"),
      position: LatLng(
        widget.quest.locationCode!.latitude,
        widget.quest.locationCode!.longitude,
      ),
      infoWindow: InfoWindow(
        title: widget.quest.title,
        snippet: widget.quest.description,
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.quest.title,
          style: TextStyle(
            fontSize: 17,
            color: Color(0xFF1D2127),
          ),
        ),
        leading: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios_sharp,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        tiltGesturesEnabled: true,
        rotateGesturesEnabled: true,
        zoomControlsEnabled: false,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          bearing: 0,
          target: LatLng(
            widget.quest.locationCode!.latitude,
            widget.quest.locationCode!.longitude,
          ),
          zoom: 15.0,
        ),
        myLocationButtonEnabled: true,
        markers: markers,
      ),
    );
  }
}
