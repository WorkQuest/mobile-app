import 'package:app/model/profile_response/avatar.dart';
import 'package:app/model/profile_response/profile_me_response.dart';

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.ratingStatistic,
  });

  String id;
  String firstName;
  String lastName;
  Avatar avatar;
  RatingStatistic? ratingStatistic;

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        avatar: Avatar.fromJson(json["avatar"]),
        ratingStatistic: json["ratingStatistic"] == null
            ? null
            : RatingStatistic.fromJson(json["ratingStatistic"]),
      );
    } catch (e, tr) {
      throw Exception("User don't parse $e $tr");
    }
  }
}
