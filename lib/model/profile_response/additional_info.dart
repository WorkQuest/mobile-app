import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/profile_response/social_network.dart';

import 'avatar.dart';

class AdditionalInfo {
  AdditionalInfo({
    this.secondMobileNumber,
    this.address,
    this.socialNetwork,
    this.description,
    this.company,
    this.ceo,
    this.website,
    this.skills,
    this.educations = const [],
    this.workExperiences = const [],
    this.avatar,
  });

  Phone? secondMobileNumber;
  String? address;
  SocialNetwork? socialNetwork;
  String? description;
  String? company;
  String? ceo;
  String? website;
  List<String>? skills;
  List<Map<String, String>> educations;
  List<Map<String, String>> workExperiences;

  Avatar? avatar;

  AdditionalInfo copyWith({
    Phone? secondMobileNumber,
    String? address,
    SocialNetwork? socialNetwork,
    String? description,
    String? company,
    String? ceo,
    String? website,
    List<String>? skills,
    List<Map<String, String>>? educations,
    List<Map<String, String>>? workExperiences,
    Avatar? avatar,
  }) =>
      AdditionalInfo(
        secondMobileNumber: secondMobileNumber,
        address: address ?? this.address,
        socialNetwork: socialNetwork ?? this.socialNetwork,
        description: description ?? this.description,
        company: company ?? this.company,
        ceo: ceo ?? this.ceo,
        website: website ?? this.website,
        skills: skills ?? this.skills,
        educations: educations ?? this.educations,
        workExperiences: workExperiences ?? this.workExperiences,
        avatar: avatar ?? this.avatar,
      );

  AdditionalInfo.clone(AdditionalInfo object)
      : this(
          secondMobileNumber: object.secondMobileNumber,
          address: object.address,
          socialNetwork: object.socialNetwork != null ? SocialNetwork.clone(object.socialNetwork!) : null,
          description: object.description,
          company: object.company,
          ceo: object.ceo,
          website: object.website,
          skills: object.skills,
          educations: object.educations,
          workExperiences: object.workExperiences,
          avatar: object.avatar,
        );

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) {
    return AdditionalInfo(
      secondMobileNumber: json["secondMobileNumber"] == null ? null : Phone.fromJson(json["secondMobileNumber"]),
      address: json["address"],
      socialNetwork: json["socialNetwork"] == null ? null : SocialNetwork.fromJson(json["socialNetwork"]),
      company: json["company"],
      ceo: json["CEO"],
      website: json["website"],
      skills: json["skills"] == null
          ? List.empty()
          : List<String>.from(
              json["skills"].map((x) => x),
            ),
      educations: json["educations"] != null
          ? List<Map<String, String>>.from(json["educations"].map((item) {
              Map<String, String> newItem = {};
              item.keys.forEach((element) {
                newItem[element] = item[element].toString();
              });
              return newItem;
            })).toList()
          : [],
      workExperiences: json["educations"] != null
          ? List<Map<String, String>>.from(json["workExperiences"].map((item) {
              Map<String, String> newItem1 = {};
              item.keys.forEach((element) {
                newItem1[element] = item[element].toString();
              });
              return newItem1;
            })).toList()
          : [],
      description: json["description"],
      avatar: json["avatar"] == null ? null : Avatar.fromJson(json["avatar"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "secondMobileNumber": secondMobileNumber,
        "address": address,
        "socialNetwork": socialNetwork!.toJson(),
        "company": company,
        "CEO": ceo,
        "website": website,
        "skills": List<String>.from(skills!.map((x) => x)),
        "educations": educations,
        "workExperiences": workExperiences,
        "description": description,
      };
}
