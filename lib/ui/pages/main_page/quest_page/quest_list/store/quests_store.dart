import 'dart:async';

import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/keys.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_maps_webservice/places.dart';

part 'quests_store.g.dart';

@singleton
class QuestsStore extends _QuestsStore with _$QuestsStore {
  QuestsStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _QuestsStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _QuestsStore(this._apiProvider);

  @observable
  String searchWord = "";

  @observable
  String? sort = "";

  @observable
  String employment = "Select all";

  @observable
  String workplace = "Select all";

  @observable
  int priority = -1;

  @observable
  int offset = 0;

  @observable
  int limit = 10;

  @observable
  int status = -1;

  @observable
  List<BaseQuestResponse>? questsList;

  @observable
  List<BaseQuestResponse>? searchResultList = [];

  @observable
  List<String> employmentValue = [];

  @observable
  List<String> workplaceValue = [];

  @observable
  double latitude = 0.0;

  @observable
  double longitude = 0.0;

  Timer? debounce;

  @observable
  String locationPlaceName = '';

  ///API_KEY HERE
  GoogleMapsPlaces _places =
  GoogleMapsPlaces(apiKey: Keys.googleKey);

  @action
  Future<Null> getPrediction(BuildContext context) async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      ///API_KEY HERE
      apiKey: Keys.googleKey,
      mode: Mode.overlay,
      logo: SizedBox(),
      // Mode.fullscreen
    );
    locationPlaceName = p!.description!;
    displayPrediction(p.placeId);
  }

  @action
  Future<Null> displayPrediction(String? p) async {
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p!);
    latitude = detail.result.geometry!.location.lat;
    longitude = detail.result.geometry!.location.lng;
  }

  @action
  void setSearchWord(String value) {
    searchWord = value.trim();
    if (debounce != null) {
      debounce!.cancel();
      this.onSuccess(true);
    }
    if (searchWord.length > 2) getSearchedQuests();
  }

  @computed
  bool get emptySearch =>
      searchWord.length > 2 && searchResultList!.isEmpty && !this.isLoading;

  @action
  List<String> getEmploymentValue() {
    switch (employment) {
      case "Select all":
        employmentValue.clear();
        employmentValue.add("fullTime");
        employmentValue.add("partTime");
        employmentValue.add("fixedTerm");
        employmentValue.add("contract");
        return employmentValue;
      case "Full-time":
        employmentValue.add("fullTime");
        return employmentValue;
      case "Part-time":
        employmentValue.add("partTime");
        return employmentValue;
      case "Fixed-term":
        employmentValue.add("fixedTerm");
        return employmentValue;
      case "Contract":
        employmentValue.add("contract");
        return employmentValue;
    }
    print("employmentValue: $employmentValue");
    return employmentValue;
  }

  @action
  List<String> getWorkplaceValue() {
    switch (workplace) {
      case "Select all":
        workplaceValue.clear();
        workplaceValue.add("both");
        return workplaceValue;
      case "Work in office":
        workplaceValue.add("office");
        return workplaceValue;
      case "Distant work":
        workplaceValue.add("distant");
        return workplaceValue;
    }
    print("workplaceValue: $workplaceValue");
    return workplaceValue;
  }

  @action
  Future getSearchedQuests() async {
    this.onLoading();
    debounce = Timer(const Duration(milliseconds: 300), () async {
      searchResultList = await _apiProvider.getQuests(
        searchWord: this.searchWord,
      );
      this.onSuccess(true);
    });
  }

  @action
  Future getQuests(String userId) async {
    try {
      this.onLoading();
      final loadQuestsList = await _apiProvider.getQuests(
        employment: employmentValue,
        workplace: workplaceValue,
        offset: this.offset,
        limit: this.limit,
        sort: this.sort,
      );
      if (questsList != null) {
        this.questsList = [...this.questsList!, ...loadQuestsList];
        this.offset += 10;
      } else {
        questsList = loadQuestsList;
        this.offset += 10;
      }
      this.onSuccess(true);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}
