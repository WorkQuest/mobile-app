import 'package:app/enums.dart';
import 'package:app/model/profile_response/additional_info.dart';
import 'package:app/model/profile_response/avatar.dart';
import 'package:app/model/quests_models/location_full.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfileMeResponse with ClusterItem {
  ProfileMeResponse({
    required this.id,
    required this.avatarId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.tempPhone,
    required this.email,
    required this.additionalInfo,
    required this.role,
    required this.avatar,
    required this.userSpecializations,
    required this.ratingStatistic,
    required this.locationCode,
    required this.locationPlaceName,
    required this.wagePerHour,
    required this.workplace,
    required this.priority,
    required this.questsStatistic,
    this.raiseView,
    required this.walletAddress,
    required this.workerOrEmployerProfileVisibilitySetting,
    required this.isTotpActive,
    required this.payPeriod,
    // required this.createdAt,
    // required this.updatedAt,
  });

  String id;
  String avatarId;
  String firstName;
  String lastName;

  Phone? phone;
  Phone? tempPhone;
  String? email;
  AdditionalInfo? additionalInfo;
  UserRole role;
  Avatar? avatar;
  List<String> userSpecializations;
  RatingStatistic? ratingStatistic;
  LocationCode? locationCode;
  String? locationPlaceName;
  String wagePerHour;
  String? workplace;
  int priority;
  QuestsStatistic? questsStatistic;
  RaiseView? raiseView;
  WorkerProfileVisibilitySettingClass? workerOrEmployerProfileVisibilitySetting;
  String? walletAddress;
  bool? isTotpActive;
  bool showAnimation = true;
  String? payPeriod;

  ProfileMeResponse.clone(ProfileMeResponse object)
      : this(
          id: object.id,
          avatarId: object.avatarId,
          firstName: object.firstName,
          lastName: object.lastName,
          phone: object.phone,
          tempPhone: object.tempPhone,
          email: object.email,
          additionalInfo: object.additionalInfo != null ? AdditionalInfo.clone(object.additionalInfo!) : null,
          role: object.role,
          avatar: object.avatar,
          userSpecializations: object.userSpecializations,
          ratingStatistic: object.ratingStatistic != null ? RatingStatistic.clone(object.ratingStatistic!) : null,
          locationCode: object.locationCode != null ? LocationCode.clone(object.locationCode!) : null,
          locationPlaceName: object.locationPlaceName,
          wagePerHour: object.wagePerHour,
          workplace: object.workplace,
          priority: object.priority,
          questsStatistic: object.questsStatistic,
          walletAddress: object.walletAddress,
    workerOrEmployerProfileVisibilitySetting: object.workerOrEmployerProfileVisibilitySetting,
          isTotpActive: object.isTotpActive,
          payPeriod: object.payPeriod,
        );

  //RatingStatistic? ratingStatistic;
  // DateTime createdAt;
  // DateTime updatedAt;

  factory ProfileMeResponse.fromJson(Map<String, dynamic> json) {
    return ProfileMeResponse(
      id: json["id"],
      avatarId: json["avatarId"] ?? "",
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      phone: json["phone"] == null
          ? null
          : Phone.fromJson(
              json["phone"] ??
                  {
                    "codeRegion": "",
                    "fullPhone": "",
                    "phone": "",
                  },
            ),
      tempPhone: Phone.fromJson(
        json["tempPhone"] ??
            {
              "codeRegion": "",
              "fullPhone": "",
              "phone": "",
            },
      ),
      email: json["email"],
      additionalInfo: json["additionalInfo"] == null ? null : AdditionalInfo.fromJson(json["additionalInfo"]),
      role: json["role"] == "employer" ? UserRole.Employer : UserRole.Worker,
      avatar: json["avatar"] == null ? null : Avatar.fromJson(json["avatar"]),
      userSpecializations: json["userSpecializations"] == null
          ? []
          : (List<Map<String, dynamic>> skills) {
              List<String> skillsString = [];
              for (var skill in skills) {
                skillsString.add(skill.values.toString());
              }
              return skillsString;
            }([...json["userSpecializations"]]),
      ratingStatistic: RatingStatistic.fromJson(json["ratingStatistic"] ??
          {
            "id": "",
            "userId": json["id"],
            "reviewCount": 0,
            "averageMark": 0,
            "status": 3,
            // createdAt: createdAt,
            // updatedAt: updatedAt,
          }),
      locationCode: json["location"] == null ? null : LocationCode.fromJson(json["location"]),
      locationPlaceName: json["locationPlaceName"] ?? "",
      wagePerHour: json["wagePerHour"] ?? "0",
      workplace: json["workplace"] ?? "",
      priority: json["priority"] ?? 0,
      questsStatistic: json["questsStatistic"] == null ? null : QuestsStatistic.fromJson(json["questsStatistic"]),
      raiseView: json["raiseView"] == null ? null : RaiseView.fromJson(json["raiseView"]),
      walletAddress: json["wallet"]?["address"] ?? '',
      isTotpActive: json["totpIsActive"] == null ? false : json["totpIsActive"],
      payPeriod: json["payPeriod"] ?? "",
      workerOrEmployerProfileVisibilitySetting:
          json[json["role"] == "employer" ? 'employerProfileVisibilitySetting' : 'workerProfileVisibilitySetting'] ==
                  null
              ? null
              : WorkerProfileVisibilitySettingClass.fromJson(json[json["role"] == "employer" ? 'employerProfileVisibilitySetting' : 'workerProfileVisibilitySetting']),
      // createdAt: DateTime.parse(json["createdAt"]),
      // updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "avatarId": avatarId,
        "firstName": firstName,
        "lastName": lastName,
        // "phone": phone,
        "tempPhone": tempPhone,
        "email": email,
        //"additionalInfo": additionalInfo!.toJson(),
        "role": role.toString().split(".").last,
        "avatar": avatar!.toJson(),
        // "skillFilter": skillFilters.map((item) => item.toJson()),
        "ratingStatistic": ratingStatistic == null ? null : ratingStatistic!.toJson(),
        "location": locationCode == null ? null : locationCode!.toJson(),
        "locationPlaceName": locationPlaceName,
        "wagePerHour": wagePerHour,
        "workplace": workplace,
        "priority": priority,
        "questsStatistic": questsStatistic,
        "payPeriod": payPeriod,
        "workerOrEmployerProfileVisibilitySetting": workerOrEmployerProfileVisibilitySetting,

        // "createdAt": createdAt.toIso8601String(),
        // "updatedAt": updatedAt.toIso8601String(),
      };

  @override
  // TODO: implement location
  LatLng get location => LatLng(locationCode!.latitude, locationCode!.longitude);

  List<int> getMySearchVisibilityList() {
    return workerOrEmployerProfileVisibilitySetting?.arrayRatingStatusInMySearch ?? [];
  }

  List<int> getCanInviteOrRespondMeOnQuest() {
    if (role == UserRole.Worker) {
      return workerOrEmployerProfileVisibilitySetting?.arrayRatingStatusCanInviteMeOnQuest ?? [];
    } else {
      return workerOrEmployerProfileVisibilitySetting?.arrayRatingStatusCanRespondToQuest ?? [];
    }
  }
}

