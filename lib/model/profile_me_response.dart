class ProfileMeResponse {

  ProfileMeResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
  });

  String id;
  String firstName;
  String lastName;
  String email;
  String role;

  factory ProfileMeResponse.fromJson(Map<String, dynamic> json) =>
      ProfileMeResponse(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "role": role,
      };
}
