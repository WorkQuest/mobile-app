import 'package:app/model/profile_response/additional_info.dart';

class AssignedWorker {
  AssignedWorker({
    required this.firstName,
    required this.lastName,
    required this.additionalInfo,
  });

  String firstName;
  String lastName;
  AdditionalInfo additionalInfo;

  factory AssignedWorker.fromJson(Map<String, dynamic> json) => AssignedWorker(
        firstName: json["firstName"],
        lastName: json["lastName"] ?? "",
        additionalInfo: AdditionalInfo.fromJson(json["additionalInfo"]),
      );
}
