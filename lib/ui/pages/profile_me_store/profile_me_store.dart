import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:drishya_picker/drishya_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

part 'profile_me_store.g.dart';

@singleton
class ProfileMeStore extends _ProfileMeStore with _$ProfileMeStore {
  ProfileMeStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ProfileMeStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _ProfileMeStore(this._apiProvider) {
    get2FAStatus();
  }

  ProfileMeResponse? userData;
  ProfileMeResponse? questHolder;
  ProfileMeResponse? assignedWorker;

  @observable
  bool? twoFAStatus;

  @observable
  String priority = "Low";

  @observable
  String distantWork = "Remote work";

  // @observable
  // String wagePerHour = "";
  //
  // ObservableList<String> distantWorkList = ObservableList.of([
  //   "Remote work",
  //   "Work in the office",
  //   "Both options",
  // ]);

  // ObservableList<String> priorityList = ObservableList.of([
  //   "Low",
  //   "Normal",
  //   "Urgent",
  // ]);

  // @observable
  // String setPriority(int value){
  //   switch(value){
  //     case 0: priority = "Low";
  //       return priority;
  //     case 1: priority = "Normal";
  //       return priority;
  //     case 2: priority = "Urgent";
  //       return priority;
  //   }
  //   return priority;
  // }

  // @observable
  // void setPriorityValue(String priority){
  //   switch(priority){
  //     case "Low": userData!.priority = 0;
  //     break;
  //     case "Normal": userData!.priority = 1;
  //       break;
  //     case "Urgent": userData!.priority = 2;
  //     break;
  //   }
  // }

  @action
  List<String> parser(List<String> skills) {
    List<String> result = [];
    String spec;
    String skill;
    int j;
    for (int i = 0; i < skills.length; i++) {
      j = 1;
      spec = "";
      skill = "";
      while (skills[i][j] != ".") {
        spec += skills[i][j];
        j++;
      }
      j++;
      while (j < skills[i].length - 1) {
        skill += skills[i][j];
        j++;
      }
      result.add(
        "filters.items.$spec.sub.$skill".tr(),
      );
    }
    return result;
  }

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
    await SharedPreferences.getInstance().then((sharedPrefs) {
      twoFAStatus = sharedPrefs.getBool("2FAStatus") ?? false;
    });
  }

  @action
  Future getQuestHolder(String userId) async {
    try {
      this.onLoading();
      questHolder = await _apiProvider.getProfileUser(userId: userId);
      this.onSuccess(true);
    } catch (e, trace) {
      print(trace);
      this.onError(e.toString());
    }
  }

  @action
  Future getAssignedWorker(String userId) async {
    try {
      this.onLoading();
      assignedWorker = await _apiProvider.getProfileUser(userId: userId);
      this.onSuccess(true);
    } catch (e, trace) {
      print(trace);
      this.onError(e.toString());
    }
  }

  @action
  changeProfile(ProfileMeResponse userData, {DrishyaEntity? media}) async {
    try {
      this.onLoading();
      if (media != null)
        userData.avatarId =
            (await _apiProvider.uploadMedia(medias: [media]))[0];
      this.userData =
          await _apiProvider.changeProfileMe(userData, userData.role);
      this.onSuccess(true);
    } catch (e, trace) {
      print(trace);
      this.onError(e.toString());
    }
  }
}
