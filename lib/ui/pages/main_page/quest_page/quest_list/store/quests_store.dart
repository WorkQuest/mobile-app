import 'dart:async';

import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/keys.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../enums.dart';

part 'quests_store.g.dart';

@singleton
class QuestsStore extends _QuestsStore with _$QuestsStore {
  QuestsStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _QuestsStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _QuestsStore(this._apiProvider);

  UserRole role = UserRole.Worker;

  @observable
  bool isLoadingMore = false;

  @observable
  String searchWord = "";

  List<String> selectedSkill = [];

  Map<int, List<int>> skillFilters = {};

  ObservableMap<int, ObservableList<bool>> selectedSkillFilters =
      ObservableMap.of({});

  @observable
  String sort = "sort[createdAt]=desc";

  @observable
  String fromPrice = '';

  @observable
  String toPrice = '';

  @observable
  int offset = 0;

  @observable
  int offsetWorkers = 0;

  @observable
  int limit = 10;

  @observable
  int status = -1;

  @observable
  ObservableList<BaseQuestResponse> questsList = ObservableList.of([]);

  @observable
  ObservableList<ProfileMeResponse> workersList = ObservableList.of([]);

  @observable
  ObservableList<BaseQuestResponse> searchResultList = ObservableList.of([]);

  @observable
  ObservableList<ProfileMeResponse> searchWorkersList = ObservableList.of([]);

  @observable
  ObservableList<BaseQuestResponse> loadQuestsList = ObservableList.of([]);

  @observable
  double? latitude;

  @observable
  double? longitude;

  Timer? debounce;

  @observable
  String locationPlaceName = '';

  List<String> employments = [];

  List<String> workplaces = [];

  List<String> payPeriod = [];

  List<int> employeeRatings = [];

