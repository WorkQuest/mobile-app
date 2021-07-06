import 'package:app/model/profile_response/experience.dart';
import 'package:app/model/profile_response/social_network.dart';

class AdditionalInfo {
  AdditionalInfo({
    required this.firstMobileNumber,
    required this.secondMobileNumber,
    required this.address,
    required this.socialNetwork,
    required this.company,
    required this.ceo,
    required this.website,
    required this.skills,
    required this.educations,
    required this.workExperiences,
    required this.description,
  });

  String firstMobileNumber;
  String? secondMobileNumber;
  String address;
  SocialNetwork socialNetwork;
  String? company;
  String? ceo;
  String? website;
  List<String> skills;
  List<Education> educations;
  List<WorkExperience> workExperiences;
  String? description;

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) => AdditionalInfo(
    firstMobileNumber: json["firstMobileNumber"],
    secondMobileNumber: json["secondMobileNumber"],
    address: json["address"],
    socialNetwork: SocialNetwork.fromJson(json["socialNetwork"]),
    company: json["company"],
    ceo: json["CEO"],
    website: json["website"],
    skills: List<String>.from(json["skills"].map((x) => x)),
    educations: List<Education>.from(json["educations"].map((x) => Education.fromJson(x))),
    workExperiences:
    List<WorkExperience>.from(json["workExperiences"].map((x) => WorkExperience.fromJson(x))),
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "firstMobileNumber": firstMobileNumber,
    "secondMobileNumber": secondMobileNumber,
    "address": address,
    "socialNetwork": socialNetwork.toJson(),
    "company": company,
    "CEO": ceo,
    "website": website,
    "skills": List<String>.from(skills.map((x) => x)),
    "educations": List<Education>.from(educations.map((x) => x.toJson())),
    "workExperiences": List<WorkExperience>.from(workExperiences.map((x) => x.toJson())),
    "description": description,
  };
}