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
  ObservableList<bool> employment = ObservableList.of(
    List.generate(4, (index) => false),
  );

  @observable
  ObservableList<bool> priority = ObservableList.of(
    List.generate(4, (index) => false),
  );

  List<String> employmentValue = [];

  List<String> workplaceValue = [];

  List<String> employeeRatingValue = [];

  List<int> priorityValue = [];

  List<String> selectedSkill = [];

  String sort = "sort[createdAt]=desc";

  @observable
  ObservableMap<int, ObservableList<bool>> selectedSkillFilters =
      ObservableMap.of({});

  @observable
  List<String> sortBy = [
    "quests.filter.sortBy.addedTimeAscending",
    "quests.filter.sortBy.addedTimeDescending",
    "quests.filter.sortBy.priceAscending",
    "quests.filter.sortBy.priceDescending",
  ];

  @observable
  String selectSortBy = "";

  @observable
  ObservableList<String> sortByEmployment = ObservableList.of([
    "quests.filter.sortByEmployment.selectAll",
    "quests.filter.sortByEmployment.fullTime",
    "quests.filter.sortByEmployment.partTime",
    "quests.filter.sortByEmployment.fixedTerm",
  ]);

  @observable
  ObservableList<bool> selectEmployment =
      ObservableList.of(List.generate(4, (index) => false));

  @observable
  ObservableList<bool> selectRating =
      ObservableList.of(List.generate(4, (index) => false));

  @observable
  ObservableList<String> sortByPriority = ObservableList.of([
    "quests.filter.sortByQuestDelivery.selectAll",
    "quests.filter.sortByQuestDelivery.urgent",
    "quests.filter.sortByQuestDelivery.shortTerm",
    "quests.filter.sortByQuestDelivery.fixedDelivery",
  ]);

  @observable
  ObservableList<String> sortByEmployeeRating = ObservableList.of([
    "quests.filter.sortByEmployeeRating.selectAll",
    "quests.filter.sortByEmployeeRating.verifiedEmployee",
    "quests.filter.sortByEmployeeRating.reliableEmployee",
    "quests.filter.sortByEmployeeRating.aHigherLevelOfTrustEmployee",
  ]);

  @observable
  ObservableList<bool> selectEmployeeRating =
      ObservableList.of(List.generate(4, (index) => false));

  @observable
  ObservableList<String> sortByWorkplace = ObservableList.of([
    "quests.distantWork.bothVariant",
    "quests.distantWork.distantWork",
    "quests.distantWork.workInOffice",
  ]);

  @observable
  ObservableList<bool> selectWorkplace =
      ObservableList.of(List.generate(3, (index) => false));

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

  List<String> getWorkplaceValue() {
    if (selectWorkplace[0] == true) {
      workplaceValue.clear();
      workplaceValue.add("both");
      workplaceValue.add("distant");
      workplaceValue.add("office");
      return workplaceValue;
    } else if (selectWorkplace[0] == false) {
      workplaceValue.clear();
    }
    if (selectWorkplace[1] == true) {
      workplaceValue.add("distant");
    } else if (selectWorkplace[1] == false) {
      workplaceValue.remove("distant");
    }
    if (selectWorkplace[2] == true) {
      workplaceValue.add("office");
    } else if (selectWorkplace[2] == false) {
      workplaceValue.remove("office");
    }
    return workplaceValue;
  }

  String getSortByValue() {
    if (selectSortBy == "quests.filter.sortBy.addedTimeAscending") {
      return sort = "sort[createdAt]=asc";
    } else if (selectSortBy == "quests.filter.sortBy.addedTimeDescending") {
      return sort = "sort[createdAt]=desc";
    }
    if (selectSortBy == "quests.filter.sortBy.priceAscending") {
      return sort = "sort[price]=asc";
    } else if (selectSortBy == "quests.filter.sortBy.priceDescending") {
      return sort = "sort[price]=desc";
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
    }
    for (int i = 1; i < selectEmployeeRating.length; i++) {
      if (selectEmployeeRating[i] == false) {
        selectEmployeeRating[0] = false;
        break;
      }
      if (i == selectEmployeeRating.length - 1) selectEmployeeRating[0] = true;
    }
  }

  List<String> getEmployeeRating() {
    employeeRatingValue.clear();
    if (selectEmployeeRating[0] == true) {
      employeeRatingValue.add("verified");
      employeeRatingValue.add("reliable");
      employeeRatingValue.add("topRanked");
      return employeeRatingValue;
    }
    if (selectEmployeeRating[1] == true) {
      employeeRatingValue.add("verified");
    }
    if (selectEmployeeRating[2] == true) {
      employeeRatingValue.add("reliable");
    }
    if (selectEmployeeRating[3] == true) {
      employeeRatingValue.add("topRanked");
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
  }

  @action
  void initEmployments(List<String> value) {
    value.forEach((element) {
      if (element == "fullTime") selectEmployment[1] = true;
      if (element == "partTime") selectEmployment[2] = true;
      if (element == "fixedTerm") selectEmployment[3] = true;
    });
    if (selectEmployment[1] == true &&
        selectEmployment[2] == true &&
        selectEmployment[3] == true) selectEmployment[0] = true;
  }

  @action
  void initRating(List<String> value) {
    value.forEach((element) {
      if (element == "verified") selectEmployeeRating[1] = true;
      if (element == "reliable") selectEmployeeRating[2] = true;
      if (element == "topRanked") selectEmployeeRating[3] = true;
    });
    if (selectEmployeeRating[1] == true &&
        selectEmployeeRating[2] == true &&
        selectEmployeeRating[3] == true) selectEmployeeRating[0] = true;
  }

  @action
  void initWorkplace(List<String> value) {
    value.forEach((element) {
      if (element == "both") {
        selectWorkplace[0] = true;
        selectWorkplace[1] = true;
        selectWorkplace[2] = true;
      }
      if (element == "distant") selectWorkplace[1] = true;
      if (element == "office") selectWorkplace[2] = true;
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
      if (element == 1) priority[1] = true;
      if (element == 2) priority[2] = true;
      if (element == 3) priority[3] = true;
    });
  }

  @action
  void initSort(String value) {
    if (value == "sort[createdAt]=asc") selectSortBy = sortBy[0];
    if (value == "sort[createdAt]=desc") selectSortBy = sortBy[1];
    if (value == "sort[price]=asc") selectSortBy = sortBy[2];
    if (value == "sort[price]=desc") selectSortBy = sortBy[3];
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
      print(value.toString());
      initSkillFilters(selectedSkills);
      this.onSuccess(true);
    } catch (e, trace) {
      print("ERROR: $e");
      print("ERROR: $trace");
    }
  }
}
