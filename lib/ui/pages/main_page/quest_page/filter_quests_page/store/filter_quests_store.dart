import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:easy_localization/easy_localization.dart';

part 'filter_quests_store.g.dart';

class FilterQuestsStore = FilterQuestsStoreBase with _$FilterQuestsStore;

abstract class FilterQuestsStoreBase with Store {
  @observable
  bool isLoading = true;

  @observable
  List<FilterItem> filters = [];

  @observable
  List<String> sortBy = [
    "quests.filter.sortBy.addedTimeAscending".tr(),
    "quests.filter.sortBy.addedTimeDescending".tr(),
    "quests.filter.sortBy.priceAscending".tr(),
    "quests.filter.sortBy.priceDescending".tr(),
  ];

  @observable
  String selectSortBy = "";

  @observable
  List<String> sortByQuest = [
    "quests.filter.sortByQuest.selectAll".tr(),
    "quests.filter.sortByQuest.specializedQuests".tr(),
    "quests.filter.sortByQuest.permanentJob".tr(),
    "quests.filter.sortByQuest.quests".tr(),
  ];

  @observable
  ObservableList<bool> selectQuest =
      ObservableList.of(List.generate(4, (index) => false));

  @observable
  List<String> sortByQuestDelivery = [
    "quests.filter.sortByQuestDelivery.selectAll".tr(),
    "quests.filter.sortByQuestDelivery.urgent".tr(),
    "quests.filter.sortByQuestDelivery.shortTerm".tr(),
    "quests.filter.sortByQuestDelivery.fixedDelivery".tr(),
  ];

  @observable
  ObservableList<bool> selectQuestDelivery =
      ObservableList.of(List.generate(4, (index) => false));

  @observable
  ObservableList<String> sortByEmployment = ObservableList.of([
    "quests.filter.sortByEmployment.selectAll".tr(),
    "quests.filter.sortByEmployment.fullTime".tr(),
    "quests.filter.sortByEmployment.partTime".tr(),
    "quests.filter.sortByEmployment.fixedTerm".tr(),
    // "quests.filter.sortByEmployment.contract".tr(),
  ]);

  @observable
  ObservableList<bool> selectEmployment =
      ObservableList.of(List.generate(4, (index) => false));

  @observable
  ObservableList<String> sortByPriority = ObservableList.of([
    "quests.filter.sortByQuestDelivery.selectAll".tr(),
    "quests.filter.sortByQuestDelivery.urgent".tr(),
    "quests.filter.sortByQuestDelivery.shortTerm".tr(),
    "quests.filter.sortByQuestDelivery.fixedDelivery".tr(),
  ]);

  @observable
  ObservableList<bool> selectPriority =
      ObservableList.of(List.generate(4, (index) => false));

  @observable
  ObservableList<String> sortByEmployeeRating = ObservableList.of([
    "quests.filter.sortByEmployeeRating.selectAll".tr(),
    "quests.filter.sortByEmployeeRating.verifiedEmployee".tr(),
    "quests.filter.sortByEmployeeRating.reliableEmployee".tr(),
    "quests.filter.sortByEmployeeRating.aHigherLevelOfTrustEmployee".tr(),
  ]);

  @observable
  ObservableList<bool> selectEmployeeRating =
      ObservableList.of(List.generate(4, (index) => false));

  @observable
  ObservableList<String> sortByWorkplace = ObservableList.of([
    "quests.distantWork.bothVariant".tr(),
    "quests.distantWork.distantWork".tr(),
    "quests.distantWork.workInOffice".tr(),
  ]);

  @observable
  ObservableList<bool> selectWorkplace =
      ObservableList.of(List.generate(3, (index) => false));

