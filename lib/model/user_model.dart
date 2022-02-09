import 'package:app/model/profile_response/avatar.dart';

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  String id;
  String firstName;
  String lastName;
  Avatar avatar;

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        avatar: Avatar.fromJson(json["avatar"]),
      );
    } catch (e) {
      throw Exception("User don't parse");
    }
  }
}
