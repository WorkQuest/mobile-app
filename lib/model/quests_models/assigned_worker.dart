import 'package:app/model/profile_response/avatar.dart';

class AssignedWorker {
  AssignedWorker({
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.id,
  });

  String firstName;
  String lastName;
  Avatar? avatar;
  String id;

  factory AssignedWorker.fromJson(Map<String, dynamic> json) => AssignedWorker(
        firstName: json["firstName"],
        lastName: json["lastName"] ?? "",
        avatar: json["avatar"] == null ? null : Avatar.fromJson(json["avatar"]),
        id: json["id"],
      );
}
