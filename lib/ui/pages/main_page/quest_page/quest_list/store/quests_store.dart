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
  ObservableList<bool> employment = ObservableList.of(
    List.generate(4, (index) => false),
  );

  @observable
  ObservableList<bool> workplace = ObservableList.of(
    List.generate(3, (index) => false),
  );

  @observable
  ObservableList<bool> priority = ObservableList.of(
      List.generate(4, (index) => false),
  );

  @observable
  int offset = 0;

  @observable
  int limit = 10;

  @observable
  int status = -1;

  @observable
  List<BaseQuestResponse>? questsList;

  @observable
  List<ProfileMeResponse>? workersList;

  @observable
  List<BaseQuestResponse>? searchResultList = [];

  @observable
  List<ProfileMeResponse>? searchWorkersList = [];

  @observable
  ObservableList<String> employmentValue = ObservableList.of([]);

  @observable
  ObservableList<String> workplaceValue = ObservableList.of([]);

  @observable
  ObservableList<String> priorityValue = ObservableList.of([]);

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
    if (employment[0] == true) {
      employmentValue.clear();
      employmentValue.add("fullTime");
      employmentValue.add("partTime");
      employmentValue.add("fixedTerm");
      return employmentValue;
    } else if (employment[0] == false) {
      employmentValue.clear();
    }
    if (employment[1] == true) {
      employmentValue.add("fullTime");
    } else if (employment[1] == false) {
      employmentValue.remove("fullTime");
    }
    if (employment[2] == true) {
      employmentValue.add("partTime");
    } else if (employment[2] == false) {
      employmentValue.remove("partTime");
    }
    if (employment[3] == true) {
      employmentValue.add("fixedTerm");
    } else if (employment[3] == false) {
      employmentValue.remove("fixedTerm");
    }
    return employmentValue;
  }

  @action
  List<String> getPriorityValue() {
    if (priority[0] == true) {
      priorityValue.add("0");
    } else if (priority[0] == false) {
      priorityValue.remove("0");
    }
    if (priority[1] == true) {
      priorityValue.add("1");
    } else if (priority[1] == false) {
      priorityValue.remove("1");
    }
    if (priority[2] == true) {
      priorityValue.add("2");
    } else if (priority[2] == false) {
      priorityValue.remove("2");
    }
    if (priority[3] == true) {
      priorityValue.add("3");
    } else if (priority[3] == false) {
      priorityValue.remove("3");
    }
    return priorityValue;
  }

  @action
  List<String> getWorkplaceValue() {
    if (workplace[0] == true) {
      workplaceValue.clear();
      workplaceValue.add("both");
      workplaceValue.add("distant");
      workplaceValue.add("office");
      return workplaceValue;
    } else if (workplace[0] == false) {
      workplaceValue.clear();
    }
    if (workplace[1] == true) {
      workplaceValue.add("distant");
    } else if (workplace[1] == false) {
      workplaceValue.remove("distant");
    }
    if (workplace[2] == true) {
      workplaceValue.add("office");
    } else if (workplace[2] == false) {
      workplaceValue.remove("office");
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
        statuses: [0, 1, 4],

        employment: getEmploymentValue(),
        workplace: getWorkplaceValue(),

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

  @action
  Future getWorkers(String userId) async {
    try {
      this.onLoading();
      final loadWorkersList = await _apiProvider.getWorkers(
        sort: this.sort,
      );
      if (workersList != null) {
        this.workersList = [...this.workersList!, ...loadWorkersList];
        this.offset += 10;
      } else {
        workersList = loadWorkersList;
        this.offset += 10;
      }
      this.onSuccess(true);
    } catch (e, trace) {
      print("getWorkers error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}