class QuestsStatistic {
  QuestsStatistic({
    required this.completed,
    required this.opened,
  });

  int completed;
  int opened;

  QuestsStatistic.clone(QuestsStatistic object)
      : this(
          completed: object.completed,
          opened: object.opened,
        );

  factory QuestsStatistic.fromJson(Map<String, dynamic> json) => QuestsStatistic(
        completed: json["completed"],
        opened: json["opened"],
      );
}

class UserSkillFilters {
  UserSkillFilters({
    required this.category,
    required this.skill,
  });

  String category;
  String skill;

  UserSkillFilters.clone(UserSkillFilters object)
      : this(
          category: object.category,
          skill: object.skill,
        );

  factory UserSkillFilters.fromJson(Map<String, dynamic> json) {
    return UserSkillFilters(
      category: json["category"],
      skill: json["skill"],
    );
  }

  Map<String, String> toJson() => {
        "category": category,
        "skill": skill,
      };
}

class RatingStatistic {
  RatingStatistic({
    required this.id,
    required this.userId,
    required this.reviewCount,
    required this.averageMark,
    required this.status,
    // required this.createdAt,
    // required this.updatedAt,
  });

  String id;
  String userId;
  int reviewCount;
  double averageMark;
  int status;

  // String createdAt;
  // String updatedAt;

