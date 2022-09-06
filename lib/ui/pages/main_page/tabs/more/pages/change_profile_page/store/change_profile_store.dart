import 'dart:io';

import 'package:app/http/api_provider.dart';
import 'package:app/keys.dart';
import 'package:app/model/profile_response/additional_info.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/profile_response/social_network.dart';
import 'package:app/model/quests_models/location_full.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';

part 'change_profile_store.g.dart';

@injectable
class ChangeProfileStore extends ChangeProfileStoreBase with _$ChangeProfileStore {
  ChangeProfileStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class ChangeProfileStoreBase extends IStore<ChangeProfileState> with Store {
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Keys.googleKey);

  final ApiProvider _apiProvider;

  ChangeProfileStoreBase(this._apiProvider);

  @observable
  late ProfileMeResponse userData;

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
  initPage(ProfileMeResponse profile) => userData = profile;

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
      displayPrediction(p.description!);
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
    userData = userData.copyWith(
      locationCode: LocationCode(
        longitude: detail.result.geometry!.location.lng,
        latitude: detail.result.geometry!.location.lat,
      ),
      locationPlaceName: p,
      additionalInfo: (userData.additionalInfo ?? AdditionalInfo()).copyWith(
        address: p,
      ),
    );
  }

  @action
  changeProfile() async {
    try {
      onLoading();
      if (media != null) {
        userData.avatarId = (await _apiProvider.uploadMedia(medias: [media!]))[0];
      }
      await _apiProvider.changeProfileMe(userData);
      final isNumberChanged = numberChanged(oldPhoneNumber?.phoneNumber);
      onSuccess(isNumberChanged ? ChangeProfileState.changeProfileWithPhone : ChangeProfileState.changeProfile);
    } catch (e) {
      onError(e.toString());
    }
  }

  bool numberChanged(String? tempPhone) =>
      (this.userData.tempPhone!.fullPhone != oldPhoneNumber?.phoneNumber && userData.tempPhone!.fullPhone.isNotEmpty);
}

enum ChangeProfileState { changeProfile, changeProfileWithPhone }
