class BearerToken {
  String access;
  String refresh;
  int status;
  bool? totpIsActive;
  String? address;

  BearerToken({
    required this.access,
    required this.refresh,
    required this.status,
    this.totpIsActive,
    this.address,
  });

  factory BearerToken.fromJson(Map<String, dynamic> json) {
    return BearerToken(
      status: json["userStatus"],
      access: json["access"],
      refresh: json["refresh"],
      totpIsActive: json["totpIsActive"] == null ? null : json["totpIsActive"],
      address: json["address"] == null ? null : json["address"],
    );
  }

  Map<String, dynamic> toJson() => {
        "userStatus": status,
        "access": access,
        "refresh": refresh,
        "totpIsActive": totpIsActive,
        "address": address,
      };
}
