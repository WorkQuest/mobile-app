class Avatar {
  Avatar({
    required this.id,
    required this.url,
  });

  String? id;
  String url;

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
        id: json["id"] ?? "kakoi-to avatar",
        url: json["url"] ?? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fpuzzlefactory.pl%2Fen%2Fpuzzle%2Fplay%2Ffor-kids%2F335393-stitch_lilo-and-stitch&psig=AOvVaw2OU36Xbqn7_ZDnJ0e8MGVT&ust=1627370973411000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCOjFjLmbgPICFQAAAAAdAAAAABAH",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}
