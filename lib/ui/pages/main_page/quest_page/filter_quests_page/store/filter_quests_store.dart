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
  ObservableList<String> sortByWorkplace = ObservableList.of([
    "Select all",
    "Work in office",
    "Distant work",
  ]);

  @observable
  ObservableList<bool> selectWorkplace =
      ObservableList.of(List.generate(3, (index) => false));

  @action
  void setSelectedWorkplace(bool? value, int index) {
    if (index == 0) if (value == true)
      for (int i = 0; i < selectWorkplace.length; i++)
        selectWorkplace[i] = true;
    else
      for (int i = 0; i < selectWorkplace.length; i++)
        selectWorkplace[i] = false;
    else if (selectWorkplace[0] == true) selectWorkplace[0] = false;
    selectWorkplace[index] = value ?? false;
  }

  @action
  void setSelectedPriority(bool? value, int index) {
    if (index == 0) if (value == true)
      for (int i = 0; i < selectPriority.length; i++) selectPriority[i] = true;
    else
      for (int i = 0; i < selectPriority.length; i++) selectPriority[i] = false;
    else if (selectPriority[0] == true) selectPriority[0] = false;
    selectPriority[index] = value ?? false;
  }

  @action
  void setSelectedEmployeeRating(bool? value, int index) {
    if (index == 0) if (value == true)
      for (int i = 0; i < selectEmployeeRating.length; i++)
        selectEmployeeRating[i] = true;
    else
      for (int i = 0; i < selectEmployeeRating.length; i++)
        selectEmployeeRating[i] = false;
    else if (selectEmployeeRating[0] == true) selectEmployeeRating[0] = false;
    selectEmployeeRating[index] = value ?? false;
  }

  @action
  void setSelectedQuest(bool? value, int index) {
    if (index == 0) if (value == true)
      for (int i = 0; i < selectQuest.length; i++) selectQuest[i] = true;
    else
      for (int i = 0; i < selectQuest.length; i++) selectQuest[i] = false;
    else if (selectQuest[0] == true) selectQuest[0] = false;
    selectQuest[index] = value ?? false;
  }

  @action
  void setSelectedQuestDelivery(bool? value, int index) {
    if (index == 0) if (value == true)
      for (int i = 0; i < selectQuestDelivery.length; i++)
        selectQuestDelivery[i] = true;
    else
      for (int i = 0; i < selectQuestDelivery.length; i++)
        selectQuestDelivery[i] = false;
    else if (selectQuestDelivery[0] == true) selectQuestDelivery[0] = false;
    selectQuestDelivery[index] = value ?? false;
  }

  @computed
  bool get allSelected  => false;

  @action
  void setSelectedEmployment(bool? value, int index) {
    if (index == 0) if (value == true)
      for (int i = 0; i < selectEmployment.length; i++) {
        selectEmployment[i] = true;
        selectEmployment.reduce((p, e) => p && e);
      }
    else
      for (int i = 0; i < selectEmployment.length; i++)
        selectEmployment[i] = false;
    else if (selectEmployment[0] == true) selectEmployment[0] = false;
    selectEmployment[index] = value ?? false;
    selectEmployment[0]=selectEmployment.skip(1).reduce((p, e) => p && e);
  }

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
