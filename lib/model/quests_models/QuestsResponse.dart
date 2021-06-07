import 'package:app/model/quests_models/create_quest_model/location_model.dart';

class QuestsResponse {
  QuestsResponse({
    required this.userId,
    required this.category,
    required this.status,
    required this.priority,
    required this.location,
    required this.title,
    required this.description,
    required this.price,
    required this.adType,
    required this.createdAt,
    required this.updatedAt,
  });

  String userId;
  String category;
  int status;
  int priority;
  Location location;
  String title;
  String description;
  String price;
  int adType;
  DateTime createdAt;
  DateTime updatedAt;

  factory QuestsResponse.fromJson(Map<String, dynamic> json) => QuestsResponse(
    userId: json["userId"],
    category: json["category"],
    status: json["status"],
    priority: json["priority"],
    location: Location.fromJson(json["location"]),
    title: json["title"],
    description: json["description"],
    price: json["price"],
    adType: json["adType"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "category": category,
    "status": status,
    "priority": priority,
    "location": location.toJson(),
    "title": title,
    "description": description,
    "price": price,
    "adType": adType,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}