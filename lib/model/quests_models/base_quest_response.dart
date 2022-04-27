import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/Responded.dart';
import 'package:app/model/quests_models/media_model.dart';
import 'package:app/model/quests_models/your_review.dart';

import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../chat_model/quest_chat.dart';
import '../user_model.dart';
import 'assigned_worker.dart';
import 'invited.dart';
import 'location_full.dart';

class BaseQuestResponse with ClusterItem {
  BaseQuestResponse(
      {required this.id,
      required this.userId,
      required this.medias,
      required this.user,
      required this.category,
      required this.status,
      required this.priority,
      required this.locationCode,
      required this.title,
      required this.assignedWorkerId,
      required this.contractAddress,
      required this.nonce,
      required this.description,
      required this.price,
      required this.createdAt,
      required this.star,
      required this.locationPlaceName,
      required this.assignedWorker,
      required this.employment,
      required this.questSpecializations,
      required this.workplace,
      required this.invited,
      required this.responded,
      required this.yourReview,
      required this.questChat,
      required this.raiseView});

  String id;
  String userId;
  String? category;
  List<Media>? medias;
  User user;
  int status;
  int priority;
  LocationCode locationCode;
  String locationPlaceName;
  String title;
  String? assignedWorkerId;
  String? contractAddress;
  String? nonce;
  String description;
  String price;
  DateTime createdAt;
  bool star;
  AssignedWorker? assignedWorker;
  String employment;
  List<String> questSpecializations;
  String workplace;
  Invited? invited;
  Responded? responded;
  YourReview? yourReview;
  QuestChat? questChat;
  bool showAnimation = true;
  RaiseView? raiseView;

  factory BaseQuestResponse.fromJson(Map<String, dynamic> json) {
    return BaseQuestResponse(
      id: json["id"],
      userId: json["userId"],
      category: json["category"] == null ? null : json["category"],
      medias: json["medias"] == null
          ? null
          : (json["medias"] as List<dynamic>)
              .map((e) => Media.fromJson(e as Map<String, dynamic>))
              .toList(),
      user: User.fromJson(json["user"]),
      status: json["status"],
      priority: json["priority"],
      locationCode: LocationCode.fromJson(json["location"]),
      locationPlaceName: json["locationPlaceName"],
      title: json["title"],
      assignedWorkerId: json["title"],
      contractAddress: json["contractAddress"],
      nonce: json["title"],
      description: json["description"],
      price: json["price"],
      createdAt: DateTime.parse(json["createdAt"]),
      star: json["star"] == null ? false : true,
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
      invited:
          json["invited"] == null ? null : Invited.fromJson(json["invited"]),
      responded: json["responded"] == null
          ? null
          : Responded.fromJson(json["responded"]),
      yourReview: json["yourReview"] == null
          ? null
          : YourReview.fromJson(json["yourReview"]),
      questChat: json["questChat"] == null
          ? null
          : QuestChat.fromJson(json["questChat"]),
      raiseView: json["raiseView"] == null ? null : RaiseView.fromJson(json["raiseView"]),
    );
  }

  update(BaseQuestResponse updateQuest) {
    this.id = updateQuest.id;
    this.userId = updateQuest.userId;
    // this.category = updateQuest.category;
    this.medias = updateQuest.medias;
    this.user = updateQuest.user;
    this.status = updateQuest.status;
    this.priority = updateQuest.priority;
    this.locationCode = updateQuest.locationCode;
    this.title = updateQuest.title;
    this.description = updateQuest.description;
    this.price = updateQuest.price;
    this.createdAt = updateQuest.createdAt;
    this.star = updateQuest.star;
    this.locationPlaceName = updateQuest.locationPlaceName;
    this.assignedWorker = updateQuest.assignedWorker;
    this.employment = updateQuest.employment;
    this.questSpecializations = updateQuest.questSpecializations;
    this.workplace = updateQuest.workplace;
    this.invited = updateQuest.invited;
    this.responded = updateQuest.responded;
    this.yourReview = updateQuest.yourReview;
    this.questChat = updateQuest.questChat;
    this.raiseView = updateQuest.raiseView;
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "category": category,
        "status": status,
        "priority": priority,
        "location": locationCode.toJson(),
        "title": title,
        "description": description,
        "price": price,
        "createdAt": createdAt.toIso8601String(),
        "questChat": questChat,
      };

  @override
  LatLng get location => LatLng(locationCode.latitude, locationCode.longitude);
}
