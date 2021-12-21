import 'dart:async';

import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app/base_store/i_store.dart';

part 'filter_quests_store.g.dart';

@injectable
class FilterQuestsStore = FilterQuestsStoreBase with _$FilterQuestsStore;

abstract class FilterQuestsStoreBase extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  FilterQuestsStoreBase(this._apiProvider);

  @observable
  bool isLoading = true;

  Map<int, List<int>> skillFilters = {};

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
  ObservableList<String> employmentValue = ObservableList.of([]);

  @observable
  ObservableList<String> workplaceValue = ObservableList.of([]);

  @observable
  ObservableList<int> priorityValue = ObservableList.of([]);

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
  List<int> getPriorityValue() {
    if (priority[0] == true) {
      priorityValue.add(0);
    } else if (priority[0] == false) {
      priorityValue.remove(0);
    }
    if (priority[1] == true) {
      priorityValue.add(1);
    } else if (priority[1] == false) {
      priorityValue.remove(1);
    }
    if (priority[2] == true) {
      priorityValue.add(2);
    } else if (priority[2] == false) {
      priorityValue.remove(2);
    }
    if (priority[3] == true) {
      priorityValue.add(3);
    } else if (priority[3] == false) {
      priorityValue.remove(3);
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
    return workplaceValue;
  }

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
  }

  @action
  void setSortBy(String? index) => selectSortBy = index!;

  Future getFilters() async {
    skillFilters = await _apiProvider.getSkillFilters();
    isLoading = false;
  }
}
