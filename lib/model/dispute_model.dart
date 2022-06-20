import 'package:app/model/profile_response/avatar.dart';
import 'package:app/model/profile_response/rating_statistic.dart';
import 'package:app/model/quests_models/base_quest_response.dart';

class DisputeModel {
  DisputeModel({
    required this.id,
    required this.questId,
    required this.openDisputeUserId,
    required this.opponentUserId,
    required this.assignedAdminId,
    required this.number,
    required this.status,
    required this.reason,
    required this.openOnQuestStatus,
    required this.problemDescription,
    required this.decisionDescription,
    required this.openDisputeUser,
    required this.opponentUser,
    required this.assignedAdmin,
    required this.quest,
    required this.currentUserDisputeReview,
    required this.resolveAt,
    required this.createdAt,
  });

  String id;
  String questId;
  String openDisputeUserId;
  String opponentUserId;
  String? assignedAdminId;
  int number;
  int status;
  String reason;
  int openOnQuestStatus;
  String problemDescription;
  String? decisionDescription;
  DisputeUser openDisputeUser;
  DisputeUser opponentUser;
  AssignedAdmin? assignedAdmin;
  BaseQuestResponse quest;
  CurrentUserDisputeReview? currentUserDisputeReview;
  DateTime? resolveAt;
  DateTime createdAt;

  factory DisputeModel.fromJson(Map<String, dynamic> json) => DisputeModel(
        id: json["id"],
        questId: json["questId"],
        openDisputeUserId: json["openDisputeUserId"],
        opponentUserId: json["opponentUserId"],
        assignedAdminId: json["assignedAdminId"],
        number: json["number"],
        status: json["status"],
        reason: json["reason"],
        openOnQuestStatus: json["openOnQuestStatus"],
        problemDescription: json["problemDescription"],
        decisionDescription: json["decisionDescription"],
        openDisputeUser: DisputeUser.fromJson(json["openDisputeUser"]),
        opponentUser: DisputeUser.fromJson(json["opponentUser"]),
        assignedAdmin: json["assignedAdmin"] == null
            ? null
            : AssignedAdmin.fromJson(json["assignedAdmin"]),
        quest: BaseQuestResponse.fromJson(json["quest"]),
        currentUserDisputeReview: json["currentUserDisputeReview"] == null
            ? null
            : CurrentUserDisputeReview.fromJson(
                json["currentUserDisputeReview"]),
        resolveAt: json["resolveAt"] == null
            ? null
            : DateTime.parse(json["resolveAt"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "questId": questId,
        "openDisputeUserId": openDisputeUserId,
        "opponentUserId": opponentUserId,
        "assignedAdminId": assignedAdminId,
        "number": number,
        "status": status,
        "reason": reason,
        "openOnQuestStatus": openOnQuestStatus,
        "problemDescription": problemDescription,
        "decisionDescription": decisionDescription,
        "openDisputeUser": openDisputeUser.toJson(),
        "opponentUser": opponentUser.toJson(),
        "assignedAdmin": assignedAdmin?.toJson(),
        "quest": quest.toJson(),
        "currentUserDisputeReview": currentUserDisputeReview!.toJson(),
        "resolveAt": resolveAt?.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
      };
}

class AssignedAdmin {
  AssignedAdmin({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    required this.adminRole,
  });

  String id;
  String? email;
  String firstName;
  String lastName;
  bool? isActive;
  String? adminRole;

  factory AssignedAdmin.fromJson(Map<String, dynamic> json) => AssignedAdmin(
        id: json["id"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        isActive: json["isActive"],
        adminRole: json["adminRole"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "isActive": isActive,
        "adminRole": adminRole,
      };
}

class DisputeUser {
  DisputeUser({
    required this.id,
    required this.avatarId,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.ratingStatistic,
  });

  String id;
  String avatarId;
  String firstName;
  String lastName;
  Avatar? avatar;
  RatingStatistic ratingStatistic;

  factory DisputeUser.fromJson(Map<String, dynamic> json) => DisputeUser(
        id: json["id"],
        avatarId: json["avatarId"] ?? "",
        firstName: json["firstName"],
        lastName: json["lastName"],
        avatar: json["avatar"] == null ? null : Avatar.fromJson(json["avatar"]),
        ratingStatistic: RatingStatistic.fromJson(json["ratingStatistic"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "avatarId": avatarId,
        "firstName": firstName,
        "lastName": lastName,
        "avatar": avatar == null ? null : avatar!.toJson(),
        "ratingStatistic": ratingStatistic.toJson(),
      };
}

class CurrentUserDisputeReview {
  CurrentUserDisputeReview({
    required this.id,
    required this.disputeId,
    required this.fromUserId,
    required this.toAdminId,
    required this.message,
    required this.mark,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String disputeId;
  String fromUserId;
  String toAdminId;
  String message;
  int mark;
  DateTime createdAt;
  DateTime updatedAt;

  factory CurrentUserDisputeReview.fromJson(Map<String, dynamic> json) =>
      CurrentUserDisputeReview(
        id: json["id"],
        disputeId: json["disputeId"],
        fromUserId: json["fromUserId"],
        toAdminId: json["toAdminId"],
        message: json["message"],
        mark: json["mark"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "disputeId": disputeId,
        "fromUserId": fromUserId,
        "toAdminId": toAdminId,
        "message": message,
        "mark": mark,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
