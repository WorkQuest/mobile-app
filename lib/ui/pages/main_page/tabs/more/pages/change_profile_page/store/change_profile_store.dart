import 'dart:io';

import 'package:app/enums.dart';
import 'package:app/keys.dart';
import 'package:app/model/profile_response/additional_info.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/profile_response/social_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';

part 'change_profile_store.g.dart';

class ChangeProfileStore = ChangeProfileStoreBase with _$ChangeProfileStore;

abstract class ChangeProfileStoreBase with Store {
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Keys.googleKey);

  ChangeProfileStoreBase(this.userData);

  @observable
  ProfileMeResponse userData;

  @observable
  File? media;

  @observable
  String address = "";

  @observable
  PhoneNumber? phoneNumber;

  @observable
  PhoneNumber? secondPhoneNumber;

  @observable
  PhoneNumber? oldPhoneNumber;

  @action
  setFirstName(String value) => this.userData = userData.copyWith(firstName: value);

  @action
  setLastName(String value) => this.userData = userData.copyWith(lastName: value);

  @action
  setPhoneNumber(PhoneNumber phone) {
    this.phoneNumber = phone;
    userData.phone = Phone.fromPhoneNumber(phone);
  }

  @action
  setSecondPhoneNumber(PhoneNumber phone) {
    this.secondPhoneNumber = phone;
    userData.tempPhone = Phone.fromPhoneNumber(phone);
  }

  @action
  setEmail(String value) => this.userData = userData.copyWith(email: value);

  @action
  setDescription(String value) {
    this.userData = userData.copyWith(
      additionalInfo: (userData.additionalInfo ?? AdditionalInfo()).copyWith(description: value),
    );
  }

  /// Field for employer
  @action
  setCompanyName(String value) {
    this.userData = userData.copyWith(
      additionalInfo: (userData.additionalInfo ?? AdditionalInfo()).copyWith(company: value),
    );
  }

  /// Field for employer
  @action
  setCeo(String value) {
    this.userData = userData.copyWith(
      additionalInfo: (userData.additionalInfo ?? AdditionalInfo()).copyWith(ceo: value),
    );
  }

  /// Field for employer
  @action
  setWebsite(String value) {
    this.userData = userData.copyWith(
      additionalInfo: (userData.additionalInfo ?? AdditionalInfo()).copyWith(website: value),
    );
  }

  /// Field for worker
  @action
  setPriority(int value) => this.userData = userData.copyWith(priority: value);

  /// Field for worker
  @action
  setPerHour(String value) => this.userData = userData.copyWith(costPerHour: value);

  /// Field for worker
  @action
  setWorkplace(String value) => this.userData = userData.copyWith(workplace: value);

  /// Field for worker
  @action
  setPayPeriod(String value) => this.userData = userData.copyWith(payPeriod: value);

  @action
  setTwitter(String value) {
    this.userData = userData.copyWith(
      additionalInfo: (userData.additionalInfo ?? AdditionalInfo()).copyWith(
        socialNetwork: (userData.additionalInfo?.socialNetwork ?? SocialNetwork()).copyWith(
          twitter: value,
        ),
      ),
    );
  }

  @action
  setFacebook(String value) {
    this.userData = userData.copyWith(
      additionalInfo: (userData.additionalInfo ?? AdditionalInfo()).copyWith(
        socialNetwork: (userData.additionalInfo?.socialNetwork ?? SocialNetwork()).copyWith(
          facebook: value,
        ),
      ),
    );
  }

  @action
  setLinkedIn(String value) {
    this.userData = userData.copyWith(
      additionalInfo: (userData.additionalInfo ?? AdditionalInfo()).copyWith(
        socialNetwork: (userData.additionalInfo?.socialNetwork ?? SocialNetwork()).copyWith(
          linkedin: value,
        ),
      ),
    );
  }

  @action
  setInstagram(String value) {
    this.userData = userData.copyWith(
      additionalInfo: (userData.additionalInfo ?? AdditionalInfo()).copyWith(
        socialNetwork: (userData.additionalInfo?.socialNetwork ?? SocialNetwork()).copyWith(
          instagram: value,
        ),
      ),
    );
  }


  @action
  setUserData(ProfileMeResponse value) {
    this.userData = value;
  }

  @action
  Future<Null> getPrediction(BuildContext context) async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: Keys.googleKey,
      mode: Mode.overlay,
      logo: SizedBox(),
    );
    if (p != null) {
      address = p.description!;
      userData = userData.copyWith(locationPlaceName: p.description!);
    }
  }

  @action
  Future<void> getInitCode(Phone firstPhone, Phone? secondPhone) async {
    if (firstPhone.fullPhone.isNotEmpty) {
      phoneNumber = await PhoneNumber.getRegionInfoFromPhoneNumber(firstPhone.fullPhone);
      oldPhoneNumber = await PhoneNumber.getRegionInfoFromPhoneNumber(firstPhone.fullPhone);
    }
    if (secondPhone != null)
      secondPhoneNumber = await PhoneNumber.getRegionInfoFromPhoneNumber(secondPhone.fullPhone);
    else
      userData.additionalInfo?.secondMobileNumber = Phone(phone: "", fullPhone: "", codeRegion: "");

    phoneNumber ??= PhoneNumber(phoneNumber: "", dialCode: "+1", isoCode: "US");
    secondPhoneNumber ??= PhoneNumber(phoneNumber: "", dialCode: "+1", isoCode: "US");
    oldPhoneNumber ??= PhoneNumber(dialCode: '+1', isoCode: "US");
  }

  @action
  Future<Null> displayPrediction(String? p) async {
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p!);
    userData.locationCode!.latitude = detail.result.geometry!.location.lat;
    userData.locationCode!.longitude = detail.result.geometry!.location.lng;
    userData.locationPlaceName = address;
    userData.additionalInfo?.address = address;
  }

  void savePhoneNumber() {
    if (userData.tempPhone == null) {
      userData.tempPhone = Phone(
        codeRegion: phoneNumber?.dialCode ?? "",
        fullPhone: phoneNumber?.phoneNumber ?? "",
        phone: phoneNumber?.phoneNumber?.replaceAll((phoneNumber?.dialCode ?? ""), "") ?? "",
      );
    } else {
      userData.tempPhone!.codeRegion = phoneNumber?.dialCode ?? "";
      userData.tempPhone!.phone = phoneNumber!.phoneNumber!.replaceAll((phoneNumber?.dialCode ?? ""), "");
      userData.tempPhone!.fullPhone = phoneNumber?.phoneNumber ?? "";
    }
  }

  void saveSecondPhoneNumber() {
    if ((secondPhoneNumber?.phoneNumber ?? "").isEmpty) return;
    if (userData.additionalInfo?.secondMobileNumber == null) {
      userData.additionalInfo?.secondMobileNumber = Phone(
        codeRegion: secondPhoneNumber?.dialCode ?? "",
        fullPhone: secondPhoneNumber?.phoneNumber ?? "",
        phone: secondPhoneNumber?.phoneNumber?.replaceAll((secondPhoneNumber?.dialCode ?? ""), "") ?? "",
      );
    } else {
      userData.additionalInfo?.secondMobileNumber?.codeRegion = secondPhoneNumber?.dialCode ?? "";
      userData.additionalInfo?.secondMobileNumber?.phone =
          secondPhoneNumber?.phoneNumber?.replaceAll((secondPhoneNumber?.dialCode ?? ""), "") ?? "";
      userData.additionalInfo?.secondMobileNumber?.fullPhone = secondPhoneNumber?.phoneNumber ?? "";
    }
  }

  bool numberChanged(String? tempPhone) =>
      (this.userData.tempPhone!.fullPhone != tempPhone && userData.tempPhone!.fullPhone.isNotEmpty);

  bool areThereAnyChanges(ProfileMeResponse? userData) {
    if (userData == null) return false;

    if (this.userData.role == UserRole.Worker) if (this.userData.userSpecializations != userData.userSpecializations)
      return true;

    if (this.userData.costPerHour != userData.costPerHour) return true;

    if (this.userData.firstName != userData.firstName) return true;

    if (this.userData.lastName != userData.lastName) return true;

    if ((this.userData.additionalInfo!.address ?? "") != (userData.additionalInfo!.address ?? "")) return true;

    if (this.userData.phone != userData.phone) {
      if (this.userData.phone!.phone == userData.phone!.phone &&
          this.userData.phone!.fullPhone == userData.phone!.fullPhone &&
          this.userData.phone!.codeRegion == userData.phone!.codeRegion)
        print("number hasn't changed");
      else
        return true;
    }

    if (this.userData.additionalInfo?.secondMobileNumber?.phone == "")
      this.userData.additionalInfo?.secondMobileNumber = null;

    if (this.userData.role == UserRole.Employer) if (this.userData.additionalInfo?.secondMobileNumber !=
        userData.additionalInfo?.secondMobileNumber) return true;

    if ((this.userData.email ?? "") != (userData.email ?? "")) return true;

    if ((this.userData.additionalInfo!.description ?? "") != (userData.additionalInfo!.description ?? "")) return true;

    if ((this.userData.additionalInfo?.socialNetwork?.facebook ?? "") !=
        (userData.additionalInfo?.socialNetwork?.facebook ?? "")) return true;

    if ((this.userData.additionalInfo?.socialNetwork?.instagram ?? "") !=
        (userData.additionalInfo?.socialNetwork?.instagram ?? "")) return true;

    if ((this.userData.additionalInfo?.socialNetwork?.linkedin ?? "") !=
        (userData.additionalInfo?.socialNetwork?.linkedin ?? "")) return true;

    if ((this.userData.additionalInfo?.socialNetwork?.twitter ?? "") !=
        (userData.additionalInfo?.socialNetwork?.twitter ?? "")) return true;

    if (this.userData.role == UserRole.Worker) if ((this.userData.additionalInfo?.workExperiences ?? "") !=
        (userData.additionalInfo?.workExperiences ?? "")) return true;

    if (this.userData.role == UserRole.Worker) if ((this.userData.additionalInfo?.educations ?? "") !=
        (userData.additionalInfo?.educations ?? "")) return true;

    if (media != null) return true;

    return false;
  }
}
