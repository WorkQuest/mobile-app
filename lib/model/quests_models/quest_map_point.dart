import 'package:app/model/quests_models/create_quest_model/location_model.dart';

class QuestMapPoint {
  int pointsCount;
  Location location;
  TypeMarker type;
  String? questId;
  double? clusterRadius;
  QuestMapPoint({
    required this.pointsCount,
    required this.location,
    required this.questId,
    required this.type,
    required this.clusterRadius,
  });

  factory QuestMapPoint.fromJson(Map<String, dynamic> json) => QuestMapPoint(
      pointsCount: json['pointscount'],
      questId: json['questid'],
      location: Location(
        latitude: json['coordinates'][0] == 0 ? 0.0 : json['coordinates'][0],
        longitude: json['coordinates'][1] == 0 ? 0.0 : json['coordinates'][1],
      ),
      type: json['type'] == "cluster" ? TypeMarker.Cluster : TypeMarker.Point,
      clusterRadius: json['clusterradius'] == 0 ? 0.0 : json['clusterradius']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> locationData = new Map<String, dynamic>();
    locationData['pointscount'] = this.pointsCount;
    locationData['questid'] = this.location.toJson();
    locationData['type'] = type == TypeMarker.Cluster ? "cluster" : "point";
    locationData['clusterradius'] = this.clusterRadius;
    return locationData;
  }
}

enum TypeMarker { Cluster, Point }
