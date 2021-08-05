class Avatar {
  Avatar({
    required this.id,
    required this.url,
  });

  String? id;
  String url;

  factory Avatar.fromJson(Map<String, dynamic>? json) => Avatar(
        id: json?["id"] ?? "kakoi-to avatar",
        url: json?["url"] ?? "https://rembitteh.ru/Media/images/hozyayke-na-zametku/televizory/zvuk-est-izobrazhenia-net.jpg",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}
