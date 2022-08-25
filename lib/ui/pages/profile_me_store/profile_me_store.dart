import 'dart:async';
import 'dart:io';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/repository/profile_me_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../../enums.dart';

part 'profile_me_store.g.dart';

@singleton
class ProfileMeStore extends _ProfileMeStore with _$ProfileMeStore {
  ProfileMeStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ProfileMeStore extends IStore<bool> with Store {
  final IProfileMeRepository _repository;

  _ProfileMeStore(ApiProvider apiProvider) : _repository = ProfileMeRepository(apiProvider);

  ProfileMeResponse? userData;

  @observable
  String priorityValue = "quests.priority.all";

  @observable
  ObservableList<BaseQuestResponse> quests = ObservableList.of([]);

  @observable
  String distantWork = "Remote work";

  @observable
  String wagePerHour = "";

  @observable
  String? totp;

  @observable
  String payPeriod = "quests.payPeriod.hourly";

  String sort = "sort[createdAt]=desc";

  @action
  void setPayPeriod(String value) => payPeriod = value;

  void setPriorityValue(String value) => priorityValue = value;

  void setWorkplaceValue(String text) => distantWork = text;

  @action
  void setTotp(String value) => totp = value;

  @action
  getProfileMe() async {
    try {
      this.onLoading();
      Future.delayed(Duration(milliseconds: 250));
      userData = await _repository.getProfileMe();
      this.onSuccess(true);
    } on FormatException catch (e) {
      this.onError(e.message);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  getCompletedQuests({
    required UserRole userRole,
    required String userId,
    required bool newList,
    required bool isProfileYours,
  }) async {
    try {
      await Future.delayed(const Duration(microseconds: 250));
      if (newList) {
        quests.clear();
      }
      this.onLoading();
      final result = await _repository.getCompletedQuests(
        userRole: userRole,
        userId: userId,
        newList: newList,
        isProfileYours: isProfileYours,
        offset: quests.length,
      );
      quests.addAll(result);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  getActiveQuests({
    required String userId,
    required bool newList,
    required bool isProfileYours,
  }) async {
    try {
      if (newList) {
        quests.clear();
      }
      this.onLoading();
      final result = await _repository.getActiveQuests(
        userId: userId,
        newList: newList,
        isProfileYours: isProfileYours,
        offset: quests.length,
      );
      quests.addAll(result);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  changeProfile(ProfileMeResponse userData, {File? media}) async {
    try {
      this.onLoading();
      this.userData = await _repository.changeProfile(this.userData!, userData);
      this.onSuccess(true);
    } catch (e, trace) {
      print(trace);
      this.onError(e.toString());
    }
  }

  deletePushToken() async {
    try {
      this.onLoading();
      await _repository.deletePushToken();
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
