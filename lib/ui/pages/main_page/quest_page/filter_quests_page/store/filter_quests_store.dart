import 'dart:async';

import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';

part 'filter_quests_store.g.dart';

@singleton
class FilterQuestsStore extends FilterQuestsStoreBase with _$FilterQuestsStore {
  FilterQuestsStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class FilterQuestsStoreBase extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  FilterQuestsStoreBase(this._apiProvider);

  @observable
  bool isLoading = true;

  Map<int, List<int>> skillFilters = {};

  @observable
  ObservableList<bool> priority = ObservableList.of(
    List.generate(4, (index) => false),
  );

  List<String> employmentValue = [];

  List<String> workplaceValue = [];

  List<int> employeeRatingValue = [];

  List<int> priorityValue = [];

  List<String> payPeriodValue = [];

  List<String> selectedSkill = [];

  String sort = "";

  String fromPrice = "";

  String toPrice = "";

  setFromPrice(String value) => fromPrice = value;

  setToPrice(String value) => toPrice = value;

  @observable
  ObservableMap<int, ObservableList<bool>> selectedSkillFilters =
      ObservableMap.of({});

  final List<String> sortBy = [
    "quests.filter.sortBy.addedTimeAscending",
    "quests.filter.sortBy.addedTimeDescending",
  ];

  @observable
  String selectSortBy = "";

  final List<String> sortByEmployment = [
    "quests.filter.sortByEmployment.selectAll",
    "quests.filter.sortByEmployment.fullTime",
    "quests.filter.sortByEmployment.partTime",
    "quests.filter.sortByEmployment.fixedTerm",
    "quests.filter.sortByEmployment.remoteWork",
    "quests.filter.sortByEmployment.employmentContract",
  ];

  @observable
  ObservableList<bool> selectEmployment =
      ObservableList.of(List.generate(6, (index) => false));

  @observable
  ObservableList<bool> selectRating =
      ObservableList.of(List.generate(4, (index) => false));

  final List<String> sortByPriority = [
    "quests.filter.sortByQuestDelivery.selectAll",
    "quests.filter.sortByQuestDelivery.urgent",
    "quests.filter.sortByQuestDelivery.shortTerm",
    "quests.filter.sortByQuestDelivery.fixedDelivery",
  ];

  final List<String> sortByEmployeeRating = [
    "quests.filter.sortByEmployeeRating.selectAll",
    "quests.filter.sortByEmployeeRating.verifiedEmployee",
    "quests.filter.sortByEmployeeRating.reliableEmployee",
    "quests.filter.sortByEmployeeRating.topRanked",
    "quests.filter.sortByEmployeeRating.notRated",
  ];

  @observable
  ObservableList<bool> selectEmployeeRating =
      ObservableList.of(List.generate(5, (index) => false));

  final List<String> sortByWorkplace = [
    "quests.distantWork.allWorkplaces",
    "quests.distantWork.distantWork",
    "quests.distantWork.workInOffice",
    "quests.distantWork.bothVariant",
  ];

  @observable
  ObservableList<bool> selectWorkplace =
      ObservableList.of(List.generate(4, (index) => false));

  final List<String> sortByPayPeriod = [
    "quests.filter.sortByEmployment.selectAll",
    "quests.payPeriod.hourly",
    "quests.payPeriod.daily",
    "quests.payPeriod.weekly",
    "quests.payPeriod.biWeekly",
    "quests.payPeriod.semiMonthly",
    "quests.payPeriod.monthly",
    "quests.payPeriod.quarterly",
    "quests.payPeriod.semiAnnually",
    "quests.payPeriod.annually",
    "quests.payPeriod.fixedPeriod",
    "quests.payPeriod.byAgreement",
  ];

  @observable
  ObservableList<bool> selectPayPeriod =
      ObservableList.of(List.generate(12, (index) => false));

