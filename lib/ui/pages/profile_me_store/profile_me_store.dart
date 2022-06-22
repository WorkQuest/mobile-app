import 'dart:async';
import 'dart:io';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/utils/storage.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../enums.dart';

part 'profile_me_store.g.dart';

@singleton
class ProfileMeStore extends _ProfileMeStore with _$ProfileMeStore {
  ProfileMeStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ProfileMeStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _ProfileMeStore(this._apiProvider);

  ProfileMeResponse? userData;
  ProfileMeResponse? assignedWorker;

  @observable
  ProfileMeResponse? questHolder;

  @observable
  bool review = false;

  @observable
  String priorityValue = "quests.priority.all";

  @observable
  ObservableList<BaseQuestResponse> quests = ObservableList.of([]);

  @observable
  String distantWork = "Remote work";

  @observable
  String wagePerHour = "";

  @observable
  String payPeriod = "quests.payPeriod.hourly";

  final List<String> payPeriodLists = [
    "quests.payPeriod.hourly",
    "quests.payPeriod.daily",
    "quests.payPeriod.weekly",
    "quests.payPeriod.biWeekly",
    "quests.payPeriod.semiMonthly",
    "quests.payPeriod.monthly",
    "quests.payPeriod.quarterly",
    "quests.payPeriod.semiAnnually",
    "quests.payPeriod.annually",
    "quests.payPeriod.fixedPeriod",
    "quests.payPeriod.byAgreement",
  ];

  final List<String> priorityList = [
    "quests.priority.all",
    "quests.priority.urgent",
    "quests.priority.normal",
    "quests.priority.low",
  ];

  final List<String> distantWorkList = [
    "Remote work",
    "In-office",
    "Hybrid workplace",
  ];

  int offset = 0;

  String sort = "sort[createdAt]=desc";

  String error = "";

  @action
  void setPayPeriod(String value) => payPeriod = value;

  void payPeriodToValue() {
    switch (userData!.payPeriod) {
      case "Hourly":
        payPeriod = "quests.payPeriod.hourly";
        break;
      case "Daily":
        payPeriod = "quests.payPeriod.daily";
        break;
      case "Weekly":
        payPeriod = "quests.payPeriod.weekly";
        break;
      case "BiWeekly":
        payPeriod = "quests.payPeriod.biWeekly";
        break;
      case "SemiMonthly":
        payPeriod = "quests.payPeriod.semiMonthly";
        break;
      case "Monthly":
        payPeriod = "quests.payPeriod.monthly";
        break;
      case "Quarterly":
        payPeriod = "quests.payPeriod.quarterly";
        break;
      case "SemiAnnually":
        payPeriod = "quests.payPeriod.semiAnnually";
        break;
      case "Annually":
        payPeriod = "quests.payPeriod.fixedPeriod";
        break;
      case "FixedPeriod":
        payPeriod = "quests.payPeriod.fixedPeriod";
        break;
      case "ByAgreement":
        payPeriod = "quests.payPeriod.byAgreement";
        break;
    }
  }

  String valueToPayPeriod() {
    switch (payPeriod) {
      case "quests.payPeriod.hourly":
        return userData!.payPeriod = "Hourly";
      case "quests.payPeriod.daily":
        return userData!.payPeriod = "Daily";
      case "quests.payPeriod.weekly":
        return userData!.payPeriod = "Weekly";
      case "quests.payPeriod.biWeekly":
        return userData!.payPeriod = "BiWeekly";
      case "quests.payPeriod.semiMonthly":
        return userData!.payPeriod = "SemiMonthly";
      case "quests.payPeriod.monthly":
        return userData!.payPeriod = "Monthly";
      case "quests.payPeriod.quarterly":
        return userData!.payPeriod = "Quarterly";
      case "quests.payPeriod.semiAnnually":
        return userData!.payPeriod = "SemiAnnually";
      case "quests.payPeriod.fixedPeriod":
        return userData!.payPeriod = "Annually";
      case "quests.payPeriod.fixedPeriod":
        return userData!.payPeriod = "FixedPeriod";
      case "quests.payPeriod.byAgreement":
        return userData!.payPeriod = "ByAgreement";
    }
    return userData?.payPeriod ?? "";
  }

