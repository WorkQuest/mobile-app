import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

part 'filter_quests_store.g.dart';

class FilterQuestsStore = FilterQuestsStoreBase with _$FilterQuestsStore;

abstract class FilterQuestsStoreBase with Store {
  @observable
  bool isLoading = true;

  @observable
  List<FilterItem> filters = [];

  @observable
  List<String> sortBy = [
    "Added time ascending",
    "Added time descending",
    "Price ascending",
    "Price descending",
  ];

  @observable
  String selectSortBy = "";

  @observable
  List<String> sortByQuest = [
    "Select all",
    "Specialized quests (task that require specialized skills)",
    "Permanent job (job search by categories)",
    "Quests (all type of work)"
  ];

  @observable
  ObservableList<bool> selectQuest =
      ObservableList.of(List.generate(4, (index) => false));

  @observable
  List<String> sortByQuestDelivery = [
    "Select all",
    "Urgent",
    "Short-term",
    "Fixed delivery"
  ];

  @observable
  ObservableList<bool> selectQuestDelivery =
      ObservableList.of(List.generate(4, (index) => false));

  @observable
  ObservableList<String> sortByEmployment = ObservableList.of([
    "Select all",
    "Full-time",
    "Part-time",
    "Fixed term",
    "Contract",
  ]);

  @observable
  ObservableList<bool> selectEmployment =
      ObservableList.of(List.generate(5, (index) => false));

  @observable
  ObservableList<String> sortByPriority = ObservableList.of([
    "Select all",
    "Urgent",
    "Short-term",
    "Fixed delivery",
  ]);

  @observable
  ObservableList<bool> selectPriority =
      ObservableList.of(List.generate(4, (index) => false));

  @observable
  ObservableList<String> sortByEmployeeRating = ObservableList.of([
    "Select all",
    "Verified employee",
    "Reliable employee",
    "A higher level of trust employee",
  ]);

  @observable
  ObservableList<bool> selectEmployeeRating =
      ObservableList.of(List.generate(5, (index) => false));

  @observable
  ObservableList<String> sortByDistantWork = ObservableList.of([
    "Select all",
    "Work in office",
    "Distant work",
  ]);

  @observable
  ObservableList<bool> selectDistantWork =
      ObservableList.of(List.generate(5, (index) => false));

  @action
  void setSelectedPriority(bool? value, int index) =>
      selectPriority[index] = value!;

  @action
  void setSelectedEmployeeRating(bool? value, int index) =>
      selectEmployeeRating[index] = value!;

  @action
  void setSelectedWork(bool? value, int index) =>
      selectDistantWork[index] = value!;

  @action
  void setSelectedQuest(bool? value, int index) => selectQuest[index] = value!;

  @action
  void setSelectedQuestDelivery(bool? value, int index) =>
      selectQuestDelivery[index] = value!;

  @action
  void setSelectedEmployment(bool? value, int index) =>
      selectEmployment[index] = value!;

  @action
  void setSortBy(String? index) => selectSortBy = index!;

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return jsonDecode(await rootBundle.loadString(assetsPath));
  }

  @action
  Future readFilters() async {
    final json = await parseJsonFromAssets("assets/lang/es-ES.json");
    final filtersJson = json["filters"]["items"] as Map<String, dynamic>;
    filtersJson.forEach((key, value) {
      filters.add(FilterItem(
          header: "items.$key",
          list: (value["sub"] as Map<String, dynamic>).keys.toList(),
          type: TypeFilter.Check));
    });
    filters.insert(
        0, FilterItem(header: "dd", list: sortBy, type: TypeFilter.Radio));
    isLoading = false;
  }
}

class FilterItem {
  FilterItem({
    required this.list,
    required this.header,
    this.type = TypeFilter.Check,
  });

  List<String> list;
  String header;
  TypeFilter type;
}

enum TypeFilter { Radio, Check }
