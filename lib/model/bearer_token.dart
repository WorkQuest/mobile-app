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
      status: json["userStatus"]?? 232323142342342312,
      access: json["access"],
      refresh: json["refresh"],
    );
  }

  Map<String, dynamic> toJson() => {
    "userStatus": status,
    "access": access,
    "refresh": refresh,
  };
}