  @action
  void setSelectedWorkplace(bool? value, int index) {
    switch (index) {
      case 0:
        for (int i = 0; i < selectWorkplace.length; i++)
          selectWorkplace[i] = value ?? false;
        break;
      case 1:
        selectWorkplace[1] = value ?? false;
        break;
      case 2:
        selectWorkplace[2] = value ?? false;
        break;
    }
    for (int i = 1; i < selectWorkplace.length; i++) {
      if (selectWorkplace[i] == false) {
        selectWorkplace[0] = false;
        break;
      }
      if (i == selectWorkplace.length - 1) selectWorkplace[0] = true;
    }

    // if (index == 0) if (value == true)
    //   for (int i = 0; i < selectWorkplace.length; i++) {
    //     selectWorkplace[i] = true;
    //     selectWorkplace.reduce((p, e) => p && e);
    //   }
    // else
    //   for (int i = 0; i < selectWorkplace.length; i++)
    //     selectWorkplace[i] = false;
    // else if (selectWorkplace[0] == true) selectWorkplace[0] = false;
    // selectWorkplace[index] = value ?? false;
    // selectWorkplace[0] = selectWorkplace.skip(1).reduce((p, e) => p && e);
  }

  @action
  void setSelectedPriority(bool? value, int index) {
    switch (index) {
      case 0:
        for (int i = 0; i < selectPriority.length; i++)
          selectPriority[i] = value ?? false;
        break;
      case 1:
        selectPriority[1] = value ?? false;
        break;
      case 2:
        selectPriority[2] = value ?? false;
        break;
      case 3:
        selectPriority[3] = value ?? false;
        break;
    }
    for (int i = 1; i < selectPriority.length; i++) {
      if (selectPriority[i] == false) {
        selectPriority[0] = false;
        break;
      }
      if (i == selectPriority.length - 1) selectPriority[0] = true;
    }
    // if (index == 0) if (value == true)
    //   for (int i = 0; i < selectPriority.length; i++) {
    //     selectPriority[i] = true;
    //     selectPriority.reduce((p, e) => p && e);
    //   }
    // else
    //   for (int i = 0; i < selectPriority.length; i++) selectPriority[i] = false;
    // else if (selectPriority[0] == true) selectPriority[0] = false;
    // selectPriority[index] = value ?? false;
    // selectPriority[0] = selectPriority.skip(1).reduce((p, e) => p && e);
  }

  @action
  void setSelectedEmployeeRating(bool? value, int index) {
    switch (index) {
      case 0:
        for (int i = 0; i < selectEmployeeRating.length; i++)
          selectEmployeeRating[i] = value ?? false;
        break;
      case 1:
        selectEmployeeRating[1] = value ?? false;
        break;
      case 2:
        selectEmployeeRating[2] = value ?? false;
        break;
      case 3:
        selectEmployeeRating[3] = value ?? false;
        break;
    }
    for (int i = 1; i < selectEmployeeRating.length; i++) {
      if (selectEmployeeRating[i] == false) {
        selectEmployeeRating[0] = false;
        break;
      }
      if (i == selectEmployeeRating.length - 1) selectEmployeeRating[0] = true;
    }
    // if (index == 0) if (value == true)
    //   for (int i = 0; i < selectEmployeeRating.length; i++) {
    //     selectEmployeeRating[i] = true;
    //     selectEmployeeRating.reduce((p, e) => p && e);
    //   }
    // else
    //   for (int i = 0; i < selectEmployeeRating.length; i++)
    //     selectEmployeeRating[i] = false;
    // else if (selectEmployeeRating[0] == true) selectEmployeeRating[0] = false;
    // selectEmployeeRating[index] = value ?? false;
    // selectEmployeeRating[0] =
    //     selectEmployeeRating.skip(1).reduce((p, e) => p && e);
  }

