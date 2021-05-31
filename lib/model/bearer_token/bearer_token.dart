class BearerToken {
  String access;
  String refresh;
  int status;

  BearerToken({
    required this.access,
    required this.refresh,
    required this.status,
  });

  factory BearerToken.fromJson(Map<String, dynamic> json) {
    return BearerToken(
      status: json["status"],
      access: json["access"],
      refresh: json["refresh"],
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "access": access,
    "refresh": refresh,
  };
}