  List<int> priorities = [];

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: Keys.googleKey);

  saveSkillFilters(Map<int, List<int>> value) {
    skillFilters = value;
  }

  setEmployment(List<String> employment) {
    employments = employment;
  }

  setEmployeeRating(List<int> employeeRating) {
    employeeRatings = employeeRating;
  }

  setWorkplace(List<String> workplace) {
    workplaces = workplace;
  }

  setPriority(List<int> priority) {
    priorities = priority;
  }

  setSortBy(String value) {
    sort = value;
  }

  setPayPeriod(List<String> value) {
    payPeriod = value;
  }

  setSkillFilters(List<String> value) {
    selectedSkill = value;
  }

  clearSkillFilters() {
    selectedSkillFilters.forEach((key, value) {
      value.forEach((element) {
        element = false;
      });
    });
  }

  setSelectedSkillFilters(ObservableMap<int, ObservableList<bool>> value) {
    selectedSkillFilters = value;
  }

  void clearFilters() {
    employments.clear();
    payPeriod.clear();
    workplaces.clear();
    priorities.clear();
    selectedSkill.clear();
    employeeRatings.clear();
    sort = "sort[createdAt]=desc";
    setPrice('', '');
    clearSkillFilters();
  }

  @action
  void setPrice(String from, String to) {
    fromPrice = from;
    toPrice = to;
  }

  String getFilterPrice({bool isWorker = false}) {
    String result = '';
    if (isWorker) {
      if (fromPrice.isNotEmpty)
        result += '&betweenCostPerHour[from]=$fromPrice';
      if (toPrice.isNotEmpty) result += '&betweenCostPerHour[to]=$toPrice';
    } else {
      if (fromPrice.isNotEmpty) result += '&priceBetween[from]=$fromPrice';
      if (toPrice.isNotEmpty) result += '&priceBetween[to]=$toPrice';
    }
    return result;
  }

  @action
  Future<Null> getPrediction(BuildContext context, UserRole role) async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: Keys.googleKey,
      mode: Mode.overlay,
      logo: SizedBox(),
      startText: locationPlaceName.isNotEmpty ? locationPlaceName : "",
    );
    if (p != null) {
      locationPlaceName = p.description!;
      displayPrediction(p.placeId);
      // if (role == UserRole.Worker)
      //   getQuests(true);
      // else
      //   getWorkers(true);
    }
  }

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
  Future<Null> displayPrediction(String? p) async {
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p!);
    latitude = detail.result.geometry!.location.lat;
    longitude = detail.result.geometry!.location.lng;
  }

  @action
  void setSearchWord(String value) {
    role == UserRole.Worker ? questsList.clear() : workersList.clear();
    offset = 0;
    searchWord = value.trim();
    if (debounce != null) {
      debounce!.cancel();
      this.onSuccess(true);
    }
    if (searchWord.length > 0)
      role == UserRole.Worker
          ? getSearchedQuests(false)
          : getSearchedWorkers(false);
    else {
      role == UserRole.Worker ? getQuests(true) : getWorkers(true);
    }
  }

  @computed
  bool get emptySearch =>
      workersList.isEmpty && questsList.isEmpty && !this.isLoading;

  @action
  Future getSearchedQuests(bool newList) async {
    try {
      if (newList) {
        offset = 0;
        questsList.clear();
      }
      if (offset == questsList.length) {
        this.onLoading();
        debounce = Timer(const Duration(milliseconds: 300), () async {
          questsList.addAll(await _apiProvider.getQuests(
            price: getFilterPrice(),
            searchWord: searchWord,
            offset: offset,
            employment: employments,
            workplace: workplaces,
            priority: priorities,
            limit: this.limit,
            sort: this.sort,
            specializations: selectedSkill,
            statuses: [1],
          ));
          offset += 10;
          this.onSuccess(true);
        });
      }
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future getSearchedWorkers(bool newList) async {
    if (newList) {
      offset = 0;
      workersList.clear();
    }
    if (this.offset == workersList.length) {
      this.onLoading();
      debounce = Timer(const Duration(milliseconds: 300), () async {
        workersList.addAll(await _apiProvider.getWorkers(
          searchWord: this.searchWord,
          price: getFilterPrice(isWorker: true),
          offset: this.offset,
          sort: this.sort,
          limit: this.limit,
          workplace: workplaces,
          payPeriod: payPeriod,
          priority: priorities,
          ratingStatus: employeeRatings,
          specializations: selectedSkill,
        ));
        this.offset += 10;
        this.onSuccess(true);
      });
    }
  }

  @action
  Future getQuests(bool newList) async {
    try {
      if (newList) {
        this.onLoading();
        this.offset = 0;
        questsList.clear();
      } else {
        isLoadingMore = true;
      }
      if (this.offset == questsList.length) {
        questsList.addAll(await _apiProvider.getQuests(
          // searchWord: searchWord,
          price: getFilterPrice(),
          statuses: [1],
          employment: employments,
          workplace: workplaces,
          priority: priorities,
          payPeriod: payPeriod,
          offset: this.offset,
          limit: this.limit,
          sort: this.sort,
          specializations: selectedSkill,
          // north: this.latitude.toString(),
          // south: this.longitude.toString(),
        ));
        this.offset += 10;
      }
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
    isLoadingMore = false;
  }

  @action
  Future getWorkers(bool newList) async {
    try {
      if (newList) {
        this.onLoading();
        workersList.clear();
        offsetWorkers = 0;
      } else {
        isLoadingMore = true;
      }
      if (offsetWorkers == workersList.length) {
        workersList.addAll(await _apiProvider.getWorkers(
          // searchWord: searchWord,
          sort: this.sort,
          price: getFilterPrice(isWorker: true),
          offset: this.offsetWorkers,
          limit: this.limit,
          workplace: workplaces,
          payPeriod: payPeriod,
          priority: priorities,
          ratingStatus: employeeRatings,
          specializations: selectedSkill,
          // north: this.latitude.toString(),
          // south: this.longitude.toString(),
        ));
        offsetWorkers += 10;
      }
      this.onSuccess(true);
    } catch (e, trace) {
      print("getWorkers error: $e\n$trace");
      this.onError(e.toString());
    }
    isLoadingMore = false;
  }
}
