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
  String avatar;

  factory FromUser.fromJson(Map<String, dynamic> json) => FromUser(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        avatar: json["avatar"] ??
            "https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "avatar": avatar,
      };
}