import 'package:app/model/profile_response/avatar.dart';

class FromUser {
  FromUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  String id;
  String firstName;
  String lastName;
  Avatar? avatar;

  factory FromUser.fromJson(Map<String, dynamic> json) => FromUser(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        avatar: json["avatar"] == null ? null : Avatar.fromJson(json["avatar"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "avatar": avatar,
      };
}
