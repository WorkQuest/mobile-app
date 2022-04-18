class QuestMapPoint {
  int pointsCount;
  String? questId;
  String? questStatus;
  String? questPrice;
  String? userFirstName;
  String? userLastName;
  String? userAvatarUrl;
  String? questPriority;
  TypeMarker type;
  List<double> location;
  double? clusterRadius;

  QuestMapPoint({
    required this.pointsCount,
    required this.questId,
    required this.questStatus,
    required this.questPrice,
    required this.userFirstName,
    required this.userLastName,
    required this.userAvatarUrl,
    required this.questPriority,
    required this.type,
    required this.location,
    required this.clusterRadius,
  });

  factory QuestMapPoint.fromJson(Map<String, dynamic> json) => QuestMapPoint(
    pointsCount: json["pointsCount"],
    questId: json["questId"],
    questStatus: json["questStatus"],
    questPrice: json["questPrice"],
    userFirstName: json["userFirstName"],
    userLastName: json["userLastName"],
    userAvatarUrl: json["userAvatarUrl"],
    questPriority: json["questPriority"],
    type: json['type'] == "cluster" ? TypeMarker.Cluster : TypeMarker.Point,
    location: List<double>.from(
        json["coordinates"].map((x) => x.toDouble())),
    clusterRadius: json['clusterradius'] == 0 ? 0.0 : json['clusterradius'],
  );

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> locationData = new Map<String, dynamic>();
  //   locationData['pointsCount'] = this.pointsCount;
  //   locationData['questId'] = this.location.toJson();
  //   locationData['type'] = type == TypeMarker.Cluster ? "cluster" : "point";
  //   locationData['clusterradius'] = this.clusterRadius;
  //   return locationData;
  // }
  Map<String, dynamic> toJson() => {
    "pointsCount": pointsCount,
    "questId": questId,
    "questStatus": questStatus,
    "questPrice": questPrice,
    "userFirstName": userFirstName,
    "userLastName": userLastName,
    "userAvatarUrl": userAvatarUrl,
    "questPriority": questPriority,
    "type": type,
    "coordinates": List<double>.from(location.map((x) => x)),
    "clusterradius": clusterRadius == null ? null : clusterRadius,
  };
}

enum TypeMarker { Cluster, Point }