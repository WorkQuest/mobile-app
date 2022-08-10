import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/responded.dart';
import 'package:app/model/media_model.dart';
import 'package:app/model/quests_models/your_review.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../chat_model/quest_chat.dart';
import '../user_model.dart';
import 'assigned_worker.dart';
import 'invited.dart';
import 'location_full.dart';
import 'open_dispute.dart';

class BaseQuestResponse with ClusterItem {
  BaseQuestResponse({
    required this.id,
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
    required this.startedAt,
    required this.star,
    required this.locationPlaceName,
    required this.assignedWorker,
    required this.employment,
    required this.questSpecializations,
    required this.workplace,
    required this.payPeriod,
    required this.invited,
    required this.responded,
    required this.yourReview,
    required this.questChat,
    required this.raiseView,
    required this.openDispute,
  });

  String id;
  String userId;
  String? category;
  List<Media>? medias;
  User? user;
  int status;
  int priority;
  LocationCode? locationCode;
  String locationPlaceName;
  String title;
  String? assignedWorkerId;
  String? contractAddress;
  String? nonce;
  String description;
  String price;
  DateTime? createdAt;
  DateTime? startedAt;
  bool star;
  AssignedWorker? assignedWorker;
  String employment;
  List<String> questSpecializations;
  String workplace;
  String payPeriod;
  Invited? invited;
  Responded? responded;
  YourReview? yourReview;
  QuestChat? questChat;
  bool showAnimation = true;
  RaiseView? raiseView;
  OpenDispute? openDispute;

  factory BaseQuestResponse.fromJson(Map<String, dynamic> json) {
    return BaseQuestResponse(
      id: json["id"],
      userId: json["userId"] ?? "",
      category: json["category"] == null ? null : json["category"],
      medias: json["medias"] == null
          ? null
          : (json["medias"] as List<dynamic>)
              .map((e) => Media.fromJson(e as Map<String, dynamic>))
              .toList(),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      status: json["status"] ?? 0,
      priority: json["priority"] ?? 0,
      locationCode:
          json["location"] == null ? null : LocationCode.fromJson(json["location"]),
      locationPlaceName: json["locationPlaceName"] ?? "",
      title: json["title"] ?? "",
      assignedWorkerId: json["assignedWorkerId"] ?? "",
      contractAddress: json["contractAddress"] ?? "",
      nonce: json["nonce"] ?? "",
      description: json["description"] ?? "",
      price: json["price"] ?? "",
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      startedAt: json["startedAt"] == null ? null : DateTime.parse(json["startedAt"]),
      star: json["star"] == null ? false : true,
      assignedWorker: json["assignedWorker"] == null
          ? null
          : AssignedWorker.fromJson(json["assignedWorker"]),
      employment: json["typeOfEmployment"] ?? "",
      payPeriod: json["payPeriod"] ?? "",
      questSpecializations: (List<Map<String, dynamic>> skills) {
        List<String> skillsString = [];
        for (var skill in skills) {
          skillsString.add(skill.values.toString());
        }
        return skillsString;
      }([...json["questSpecializations"] ?? []]),
      workplace: json["workplace"] ?? "",
      invited: json["invited"] == null ? null : Invited.fromJson(json["invited"]),
      responded: json["response"] == null ? null : Responded.fromJson(json["response"]),
      yourReview:
          json["yourReview"] == null ? null : YourReview.fromJson(json["yourReview"]),
      questChat: json["questChat"] == null ? null : QuestChat.fromJson(json["questChat"]),
      raiseView: json["raiseView"] == null ? null : RaiseView.fromJson(json["raiseView"]),
      openDispute:
          json["openDispute"] == null ? null : OpenDispute.fromJson(json["openDispute"]),
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
    this.startedAt = updateQuest.startedAt;
    this.star = updateQuest.star;
    this.locationPlaceName = updateQuest.locationPlaceName;
    this.assignedWorker = updateQuest.assignedWorker;
    this.employment = updateQuest.employment;
    this.questSpecializations = updateQuest.questSpecializations;
    this.workplace = updateQuest.workplace;
    this.payPeriod = updateQuest.payPeriod;
    this.invited = updateQuest.invited;
    this.responded = updateQuest.responded;
    this.yourReview = updateQuest.yourReview;
    this.questChat = updateQuest.questChat;
    this.raiseView = updateQuest.raiseView;
    this.openDispute = updateQuest.openDispute;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "assignedWorkerId": assignedWorkerId,
    "contractAddress": contractAddress,
    "nonce": nonce,
    "status": status,
    "title": title,
    "description": description,
    "price": price,
    "payPeriod": payPeriod,
    "workplace": workplace,
    "priority": priority,
    "location": location.toJson(),
    "locationPlaceName": locationPlaceName,
    "startedAt": startedAt,
    "createdAt": createdAt?.toIso8601String(),
    "assignedWorker": assignedWorker,
    "raiseView": raiseView?.toJson(),
    "star": star,
    "response": responded?.toJson(),
    "openDispute": openDispute,
    "yourReview": yourReview,
  };

  factory BaseQuestResponse.empty() {
    return BaseQuestResponse(
      id: 'id',
      userId: 'userId',
      medias: [],
      user: null,
      category: 'category',
      status: 0,
      priority: 0,
      locationCode: null,
      title: 'title',
      assignedWorkerId: 'assignedWorkerId',
      contractAddress: 'contractAddress',
      nonce: 'nonce',
      description: 'description',
      price: 'price',
      createdAt: DateTime.now(),
      startedAt: DateTime.now(),
      star: false,
      locationPlaceName: 'locationPlaceName',
      assignedWorker: null,
      employment: 'employment',
      questSpecializations: [],
      workplace: 'workplace',
      payPeriod: 'payPeriod',
      invited: null,
      responded: null,
      yourReview: null,
      questChat: null,
      raiseView: null,
      openDispute: null,
    );
  }

  @override
  LatLng get location => LatLng(locationCode!.latitude, locationCode!.longitude);
}
