import 'dart:async';

import 'package:app/base_store/i_store.dart';
import 'package:app/enums.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:decimal/decimal.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:easy_localization/easy_localization.dart';

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

  ObservableMap<int, ObservableList<bool>> selectedSkillFilters = ObservableMap.of({});

  @observable
  String sort = "sort[createdAt]=desc";

  @observable
  String fromPrice = '';

  @observable
  String toPrice = '';

  @observable
  ObservableList<BaseQuestResponse> questsList = ObservableList.of([]);

  @observable
  ObservableList<ProfileMeResponse> workersList = ObservableList.of([]);

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

  setEmployment(List<String> employment) => employments = employment;

  setEmployeeRating(List<int> employeeRating) => employeeRatings = employeeRating;

  setWorkplace(List<String> workplace) => workplaces = workplace;

  setPriority(List<int> priority) => priorities = priority;

  setSortBy(String value) => sort = value;

  setPayPeriod(List<String> value) => payPeriod = value;

  setSkillFilters(List<String> value) => selectedSkill = value;

  setSelectedSkillFilters(ObservableMap<int, ObservableList<bool>> value) =>
      selectedSkillFilters = value;

  clearSkillFilters() {
    selectedSkillFilters.forEach((key, value) {
      value.forEach((element) {
        element = false;
      });
    });
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

  String getFilterPrice() {
    String result = '';
    if (role == UserRole.Worker) {
      if (fromPrice.isNotEmpty || toPrice.isNotEmpty) {
        final _fromPrice = Decimal.parse(fromPrice.isNotEmpty ? fromPrice : '0') *
            Decimal.fromInt(10).pow(18);
        result += '&priceBetween[from]=${_fromPrice.toBigInt()}';
        final _toPrice = Decimal.parse(toPrice.isNotEmpty ? toPrice : '999999999999999') *
            Decimal.fromInt(10).pow(18);
        result += '&priceBetween[to]=${_toPrice.toBigInt()}';
      }
    } else {
      if (fromPrice.isNotEmpty || toPrice.isNotEmpty) {
        result += '&betweenCostPerHour[from]=${fromPrice.isNotEmpty ? fromPrice : '0'}';
        result +=
            '&betweenCostPerHour[to]=${toPrice.isNotEmpty ? toPrice : '999999999999999'}';
      }
    }
    return result;
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
  void setSearchWord(String value) {
    role == UserRole.Worker ? questsList.clear() : workersList.clear();
    searchWord = value.trim();
    if (debounce != null) {
      debounce!.cancel();
      this.onSuccess(true);
    }
    if (searchWord.length > 0)
      role == UserRole.Worker ? getSearchedQuests(false) : getSearchedWorkers(false);
    else {
      role == UserRole.Worker ? getQuests(true) : getWorkers(true);
    }
  }

  @computed
  bool get emptySearch => workersList.isEmpty && questsList.isEmpty && !this.isLoading;

  @action
  Future getSearchedQuests(bool newList) async {
    try {
      if (newList) {
        questsList.clear();
      }
      this.onLoading();
      debounce = Timer(const Duration(milliseconds: 300), () async {
        questsList.addAll(await _apiProvider.getQuests(
          price: getFilterPrice(),
          searchWord: searchWord,
          offset: questsList.length,
          employment: employments,
          workplace: workplaces,
          priority: priorities,
          sort: this.sort,
          specializations: selectedSkill,
          statuses: [1],
        ));
        this.onSuccess(true);
      });
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future getSearchedWorkers(bool newList) async {
    if (newList) {
      workersList.clear();
    }
    this.onLoading();
    debounce = Timer(const Duration(milliseconds: 300), () async {
      workersList.addAll(await _apiProvider.getWorkers(
        searchWord: this.searchWord,
        price: getFilterPrice(),
        offset: workersList.length,
        sort: this.sort,
        workplace: workplaces,
        payPeriod: payPeriod,
        priority: priorities,
        ratingStatus: employeeRatings,
        specializations: selectedSkill,
      ));
      this.onSuccess(true);
    });
  }

  @action
  Future getQuests(bool newList) async {
    try {
      if (newList) {
        this.onLoading();
        questsList.clear();
      } else {
        isLoadingMore = true;
      }
      questsList.addAll(await _apiProvider.getQuests(
        // searchWord: searchWord,
        price: getFilterPrice(),
        statuses: [1],
        employment: employments,
        workplace: workplaces,
        priority: priorities,
        payPeriod: payPeriod,
        offset: questsList.length,
        sort: this.sort,
        specializations: selectedSkill,
        // north: this.latitude.toString(),
        // south: this.longitude.toString(),
      ));

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
      } else {
        isLoadingMore = true;
      }
      workersList.addAll(await _apiProvider.getWorkers(
        // searchWord: searchWord,
        sort: this.sort,
        price: getFilterPrice(),
        offset: workersList.length,
        workplace: workplaces,
        payPeriod: payPeriod,
        priority: priorities,
        ratingStatus: employeeRatings,
        specializations: selectedSkill,
        // north: this.latitude.toString(),
        // south: this.longitude.toString(),
      ));

      this.onSuccess(true);
    } catch (e, trace) {
      print("getWorkers error: $e\n$trace");
      this.onError(e.toString());
    }
    isLoadingMore = false;
  }

  @action
  clearData() {
    role = UserRole.Worker;
    isLoadingMore = false;
    searchWord = "";
    selectedSkill = [];
    selectedSkillFilters.clear();
    sort = "sort[createdAt]=desc";
    fromPrice = '';
    toPrice = '';
    questsList.clear();
    workersList.clear();
    latitude = null;
    longitude = null;
    debounce = null;
    locationPlaceName = '';
    employments.clear();
    workplaces.clear();
    payPeriod.clear();
    employeeRatings.clear();
    priorities.clear();
  }
}