  @action
  void setSelectedQuest(bool? value, int index) {
    switch (index) {
      case 0:
        for (int i = 0; i < selectQuest.length; i++)
          selectQuest[i] = value ?? false;
        break;
      case 1:
        selectQuest[1] = value ?? false;
        break;
      case 2:
        selectQuest[2] = value ?? false;
        break;
      case 3:
        selectQuest[3] = value ?? false;
        break;
    }
    for (int i = 1; i < selectQuest.length; i++) {
      if (selectQuest[i] == false) {
        selectQuest[0] = false;
        break;
      }
      if (i == selectQuest.length - 1) selectQuest[0] = true;
    }
    // if (index == 0) if (value == true)
    //   for (int i = 0; i < selectQuest.length; i++) {
    //     selectQuest[i] = true;
    //     selectQuest.reduce((p, e) => p && e);
    //   }
    // else
    //   for (int i = 0; i < selectQuest.length; i++) selectQuest[i] = false;
    // else if (selectQuest[0] == true) selectQuest[0] = false;
    // selectQuest[index] = value ?? false;
    // selectQuest[0] = selectQuest.skip(1).reduce((p, e) => p && e);
  }

  @action
  void setSelectedQuestDelivery(bool? value, int index) {
    switch (index) {
      case 0:
        for (int i = 0; i < selectQuestDelivery.length; i++)
          selectQuestDelivery[i] = value ?? false;
        break;
      case 1:
        selectQuestDelivery[1] = value ?? false;
        break;
      case 2:
        selectQuestDelivery[2] = value ?? false;
        break;
      case 3:
        selectQuestDelivery[3] = value ?? false;
        break;
    }
    for (int i = 1; i < selectQuestDelivery.length; i++) {
      if (selectQuestDelivery[i] == false) {
        selectQuestDelivery[0] = false;
        break;
      }
      if (i == selectQuestDelivery.length - 1) selectQuestDelivery[0] = true;
    }
    // if (index == 0) if (value == true)
    //   for (int i = 0; i < selectQuestDelivery.length; i++) {
    //     selectQuestDelivery[i] = true;
    //     selectQuestDelivery.reduce((p, e) => p && e);
    //   }
    // else
    //   for (int i = 0; i < selectQuestDelivery.length; i++)
    //     selectQuestDelivery[i] = false;
    // else if (selectQuestDelivery[0] == true) selectQuestDelivery[0] = false;
    // selectQuestDelivery[index] = value ?? false;
    // selectQuestDelivery[0] =
    //     selectQuestDelivery.skip(1).reduce((p, e) => p && e);
  }

  @computed
  bool get allSelected => false;

  @action
  void setSelectedEmployment(bool? value, int index) {
    switch (index) {
      case 0:
        for (int i = 0; i < selectEmployment.length; i++)
          selectEmployment[i] = value ?? false;
        break;
      case 1:
        selectEmployment[1] = value ?? false;
        break;
      case 2:
        selectEmployment[2] = value ?? false;
        break;
      case 3:
        selectEmployment[3] = value ?? false;
        break;
    }
    for (int i = 1; i < selectEmployment.length; i++) {
      if (selectEmployment[i] == false) {
        selectEmployment[0] = false;
        break;
      }
      if (i == selectEmployment.length - 1) selectEmployment[0] = true;
    }
    // if (index == 0) if (value == true)
    //   for (int i = 0; i < selectEmployment.length; i++) {
    //     selectEmployment[i] = true;
    //     selectEmployment.reduce((p, e) => p && e);
    //   }
    // else
    //   for (int i = 0; i < selectEmployment.length; i++)
    //     selectEmployment[i] = false;
    // else if (selectEmployment[0] == true) selectEmployment[0] = false;
    // selectEmployment[index] = value ?? false;
    // selectEmployment[0] = selectEmployment.skip(1).reduce((p, e) => p && e);
  }

  @action
  void setSortBy(String? index) => selectSortBy = index!;

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return jsonDecode(await rootBundle.loadString(assetsPath));
  }

  @action
  Future readFilters() async {
    final json = await parseJsonFromAssets("assets/lang/en-US.json");
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
