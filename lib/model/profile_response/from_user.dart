import 'package:app/enums.dart';
import 'package:app/model/profile_response/avatar.dart';

class FromUser {
  FromUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.role,
  });

  String id;
  String firstName;
  String lastName;
  Avatar? avatar;
  UserRole role;

  factory FromUser.fromJson(Map<String, dynamic> json) => FromUser(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        avatar: json["avatar"] == null ? null : Avatar.fromJson(json["avatar"]),
        role: json["role"] == "quest_worker_page" ? UserRole.Worker : UserRole.Employer,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "avatar": avatar,
      };
}
