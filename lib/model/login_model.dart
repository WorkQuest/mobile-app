class LoginModel {
  LoginModel({
    required this.userStatus,
    required this.access,
    required this.refresh,
    required this.address,
  });

  int userStatus;
  String access;
  String refresh;
  String? address;

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return LoginModel(
      access: json["access"],
      refresh: json["refresh"],
      address: json["address"],
      userStatus: json["userStatus"],
    );
  }

  Map<String, dynamic> toJson() => {
        "userStatus": userStatus,
        "access": access,
        "refresh": refresh,
        "address": address,
      };
}
