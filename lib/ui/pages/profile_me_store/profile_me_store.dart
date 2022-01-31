import 'dart:io';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../enums.dart';

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
  QuestPriority priorityValue = QuestPriority.Normal;

  @observable
  String distantWork = "Distant work";

  @observable
  String wagePerHour = "";

  List<String> distantWorkList = [
    "Distant work",
    "Work in office",
    "Both options",
  ];

  void setPriorityValue(String priority) =>
      priorityValue = QuestPriority.values.byName(priority);

  void workplaceToValue() {
    switch (userData!.workplace) {
      case "distant":
        distantWork = distantWorkList[0];
        break;
      case "office":
        distantWork = distantWorkList[1];
        break;
      case "both":
        distantWork = distantWorkList[2];
        break;
    }
  }

  void setWorkplaceValue(String text) => distantWork = text;

  String valueToWorkplace() {
    switch (distantWork) {
      case "Distant work":
        return userData!.workplace = "distant";
      case "Work in office":
        return userData!.workplace = "office";
      case "Both options":
        return userData!.workplace = "both";
      default:
        return userData?.workplace ?? "both";
    }
  }

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

  Future<void> get2FAStatus() async {

    await SharedPreferences.getInstance().then((sharedPrefs) {
      twoFAStatus = sharedPrefs.getBool("2FAStatus") ?? false;
    });
  }

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

  changeProfile(ProfileMeResponse userData, {File? media}) async {
    try {
      this.onLoading();
      if (media != null)
        userData.avatarId = (await _apiProvider.uploadMedia(
            medias: ObservableList.of([media])))[0];
      this.userData =
          await _apiProvider.changeProfileMe(userData, userData.role);
      this.onSuccess(true);
    } catch (e, trace) {
      print(trace);
      this.onError(e.toString());
    }
  }
}
