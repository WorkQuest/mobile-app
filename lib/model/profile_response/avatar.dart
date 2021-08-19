class Avatar {
  Avatar({
    required this.id,
    required this.url,
  });

  String? id;
  String url;

  factory Avatar.fromJson(Map<String, dynamic>? json) => Avatar(
        id: json?["id"] ?? "",
        url: json?["url"] ??
            "https://workquest-cdn.fra1.digitaloceanspaces.com/sUYNZfZJvHr8fyVcrRroVo8PpzA5RbTghdnP0yEcJuIhTW26A5vlCYG8mZXs",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}
