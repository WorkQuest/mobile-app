import 'package:app/enums.dart';
import 'package:app/model/profile_response/additional_info.dart';
import 'package:app/model/profile_response/avatar.dart';
// import 'package:app/model/profile_response/rating_statistic.dart';

class ProfileMeResponse {
  ProfileMeResponse({
    required this.id,
    required this.avatarId,
    required this.firstName,
    required this.lastName,
    // required this.phone,
    required this.tempPhone,
    required this.email,
    required this.additionalInfo,
    required this.role,
    required this.avatar,
    required this.userSpecializations,
    required this.ratingStatistic,
    required this.location,
    required this.wagePerHour,
    required this.workplace,
    required this.priority,
    required this.questsStatistic,
    // required this.createdAt,
    // required this.updatedAt,
  });

  String id;
  String avatarId;
  String firstName;
  String lastName;
  // Phone? phone;
  Phone? tempPhone;
  String? email;
  AdditionalInfo? additionalInfo;
  UserRole role;
  Avatar? avatar;
  List<String> userSpecializations;
  RatingStatistic? ratingStatistic;
  Location? location;
  String wagePerHour;
  String? workplace;
  QuestPriority priority;
  QuestsStatistic? questsStatistic;

  ProfileMeResponse.clone(ProfileMeResponse object)
      : this(
          id: object.id,
          avatarId: object.avatarId,
          firstName: object.firstName,
          lastName: object.lastName,
          // phone: object.phone,
          tempPhone: object.tempPhone,
          email: object.email,
          additionalInfo: object.additionalInfo != null
              ? AdditionalInfo.clone(object.additionalInfo!)
              : null,
          role: object.role,
          avatar: object.avatar,
          userSpecializations: object.userSpecializations,
          ratingStatistic: object.ratingStatistic != null
              ? RatingStatistic.clone(object.ratingStatistic!)
              : null,
          location:
              object.location != null ? Location.clone(object.location!) : null,
          wagePerHour: object.wagePerHour,
          workplace: object.workplace,
          priority: object.priority,
          questsStatistic: object.questsStatistic,
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
      // phone: json["phone"] == null ? null : Phone.fromJson(json["phone"]),
      tempPhone: json["tempPhone"] == null ? null : Phone.fromJson(json["tempPhone"]),
      email: json["email"],
      additionalInfo: json["additionalInfo"] == null
          ? null
          : AdditionalInfo.fromJson(json["additionalInfo"]),
      role: json["role"] == "employer" ? UserRole.Employer : UserRole.Worker,
      avatar: Avatar.fromJson(json["avatar"]),
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
            "status": "",
            // createdAt: createdAt,
            // updatedAt: updatedAt,
          }),
      location:
          json["location"] == null ? null : Location.fromJson(json["location"]),
      wagePerHour: json["wagePerHour"] ?? "0",
      workplace: json["workplace"],
      priority: QuestPriority.values[json["priority"] ?? 0],
      questsStatistic: json["questsStatistic"] == null
          ? null
          : QuestsStatistic.fromJson(json["questsStatistic"]),
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
        "ratingStatistic":
            ratingStatistic == null ? null : ratingStatistic!.toJson(),
        "location": location == null ? null : location!.toJson(),
        "wagePerHour": wagePerHour,
        "workplace": workplace,
        "priority": priority.index,
        "questsStatistic": questsStatistic,
        // "createdAt": createdAt.toIso8601String(),
        // "updatedAt": updatedAt.toIso8601String(),
      };
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

  factory QuestsStatistic.fromJson(Map<String, dynamic> json) =>
      QuestsStatistic(
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

class Location {
  Location({
    required this.longitude,
    required this.latitude,
  });

  double longitude;
  double latitude;

  Location.clone(Location object)
      : this(longitude: object.longitude, latitude: object.latitude);

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json["latitude"] == 0 ? 0.0 : json["latitude"],
      longitude: json["longitude"] == 0 ? 0.0 : json["longitude"],
    );
  }

  Map<String, double> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
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
  String status;

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
    return RatingStatistic(
      id: json["id"],
      userId: json["userId"],
      reviewCount: json["reviewCount"],
      averageMark:
          json["averageMark"] == null ? 0.0 : json["averageMark"].toDouble(),
      status: json["status"],
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
