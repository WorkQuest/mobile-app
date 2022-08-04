import 'dart:io';

import 'package:app/enums.dart';
import 'package:app/keys.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/widgets/error_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:easy_localization/easy_localization.dart';

part 'change_profile_store.g.dart';

class ChangeProfileStore = ChangeProfileStoreBase with _$ChangeProfileStore;

abstract class ChangeProfileStoreBase with Store {
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

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Keys.googleKey);

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
    }
  }

  @action
  Future<void> getInitCode(Phone firstPhone, Phone? secondPhone) async {
    phoneNumber =
        await PhoneNumber.getRegionInfoFromPhoneNumber(firstPhone.fullPhone);
    if (secondPhone != null)
      secondPhoneNumber =
          await PhoneNumber.getRegionInfoFromPhoneNumber(secondPhone.fullPhone);
    else
      userData.additionalInfo?.secondMobileNumber =
          Phone(phone: "", fullPhone: "", codeRegion: "");

    if (phoneNumber == null)
      phoneNumber = PhoneNumber(phoneNumber: "", dialCode: "+1", isoCode: "US");

    if (secondPhoneNumber == null)
      secondPhoneNumber =
          PhoneNumber(phoneNumber: "", dialCode: "+1", isoCode: "US");
  }

  @action
  Future<Null> displayPrediction(String? p) async {
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p!);
    userData.locationCode!.latitude = detail.result.geometry!.location.lat;
    userData.locationCode!.longitude = detail.result.geometry!.location.lng;
    userData.locationPlaceName = address;
    userData.additionalInfo?.address = address;
  }

  @action
  setPhoneNumber(PhoneNumber phone) => this.phoneNumber = phone;

  @action
  setSecondPhoneNumber(PhoneNumber phone) => this.secondPhoneNumber = phone;

  void savePhoneNumber() {
    if (userData.tempPhone == null) {
      userData.tempPhone = Phone(
        codeRegion: phoneNumber?.dialCode ?? "",
        fullPhone: phoneNumber?.phoneNumber ?? "",
        phone: phoneNumber?.phoneNumber
                ?.replaceAll((phoneNumber?.dialCode ?? ""), "") ??
            "",
      );
    } else {
      userData.tempPhone!.codeRegion = phoneNumber?.dialCode ?? "";
      userData.tempPhone!.phone = phoneNumber!.phoneNumber!
          .replaceAll((phoneNumber?.dialCode ?? ""), "");
      userData.tempPhone!.fullPhone = phoneNumber?.phoneNumber ?? "";
    }
  }

  void saveSecondPhoneNumber() {
    if ((secondPhoneNumber?.phoneNumber ?? "").isEmpty) return;
    if (userData.additionalInfo?.secondMobileNumber == null) {
      userData.additionalInfo?.secondMobileNumber = Phone(
        codeRegion: secondPhoneNumber?.dialCode ?? "",
        fullPhone: secondPhoneNumber?.phoneNumber ?? "",
        phone: secondPhoneNumber?.phoneNumber
                ?.replaceAll((secondPhoneNumber?.dialCode ?? ""), "") ??
            "",
      );
    } else {
      userData.additionalInfo?.secondMobileNumber?.codeRegion =
          secondPhoneNumber?.dialCode ?? "";
      userData.additionalInfo?.secondMobileNumber?.phone = secondPhoneNumber
              ?.phoneNumber
              ?.replaceAll((secondPhoneNumber?.dialCode ?? ""), "") ??
          "";
      userData.additionalInfo?.secondMobileNumber?.fullPhone =
          secondPhoneNumber?.phoneNumber ?? "";
    }
  }

  bool validationKnowledge(
      List<Map<String, String>> list, BuildContext context) {
    bool chek = true;
    list.forEach((element) {
      if (element["from"]!.isEmpty ||
          element["to"]!.isEmpty ||
          element["place"]!.isEmpty) {
        errorAlert(context, "modals.errorEducation".tr());
        chek = false;
      }

      String dateFrom = "";
      element["from"]!.split(".").forEach((element) {
        if (int.parse(element) < 10) element = "0" + element;
        dateFrom += element + "-";
      });
      dateFrom = dateFrom.substring(0, dateFrom.length - 1);

      String dateTo = "";
      element["to"]!.split(".").forEach((element) {
        if (int.parse(element) < 10) element = "0" + element;
        dateTo += element + "-";
      });
      dateTo = dateTo.substring(0, dateTo.length - 1);

      if (DateTime.parse(dateFrom).millisecondsSinceEpoch >
          DateTime.parse(dateTo).millisecondsSinceEpoch) {
        errorAlert(context, "modals.errorDate".tr());
        chek = false;
      }
    });
    return chek;
  }

  bool validationWork(List<Map<String, String>> list, BuildContext context) {
    bool chek = true;
    list.forEach((element) {
      if (element["from"]!.isEmpty ||
          element["to"]!.isEmpty ||
          element["place"]!.isEmpty) {
        errorAlert(context, "modals.errorEducation".tr());
        chek = false;
      }
    });
    return chek;
  }

  bool numberChanged(String tempPhone) =>
      (this.userData.tempPhone!.fullPhone != tempPhone &&
          userData.tempPhone!.fullPhone.isNotEmpty);

  bool areThereAnyChanges(ProfileMeResponse? userData) {
    if (userData == null) return false;

    if (this.userData.role == UserRole.Worker) if (this
            .userData
            .userSpecializations !=
        userData.userSpecializations) return true;

    if (this.userData.costPerHour != userData.costPerHour) return true;

    if (this.userData.firstName != userData.firstName) return true;

    if (this.userData.lastName != userData.lastName) return true;

    if ((this.userData.additionalInfo!.address ?? "") !=
        (userData.additionalInfo!.address ?? "")) return true;

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

    if (this.userData.role == UserRole.Employer) if (this
            .userData
            .additionalInfo
            ?.secondMobileNumber !=
        userData.additionalInfo?.secondMobileNumber) return true;

    if ((this.userData.email ?? "") != (userData.email ?? "")) return true;

    if ((this.userData.additionalInfo!.description ?? "") !=
        (userData.additionalInfo!.description ?? "")) return true;

    if ((this.userData.additionalInfo?.socialNetwork?.facebook ?? "") !=
        (userData.additionalInfo?.socialNetwork?.facebook ?? "")) return true;

    if ((this.userData.additionalInfo?.socialNetwork?.instagram ?? "") !=
        (userData.additionalInfo?.socialNetwork?.instagram ?? "")) return true;

    if ((this.userData.additionalInfo?.socialNetwork?.linkedin ?? "") !=
        (userData.additionalInfo?.socialNetwork?.linkedin ?? "")) return true;

    if ((this.userData.additionalInfo?.socialNetwork?.twitter ?? "") !=
        (userData.additionalInfo?.socialNetwork?.twitter ?? "")) return true;

    if (this.userData.role == UserRole.Worker) if ((this
                .userData
                .additionalInfo
                ?.workExperiences ??
            "") !=
        (userData.additionalInfo?.workExperiences ?? "")) return true;

    if (this.userData.role == UserRole.Worker) if ((this
                .userData
                .additionalInfo
                ?.educations ??
            "") !=
        (userData.additionalInfo?.educations ?? "")) return true;

    if (media != null) return true;

    return false;
  }
}