  void setPriorityValue(String value) => priorityValue = value;

  void priorityToValue() {
    switch (userData!.priority) {
      case 0:
        priorityValue = "quests.priority.all";
        break;
      case 1:
        priorityValue = "quests.priority.urgent";
        break;
      case 2:
        priorityValue = "quests.priority.normal";
        break;
      case 3:
        priorityValue = "quests.priority.low";
        break;
    }
  }

  int valueToPriority() {
    switch (priorityValue) {
      case "quests.priority.all":
        return userData!.priority = 0;
      case "quests.priority.urgent":
        return userData!.priority = 1;
      case "quests.priority.normal":
        return userData!.priority = 2;
      case "quests.priority.low":
        return userData!.priority = 3;
    }
    return userData?.priority ?? 0;
  }

  void workplaceToValue() {
    switch (userData!.workplace) {
      case "Remote":
        distantWork = distantWorkList[0];
        break;
      case "InOffice":
        distantWork = distantWorkList[1];
        break;
      case "Hybrid":
        distantWork = distantWorkList[2];
        break;
    }
  }

  void setWorkplaceValue(String text) => distantWork = text;

  String valueToWorkplace() {
    switch (distantWork) {
      case "Remote work":
        return userData!.workplace = "Remote";
      case "In-office":
        return userData!.workplace = "InOffice";
      case "Hybrid workplace":
        return userData!.workplace = "Hybrid";
      default:
        return userData?.workplace ?? "Hybrid";
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

  @action
  Future getProfileMe() async {
    try {
      this.onLoading();
      Future.delayed(Duration(milliseconds: 250));
      error = "";
      userData = await _apiProvider.getProfileMe();
      this.onSuccess(true);
    } on FormatException catch (e, trace) {
      print(trace);
      error = e.message;
      this.onError(e.message);
    } catch (e) {
      error = e.toString();
      this.onError(e.toString());
    }
  }

  Future<void> getCompletedQuests({
    required UserRole userRole,
    required String userId,
    required bool newList,
    required bool isProfileYours,
  }) async {
    try {
      await Future.delayed(const Duration(microseconds: 250));
      if (newList) {
        offset = 0;
        quests.clear();
      }
      if (offset == quests.length) {
        this.onLoading();
        quests.addAll(
          userRole == UserRole.Employer
              ? await _apiProvider.getEmployerQuests(
                  userId: userId,
                  offset: offset,
                  sort: sort,
                  statuses: [5],
                  me: isProfileYours,
                )
              : await _apiProvider.getWorkerQuests(
                  userId: userId,
                  offset: offset,
                  sort: sort,
                  statuses: [5],
                  me: isProfileYours,
                ),
        );
        offset += 10;
        this.onSuccess(true);
      }
    } catch (e) {
      this.onError(e.toString());
    }
  }

  Future<void> getActiveQuests({
    required String userId,
    required bool newList,
    required bool isProfileYours,
  }) async {
    try {
      if (newList) {
        offset = 0;
        quests.clear();
      }
      if (offset == quests.length) {
        this.onLoading();
        quests.addAll(
          await _apiProvider.getWorkerQuests(
            offset: offset,
            sort: sort,
            userId: userId,
            statuses: [3, 4],
            me: isProfileYours,
          ),
        );
        offset += 10;
        this.onSuccess(true);
      }
    } catch (e) {
      this.onError(e.toString());
    }
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
      final isTotpActive = this.userData?.isTotpActive;
      final tempPhone = this.userData?.tempPhone;
      this.userData = await _apiProvider.changeProfileMe(userData);
      this.userData?.tempPhone = tempPhone;
      this.userData?.isTotpActive = isTotpActive;
      this.onSuccess(true);
    } catch (e, trace) {
      print(trace);
      this.onError(e.toString());
    }
  }

  Future submitPhoneNumber(String phone) async {
    try {
      this.onLoading();
      await _apiProvider.submitPhoneNumber(phone);

      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  Future<void> deletePushToken() async {
    try {
      this.onLoading();
      final token = await Storage.readPushToken();
      if (token != null) await _apiProvider.deletePushToken(token: token);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
