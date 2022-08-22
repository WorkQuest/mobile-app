class LoginModel {
  LoginModel({
    required this.userStatus,
    required this.access,
    required this.refresh,
  });

  int userStatus;
  String access;
  String refresh;

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      access: json["access"],
      refresh: json["refresh"],
      userStatus: json["userStatus"],
    );
  }

  Map<String, dynamic> toJson() => {
        "userStatus": userStatus,
        "access": access,
        "refresh": refresh,
      };
}
