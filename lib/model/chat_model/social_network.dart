class SocialNetwork {
  SocialNetwork({
    required this.instagram,
    required this.twitter,
    required this.linkedin,
    required this.facebook,
  });

  String instagram;
  String twitter;
  String linkedin;
  String facebook;

  factory SocialNetwork.fromJson(Map<String, dynamic> json) => SocialNetwork(
    instagram: json["instagram"],
    twitter: json["twitter"],
    linkedin: json["linkedin"],
    facebook: json["facebook"],
  );

  Map<String, dynamic> toJson() => {
    "instagram": instagram,
    "twitter": twitter,
    "linkedin": linkedin,
    "facebook": facebook,
  };
}