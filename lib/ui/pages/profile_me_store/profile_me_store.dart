import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:drishya_picker/drishya_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_me_store.g.dart';

@singleton
class ProfileMeStore extends _ProfileMeStore with _$ProfileMeStore {
  ProfileMeStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ProfileMeStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _ProfileMeStore(this._apiProvider){
    get2FAStatus();
  }

  ProfileMeResponse? userData;

  @observable
  bool? twoFAStatus;

  @action
  Future getProfileMe() async {
    try {
      this.onLoading();
      userData = await _apiProvider.getProfileMe();
      this.onSuccess(true);
    } catch (e, trace) {
      print(trace);
      this.onError(e.toString());
    }
  }

  @action
  Future<void> get2FAStatus() async {
    await SharedPreferences.getInstance().then((value) {
      twoFAStatus = value.getBool("2FAStatus") ?? false;
    });
  }

  @action
  changeProfile(ProfileMeResponse userData, {DrishyaEntity? media}) async {
    try {
      this.onLoading();
      if (media != null)
        userData.avatarId =
            (await _apiProvider.uploadMedia(medias: [media]))[0];
      this.userData = await _apiProvider.changeProfileMe(userData);
      this.onSuccess(true);
    } catch (e, trace) {
      print(trace);
      this.onError(e.toString());
    }
  }
}
