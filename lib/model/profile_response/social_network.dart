class SocialNetwork {
  SocialNetwork({
    this.instagram,
    this.twitter,
    this.linkedin,
    this.facebook,
  });

  String? instagram;
  String? twitter;
  String? linkedin;
  String? facebook;

  SocialNetwork copyWith({
    String? instagram,
    String? twitter,
    String? linkedin,
    String? facebook,
  }) =>
      SocialNetwork(
        instagram: instagram ?? this.instagram,
        twitter: twitter ?? this.twitter,
        linkedin: linkedin ?? this.linkedin,
        facebook: facebook ?? this.facebook,
      );

  factory SocialNetwork.fromJson(Map<String, dynamic> json) => SocialNetwork(
        instagram: json["instagram"],
        twitter: json["twitter"],
        linkedin: json["linkedin"],
        facebook: json["facebook"],
      );

  SocialNetwork.clone(SocialNetwork object)
      : this(
          instagram: object.instagram,
          twitter: object.twitter,
          linkedin: object.linkedin,
          facebook: object.facebook,
        );

  Map<String, dynamic> toJson() => {
        "instagram": instagram,
        "twitter": twitter,
        "linkedin": linkedin,
        "facebook": facebook,
      };
}
