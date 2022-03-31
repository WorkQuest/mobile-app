import 'dart:async';
import 'dart:developer';

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
  String searchWord = "";

  List<String> selectedSkill = [];

  Map<int, List<int>> skillFilters = {};

  ObservableMap<int, ObservableList<bool>> selectedSkillFilters = ObservableMap.of({});

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
      result += '&betweenWagePerHour[from]=${fromPrice.isNotEmpty ? fromPrice : '0'}';
      result +=
          '&betweenWagePerHour[to]=${toPrice.isNotEmpty ? toPrice : '99999999999999'}';
    } else {
      result += '&priceBetween[from]=${fromPrice.isNotEmpty ? fromPrice : '0'}';
      result += '&priceBetween[to]=${toPrice.isNotEmpty ? toPrice : '99999999999999'}';
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
    role == UserRole.Worker ? searchResultList.clear() : searchWorkersList.clear();
    offset = 0;
    searchWord = value.trim();
    if (debounce != null) {
      debounce!.cancel();
      this.onSuccess(true);
    }
    if (searchWord.length > 0)
      role == UserRole.Worker ? getSearchedQuests() : getSearchedWorkers();
  }

  @computed
  bool get emptySearch =>
      // searchWord.isNotEmpty &&
      searchResultList.isEmpty &&
      searchWorkersList.isEmpty &&
      questsList.isEmpty &&
      !this.isLoading;

  @action
  Future getSearchedQuests() async {
    try {
      if (offset == searchResultList.length) {
        this.onLoading();
        debounce = Timer(const Duration(milliseconds: 300), () async {
          searchResultList.addAll(await _apiProvider.getQuests(
            price: getFilterPrice(),
            searchWord: searchWord,
            offset: offset,
            statuses: [0, 1],
            employment: employments,
            workplace: workplaces,
            priority: priorities,
            limit: this.limit,
            sort: this.sort,
            specializations: selectedSkill,
          ));
          //offset review
          offset += 10;
          this.onSuccess(true);
        });
      }
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future getSearchedWorkers() async {
    if (this.offset == searchResultList.length) {
      this.onLoading();
      debounce = Timer(const Duration(milliseconds: 300), () async {
        searchWorkersList.addAll(await _apiProvider.getWorkers(
          searchWord: this.searchWord,
          price: getFilterPrice(isWorker: true),
          offset: this.offset,
          sort: this.sort,
          limit: this.limit,
          workplace: workplaces,
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
      }
      if (this.offset == questsList.length) {
        questsList.addAll(await _apiProvider.getQuests(
          price: getFilterPrice(),
          statuses: [0, 1],
          employment: employments,
          workplace: workplaces,
          priority: priorities,
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
  }

  @action
  Future getWorkers(bool newList) async {
    try {
      if (newList) {
        this.onLoading();
        workersList.clear();
        offsetWorkers = 0;
      }
      if (offsetWorkers == workersList.length) {
        log('sort: $sort');
        log('workplaces: $workplaces');
        log('priorities: $priorities');
        log('employeeRatings: $employeeRatings');
        log('selectedSkill: $selectedSkill');
        workersList.addAll(await _apiProvider.getWorkers(
          sort: this.sort,
          price: getFilterPrice(isWorker: true),
          offset: this.offsetWorkers,
          limit: this.limit,
          workplace: workplaces,
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
  }
}