  List<String> getEmploymentValue() {
    if (selectEmployment[0] == true) {
      employmentValue.clear();
      employmentValue.add("FullTime");
      employmentValue.add("PartTime");
      employmentValue.add("FixedTerm");
      employmentValue.add("RemoteWork");
      employmentValue.add("EmploymentContract");
      return employmentValue;
    } else if (selectEmployment[0] == false) {
      employmentValue.clear();
    }
    if (selectEmployment[1] == true) {
      employmentValue.add("FullTime");
    } else if (selectEmployment[1] == false) {
      employmentValue.remove("FullTime");
    }
    if (selectEmployment[2] == true) {
      employmentValue.add("PartTime");
    } else if (selectEmployment[2] == false) {
      employmentValue.remove("PartTime");
    }
    if (selectEmployment[3] == true) {
      employmentValue.add("FixedTerm");
    } else if (selectEmployment[3] == false) {
      employmentValue.remove("FixedTerm");
    }
    if (selectEmployment[4] == true) {
      employmentValue.add("RemoteWork");
    } else if (selectEmployment[4] == false) {
      employmentValue.remove("RemoteWork");
    }
    if (selectEmployment[5] == true) {
      employmentValue.add("EmploymentContract");
    } else if (selectEmployment[5] == false) {
      employmentValue.remove("EmploymentContract");
    }
    return employmentValue;
  }

  List<int> getPriorityValue() {
    priorityValue.clear();
    if (priority[0] == true) {
      priorityValue.add(0);
    } else if (priority[0] == false) {
      priorityValue.remove(0);
    }
    if (priority[3] == true) {
      priorityValue.add(1);
    } else if (priority[3] == false) {
      priorityValue.remove(1);
    }
    if (priority[2] == true) {
      priorityValue.add(2);
    } else if (priority[2] == false) {
      priorityValue.remove(2);
    }
    if (priority[1] == true) {
      priorityValue.add(3);
    } else if (priority[1] == false) {
      priorityValue.remove(3);
    }
    return priorityValue;
  }

  List<String> getPayPeriodValue() {
    payPeriodValue.clear();
    if (selectPayPeriod[0] == true) {
      payPeriodValue.add("Hourly");
      payPeriodValue.add("Daily");
      payPeriodValue.add("Weekly");
      payPeriodValue.add("BiWeekly");
      payPeriodValue.add("SemiMonthly");
      payPeriodValue.add("Monthly");
      payPeriodValue.add("Quarterly");
      payPeriodValue.add("SemiAnnually");
      payPeriodValue.add("Annually");
      payPeriodValue.add("FixedPeriod");
      payPeriodValue.add("ByAgreement");
      return payPeriodValue;
    } else if (selectPayPeriod[0] == false) {
      payPeriodValue.clear();
    }
    if (selectPayPeriod[1] == true) {
      payPeriodValue.add("Hourly");
    } else if (selectPayPeriod[1] == false) {
      payPeriodValue.remove("Hourly");
    }
    if (selectPayPeriod[2] == true) {
      payPeriodValue.add("Daily");
    } else if (selectPayPeriod[2] == false) {
      payPeriodValue.remove("Daily");
    }
    if (selectPayPeriod[3] == true) {
      payPeriodValue.add("Weekly");
    } else if (selectPayPeriod[3] == false) {
      payPeriodValue.remove("Weekly");
    }
    if (selectPayPeriod[4] == true) {
      payPeriodValue.add("BiWeekly");
    } else if (selectPayPeriod[4] == false) {
      payPeriodValue.remove("BiWeekly");
    }
    if (selectPayPeriod[5] == true) {
      payPeriodValue.add("SemiMonthly");
    } else if (selectPayPeriod[5] == false) {
      payPeriodValue.remove("SemiMonthly");
    }
    if (selectPayPeriod[6] == true) {
      payPeriodValue.add("Monthly");
    } else if (selectPayPeriod[6] == false) {
      payPeriodValue.remove("Monthly");
    }
    if (selectPayPeriod[7] == true) {
      payPeriodValue.add("Quarterly");
    } else if (selectPayPeriod[7] == false) {
      payPeriodValue.remove("Quarterly");
    }
    if (selectPayPeriod[8] == true) {
      payPeriodValue.add("SemiAnnually");
    } else if (selectPayPeriod[8] == false) {
      payPeriodValue.remove("SemiAnnually");
    }
    if (selectPayPeriod[9] == true) {
      payPeriodValue.add("Annually");
    } else if (selectPayPeriod[9] == false) {
      payPeriodValue.remove("Annually");
    }
    if (selectPayPeriod[10] == true) {
      payPeriodValue.add("FixedPeriod");
    } else if (selectPayPeriod[10] == false) {
      payPeriodValue.remove("FixedPeriod");
    }
    if (selectPayPeriod[10] == true) {
      payPeriodValue.add("ByAgreement");
    } else if (selectPayPeriod[10] == false) {
      payPeriodValue.remove("ByAgreement");
    }
    return payPeriodValue;
  }

