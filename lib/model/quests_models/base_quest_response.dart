import 'package:app/model/quests_models/create_quest_model/location_model.dart';
import 'package:app/model/quests_models/create_quest_model/media_model.dart';

import '../user_model.dart';
import 'assigned_worker.dart';

class BaseQuestResponse {
  BaseQuestResponse({
    required this.id,
    required this.userId,
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
    required this.star,
    required this.response,
    required this.locationPlaceName,
    required this.assignedWorker,
    required this.employment,
    required this.questSpecializations,
    required this.workplace,
  });

  String id;
  String userId;
  String category;
  List<Media> medias;
  User user;
  int status;
  int priority;
  LocationCode location;
  String locationPlaceName;
  String title;
  String description;
  String price;
  int adType;
  DateTime createdAt;
  bool star;
  bool response;
  AssignedWorker? assignedWorker;
  String employment;
  List<String> questSpecializations;
  String workplace;

  factory BaseQuestResponse.fromJson(Map<String, dynamic> json) {
    return BaseQuestResponse(
      id: json["id"],
      userId: json["userId"],
      category: json["category"],
      medias: (json["medias"] as List<dynamic>)
          .map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: User.fromJson(json["user"]),
      status: json["status"],
      priority: json["priority"],
      location: LocationCode.fromJson(json["location"]),
      locationPlaceName: json["locationPlaceName"],
      title: json["title"],
      description: json["description"],
      price: json["price"],
      adType: json["adType"],
      createdAt: DateTime.parse(json["createdAt"]),
      star: json["star"] == null ? false : true,
      response: json["response"] == null ? false : true,
      assignedWorker: json["assignedWorker"] == null
          ? null
          : AssignedWorker.fromJson(json["assignedWorker"]),
      employment: json["employment"],
      questSpecializations: (List<Map<String, dynamic>> skills) {
        List<String> skillsString = [];
        for (var skill in skills) {
          skillsString.add(skill.values.toString());
        }
        return skillsString;
      }([...json["questSpecializations"]]),
      workplace: json["workplace"],
    );
  }

  update(BaseQuestResponse updateQuest) {
    this.id = updateQuest.id;
    this.userId = updateQuest.userId;
    this.category = updateQuest.category;
    this.medias = updateQuest.medias;
    this.user = updateQuest.user;
    this.status = updateQuest.status;
    this.priority = updateQuest.priority;
    this.location = updateQuest.location;
    this.title = updateQuest.title;
    this.description = updateQuest.description;
    this.price = updateQuest.price;
    this.adType = updateQuest.adType;
    this.createdAt = updateQuest.createdAt;
    this.star = updateQuest.star;
  }

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
      };
}
