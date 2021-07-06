import 'package:app/enums.dart';
import 'package:app/model/profile_response/additional_info.dart';
import 'package:app/model/profile_response/avatar.dart';
import 'package:app/model/profile_response/rating_statistic.dart';
import 'package:app/model/profile_response/review.dart';

class ProfileMeResponse {
  ProfileMeResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.avatarId,
    required this.additionalInfo,
    required this.avatar,
    //required this.reviews,
    //required this.ratingStatistic,
     //required this.createdAt,
    //required this.updatedAt,
  });

  String id;
  String firstName;
  String lastName;
  String email;
  UserRole role;
  String avatarId;
  AdditionalInfo additionalInfo;
  Avatar avatar;
  //List<Review> reviews;
  //RatingStatistic ratingStatistic;
  //DateTime createdAt;
  //DateTime updatedAt;

  factory ProfileMeResponse.fromJson(Map<String, dynamic> json) {
    return ProfileMeResponse(
      id: json["id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      role: json["role"] == "employer" ? UserRole.Employer : UserRole.Worker,
      avatarId: json["avatarId"],
      additionalInfo: AdditionalInfo.fromJson(json["additionalInfo"]),
      avatar: Avatar.fromJson(json["avatar"]),
      // reviews:
      //     List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
      //ratingStatistic: RatingStatistic.fromJson(json["ratingStatistic"]),
      //createdAt: DateTime.parse(json["createdAt"]),
      //updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "role": role.toString().split(".").last,
        "avatarId": avatarId,
        "additionalInfo": additionalInfo.toJson(),
        "avatar": avatar.toJson(),
        //"reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
        //"ratingStatistic": ratingStatistic.toJson(),
        //"createdAt": createdAt.toIso8601String(),
        //"updatedAt": updatedAt.toIso8601String(),
      };
}