  List<String> getWorkplaceValue() {
    if (selectWorkplace[0] == true) {
      workplaceValue.clear();
      workplaceValue.add("Remote");
      workplaceValue.add("InOffice");
      workplaceValue.add("Hybrid");
      return workplaceValue;
    } else if (selectWorkplace[0] == false) {
      workplaceValue.clear();
    }
    if (selectWorkplace[1] == true) {
      workplaceValue.add("Remote");
    } else if (selectWorkplace[1] == false) {
      workplaceValue.remove("Remote");
    }
    if (selectWorkplace[2] == true) {
      workplaceValue.add("InOffice");
    } else if (selectWorkplace[2] == false) {
      workplaceValue.remove("InOffice");
    }
    if (selectWorkplace[3] == true) {
      workplaceValue.add("Hybrid");
    } else if (selectWorkplace[3] == false) {
      workplaceValue.remove("Hybrid");
    }
    return workplaceValue;
  }

  String getSortByValue() {
    if (selectSortBy == "quests.filter.sortBy.addedTimeAscending") {
      return sort = "sort[createdAt]=asc";
    } else if (selectSortBy == "quests.filter.sortBy.addedTimeDescending") {
      return sort = "sort[createdAt]=desc";
    }
    return sort;
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
      case 3:
        selectWorkplace[3] = value ?? false;
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
  void setSelectedPayPeriod(bool? value, int index) {
    switch (index) {
      case 0:
        for (int i = 0; i < selectPayPeriod.length; i++)
          selectPayPeriod[i] = value ?? false;
        break;
      case 1:
        selectPayPeriod[1] = value ?? false;
        break;
      case 2:
        selectPayPeriod[2] = value ?? false;
        break;
      case 3:
        selectPayPeriod[3] = value ?? false;
        break;
      case 4:
        selectPayPeriod[4] = value ?? false;
        break;
      case 5:
        selectPayPeriod[5] = value ?? false;
        break;
      case 6:
        selectPayPeriod[6] = value ?? false;
        break;
      case 7:
        selectPayPeriod[7] = value ?? false;
        break;
      case 8:
        selectPayPeriod[8] = value ?? false;
        break;
      case 9:
        selectPayPeriod[9] = value ?? false;
        break;
      case 10:
        selectPayPeriod[10] = value ?? false;
        break;
      case 11:
        selectPayPeriod[11] = value ?? false;
        break;
      case 12:
        selectPayPeriod[12] = value ?? false;
        break;
    }
    for (int i = 1; i < selectPayPeriod.length; i++) {
      if (selectPayPeriod[i] == false) {
        selectPayPeriod[0] = false;
        break;
      }
      if (i == selectPayPeriod.length - 1) selectPayPeriod[0] = true;
    }
  }

  @action
  void setSelectedPriority(bool? value, int index) {
    switch (index) {
      case 0:
        for (int i = 0; i < priority.length; i++) priority[i] = value ?? false;
        break;
      case 1:
        priority[1] = value ?? false;
        break;
      case 2:
        priority[2] = value ?? false;
        break;
      case 3:
        priority[3] = value ?? false;
        break;
    }
    for (int i = 1; i < priority.length; i++) {
      if (priority[i] == false) {
        priority[0] = false;
        break;
      }
      if (i == priority.length - 1) priority[0] = true;
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
        case 4:
        selectEmployeeRating[4] = value ?? false;
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

  List<int> getEmployeeRating() {
    employeeRatingValue.clear();
    if (selectEmployeeRating[0] == true) {
      return employeeRatingValue;
    }
    if (selectEmployeeRating[1] == true) {
      employeeRatingValue.add(2);
    }
    if (selectEmployeeRating[2] == true) {
      employeeRatingValue.add(4);
    }
    if (selectEmployeeRating[3] == true) {
      employeeRatingValue.add(8);
    }
    if (selectEmployeeRating[4] == true) {
      employeeRatingValue.add(1);
    }
    return employeeRatingValue;
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
      case 4:
        selectEmployment[4] = value ?? false;
        break;
      case 5:
        selectEmployment[5] = value ?? false;
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

  // void initSkillFiltersValue(ObservableMap<int, ObservableList<bool>> value) {
  //   selectedSkillFilters = value;
  // }

  void clearFilters() {
    for (int i = 0; i < selectEmployment.length; i++)
      selectEmployment[i] = false;

    for (int i = 0; i < selectEmployeeRating.length; i++)
      selectEmployeeRating[i] = false;

    for (int i = 0; i < selectWorkplace.length; i++) selectWorkplace[i] = false;

    for (int i = 0; i < priority.length; i++) priority[i] = false;

    for (int i = 0; i < selectPayPeriod.length; i++) selectPayPeriod[i] = false;
  }

  @action
  void initEmployments(List<String> value) {
    value.forEach((element) {
      if (element == "FullTime") selectEmployment[1] = true;
      if (element == "PartTime") selectEmployment[2] = true;
      if (element == "FixedTerm") selectEmployment[3] = true;
      if (element == "RemoteWork") selectEmployment[4] = true;
      if (element == "EmploymentContract") selectEmployment[5] = true;
    });
    if (selectEmployment[1] == true &&
        selectEmployment[2] == true &&
        selectEmployment[3] == true &&
        selectEmployment[4] == true &&
        selectEmployment[5] == true) selectEmployment[0] = true;
  }

  @action
  void initRating(List<int> value) {
    value.forEach((element) {
      if (element == 2) selectEmployeeRating[1] = true;
      if (element == 1) selectEmployeeRating[2] = true;
      if (element == 3) selectEmployeeRating[3] = true;
    });
    if (selectEmployeeRating[1] == true &&
        selectEmployeeRating[2] == true &&
        selectEmployeeRating[3] == true) selectEmployeeRating[0] = true;
  }

  @action
  void initWorkplace(List<String> value) {
    value.forEach((element) {
      if (value.length == 3) {
        selectWorkplace[0] = true;
        selectWorkplace[1] = true;
        selectWorkplace[2] = true;
        selectWorkplace[3] = true;
        return;
      }
      if (element == "Remote") selectWorkplace[1] = true;
      if (element == "InOffice") selectWorkplace[2] = true;
      if (element == "Hybrid") selectWorkplace[3] = true;
    });
  }

  @action
  void initPriority(List<int> value) {
    value.forEach((element) {
      if (element == 0) {
        priority[0] = true;
        priority[1] = true;
        priority[2] = true;
        priority[3] = true;
        return;
      }
      if (element == 1) priority[3] = true;
      if (element == 2) priority[2] = true;
      if (element == 3) priority[1] = true;
    });
  }

  @action
  void initSort(String value) {
    if (value == "sort[createdAt]=asc") selectSortBy = sortBy[0];
    if (value == "sort[createdAt]=desc") selectSortBy = sortBy[1];
  }

  @action
  void initSkillFilters(List<String> value) {
    for (int i = 1; i < skillFilters.keys.length + 2; i++) {
      if (skillFilters[i] != null && i != 4)
        selectedSkillFilters[i - 1] = ObservableList.of(
            List.generate(skillFilters[i]!.length, (index) => false));
    }
    selectedSkillFilters[3] = ObservableList.of(
        List.generate(skillFilters[4]!.length + 1, (index) => false));
    value.forEach((element) {
      String skill = element.split(".")[1];
      if (skill.length == 3) skill = skill[1] + skill[2];
      if (skill.length == 4) skill = skill[2] + skill[3];
      selectedSkillFilters[int.parse(element.split(".")[0]) - 1]![
          int.parse(skill)] = true;
    });
  }

  addSkill(String skill) {
    selectedSkill.add(skill);
  }

  deleteSkill(String skill) {
    for (int i = 0; i < selectedSkill.length; i++)
      if (selectedSkill[i] == skill) selectedSkill.remove(skill);
  }

  @action
  void setSortBy(String? index) => selectSortBy = index!;

  Future getFilters(
      List<String> selectedSkills, Map<int, List<int>> value) async {
    try {
      this.onLoading();
      if (value.isEmpty)
        skillFilters = await _apiProvider.getSkillFilters();
      else
        skillFilters = value;
      initSkillFilters(selectedSkills);
      this.onSuccess(true);
    } catch (e, trace) {
      print("ERROR: $e");
      print("ERROR: $trace");
    }
  }
}
