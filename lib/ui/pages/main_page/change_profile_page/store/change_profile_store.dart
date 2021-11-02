import 'package:app/keys.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:drishya_picker/drishya_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';

part 'change_profile_store.g.dart';

class ChangeProfileStore = ChangeProfileStoreBase with _$ChangeProfileStore;

abstract class ChangeProfileStoreBase with Store {
  ChangeProfileStoreBase(this.userData);

  @observable
  ProfileMeResponse userData;

  @observable
  DrishyaEntity? media;

  @observable
  late String address = userData.additionalInfo?.address ?? "";

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Keys.googleKey);

  @action
  Future<Null> getPrediction(BuildContext context) async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: Keys.googleKey,
      mode: Mode.overlay,
      logo: SizedBox(),
      // Mode.fullscreen
    );
    address = p!.description!;
    displayPrediction(p.placeId);
  }

  @action
  Future<Null> displayPrediction(String? p) async {
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p!);
    userData.location!.latitude = detail.result.geometry!.location.lat;
    userData.location!.longitude = detail.result.geometry!.location.lng;
  }

  bool areThereAnyChanges(ProfileMeResponse? userData) {
    if (userData == null) return false;

    if (this.userData.userSpecializations != userData.userSpecializations)
      return true;

    if (this.userData.firstName != userData.firstName) return true;

    if (this.userData.lastName  != userData.lastName )
      return true;

    if ((this.userData.additionalInfo!.address ?? "") !=
        (userData.additionalInfo!.address ?? "")) return true;

    if ((this.userData.phone ?? "") != (userData.phone ?? "")) return true;

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

    if ((this.userData.additionalInfo?.workExperiences ?? "") !=
        (userData.additionalInfo?.workExperiences ?? "")) return true;

    if ((this.userData.additionalInfo?.educations ?? "") !=
        (userData.additionalInfo?.educations ?? "")) return true;

    if (media != null) return true;

    return false;
  }
}