  RatingStatistic.clone(RatingStatistic object)
      : this(
          id: object.id,
          userId: object.userId,
          reviewCount: object.reviewCount,
          averageMark: object.averageMark,
          status: object.status,
          // createdAt: object.createdAt,
          // updatedAt: object.updatedAt,
        );

  factory RatingStatistic.fromJson(Map<String, dynamic> json) {
    int? status;

    status = json["status"];

    return RatingStatistic(
      id: json["id"],
      userId: json["userId"],
      reviewCount: json["reviewCount"],
      averageMark: json["averageMark"] == null ? 0.0 : json["averageMark"].toDouble(),
      status: status ?? 3,
      // createdAt: json["createdAt"],
      // updatedAt: json["updatedAt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "reviewCount": reviewCount,
        "averageMark": averageMark,
        "status": status,
        // "createdAt": createdAt,
        // "updatedAt": updatedAt,
      };
}

class Phone {
  Phone({
    required this.phone,
    required this.fullPhone,
    required this.codeRegion,
  });

  String phone;
  String fullPhone;
  String codeRegion;

  Phone.clone(Phone object)
      : this(
          phone: object.phone,
          fullPhone: object.fullPhone,
          codeRegion: object.codeRegion,
        );

  factory Phone.fromJson(Map<String, dynamic> json) {
    return Phone(
      phone: json["phone"],
      fullPhone: json["fullPhone"],
      codeRegion: json["codeRegion"],
    );
  }

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "fullPhone": fullPhone,
        "codeRegion": codeRegion,
      };
}

class RaiseView {
  RaiseView({
    this.id,
    this.userId,
    this.status,
    this.duration,
    this.type,
    this.endedAt,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? userId;
  int? status;
  int? duration;
  int? type;
  DateTime? endedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory RaiseView.fromJson(Map<String, dynamic> json) => RaiseView(
        id: json["id"] == null ? null : json["id"],
        userId: json["userId"] == null ? null : json["userId"],
        status: json["status"] == null ? null : json["status"],
        duration: json["duration"] == null ? null : json["duration"],
        type: json["type"] == null ? null : json["type"],
        endedAt: json["endedAt"] == null ? null : DateTime.parse(json["endedAt"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "userId": userId == null ? null : userId,
        "status": status == null ? null : status,
        "duration": duration == null ? null : duration,
        "type": type == null ? null : type,
        "endedAt": endedAt == null ? null : endedAt!.toIso8601String(),
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}

class WorkerProfileVisibilitySettingClass {
  WorkerProfileVisibilitySettingClass({
    this.arrayRatingStatusCanInviteMeOnQuest,
    this.arrayRatingStatusCanRespondToQuest,
    this.arrayRatingStatusInMySearch,
    this.id,
    this.userId,
    this.ratingStatusCanInviteMeOnQuest,
    this.ratingStatusInMySearch,
    this.createdAt,
    this.updatedAt,
  });

  List<int>? arrayRatingStatusCanInviteMeOnQuest;
  List<int>? arrayRatingStatusCanRespondToQuest;
  List<int>? arrayRatingStatusInMySearch;
  String? id;
  String? userId;
  int? ratingStatusCanInviteMeOnQuest;
  int? ratingStatusInMySearch;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory WorkerProfileVisibilitySettingClass.fromJson(Map<String, dynamic> json) =>
      WorkerProfileVisibilitySettingClass(
        arrayRatingStatusCanInviteMeOnQuest: json["arrayRatingStatusCanInviteMeOnQuest"] == null
            ? null
            : List<int>.from(json["arrayRatingStatusCanInviteMeOnQuest"].map((x) => x)),
        arrayRatingStatusCanRespondToQuest: json["arrayRatingStatusCanRespondToQuest"] == null
            ? null
            : List<int>.from(json["arrayRatingStatusCanRespondToQuest"].map((x) => x)),
        arrayRatingStatusInMySearch: json["arrayRatingStatusInMySearch"] == null
            ? null
            : List<int>.from(json["arrayRatingStatusInMySearch"].map((x) => x)),
        id: json["id"] == null ? null : json["id"],
        userId: json["userId"] == null ? null : json["userId"],
        ratingStatusCanInviteMeOnQuest:
            json["ratingStatusCanInviteMeOnQuest"] == null ? null : json["ratingStatusCanInviteMeOnQuest"],
        ratingStatusInMySearch: json["ratingStatusInMySearch"] == null ? null : json["ratingStatusInMySearch"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );
}
