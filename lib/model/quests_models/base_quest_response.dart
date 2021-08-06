import 'package:app/model/quests_models/create_quest_model/location_model.dart';
import 'package:app/model/quests_models/create_quest_model/media_model.dart';

import '../user_model.dart';

class BaseQuestResponse {
  BaseQuestResponse({
    required this.id,
    required this.userId,
    // required this.assignedWorkerId,
    //required this.assignedWorker,
    required this.medias,
    required this.user,
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

  String id;
  String userId;
  String category;
  // String assignedWorkerId;
  // dynamic assignedWorker;
  List<Media> medias;
  User user;
  int status;
  int priority;
  Location location;
  String title;
  String description;
  String price;
  int adType;
  DateTime createdAt;
  DateTime updatedAt;

  factory BaseQuestResponse.fromJson(Map<String, dynamic> json) =>
      BaseQuestResponse(
        id: json["id"],
        userId: json["userId"],
        category: json["category"],
        // assignedWorker: json["assignedWorker"],
        //assignedWorkerId: json["assignedWorkerId"] == null ? " " : json["assignedWorkerId"],
        medias: (json["medias"] as List<dynamic>)
            .map((e) => Media.fromJson(e as Map<String, dynamic>))
            .toList(),
        user: User.fromJson(json["user"]),
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
