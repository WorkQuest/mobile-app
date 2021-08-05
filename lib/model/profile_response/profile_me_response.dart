import 'package:app/enums.dart';
import 'package:app/model/profile_response/additional_info.dart';
import 'package:app/model/profile_response/avatar.dart';
import 'package:app/model/profile_response/rating_statistic.dart';
import 'package:app/model/profile_response/review.dart';

class ProfileMeResponse {
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
    // required this.reviews,
    // required this.ratingStatistic,
    // required this.createdAt,
    // required this.updatedAt,
  });

  String id;
  String avatarId;
  String firstName;
  String? lastName;
  String? phone;
  String? tempPhone;
  String? email;
  AdditionalInfo? additionalInfo;
  UserRole role;
  Avatar? avatar;

  // List<Review>? reviews;
  //RatingStatistic? ratingStatistic;
  // DateTime createdAt;
  // DateTime updatedAt;

  factory ProfileMeResponse.fromJson(Map<String, dynamic> json) {
    return ProfileMeResponse(
      id: json["id"],
      avatarId: json["avatarId"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      phone: json["phone"],
      tempPhone: json["tempPhone"],
      email: json["email"],
      additionalInfo: json["additionalInfo"] == null
          ? null
          : AdditionalInfo.fromJson(json["additionalInfo"]),
      role: json["role"] == "employer" ? UserRole.Employer : UserRole.Worker,
      avatar: Avatar.fromJson(json["avatar"]),
      // reviews:
      //     List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
      // ratingStatistic: RatingStatistic.fromJson(json["ratingStatistic"]),
      // createdAt: DateTime.parse(json["createdAt"]),
      // updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "avatarId": avatarId,
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "tempPhone": tempPhone,
        "email": email,
        //"additionalInfo": additionalInfo!.toJson(),
        "role": role.toString().split(".").last,
        "avatar": avatar!.toJson(),
        //"reviews": List<dynamic>.from(reviews!.map((x) => x.toJson())),
        // "ratingStatistic": ratingStatistic!.toJson(),
        // "createdAt": createdAt.toIso8601String(),
        // "updatedAt": updatedAt.toIso8601String(),
      };
}
