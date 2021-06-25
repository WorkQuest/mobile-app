
class User {
  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.status,
    required this.statusKyc,
    // required this.deletedAt,
    // required this.avatar,
    // required this.ratingStatistic,
  });

  String id;
  String email;
  String firstName;
  String lastName;
  String role;
  int status;
  int statusKyc;
  // dynamic deletedAt;
  // String avatar;
  // dynamic ratingStatistic;

  factory User.fromJson(Map<String, dynamic> json) =>
      User(
        id: json["id"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        role: json["role"],
        status: json["status"],
        statusKyc: json["statusKYC"],
        // deletedAt: json["deletedAt"],
        // avatar: json["avatar"],
        // ratingStatistic: json["ratingStatistic"],
      );
}