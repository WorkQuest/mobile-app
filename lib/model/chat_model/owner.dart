import 'package:app/model/profile_response/additional_info.dart';
import 'package:app/model/profile_response/avatar.dart';

class Owner {
  Owner({
    required this.id,
    required this.avatarId,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.additionalInfo,
  });

  String id;
  String? avatarId;
  String firstName;
  String lastName;
  Avatar avatar;
  AdditionalInfo additionalInfo;

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
        id: json["id"],
        avatarId: json["avatarId"] == null ? null : json["avatarId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        avatar: Avatar.fromJson(
          json["avatar"] ??
              {
                "id": "",
                "url":
                    "https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs",
                "contentType": "",
              },
        ),
        additionalInfo: AdditionalInfo.fromJson(json["additionalInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "avatarId": avatarId,
        "firstName": firstName,
        "lastName": lastName,
        "avatar": avatar.toJson(),
        "additionalInfo": additionalInfo.toJson(),
      };
}
