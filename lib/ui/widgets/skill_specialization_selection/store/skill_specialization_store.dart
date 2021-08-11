import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

part 'skill_specialization_store.g.dart';

class SkillSpecializationStore = SkillSpecializationStoreBase
    with _$SkillSpecializationStore;

abstract class SkillSpecializationStoreBase with Store {
  SkillSpecializationStoreBase() {
    readFilters();
  }

  @observable
  bool isLoading = true;

  @observable
  List<FilterItem> specialization = [];

  @observable
  Map<int, FilterItem> selectSpecializations = {};

  @observable
  Map<int, List<String>> selectSkills = {};

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return jsonDecode(await rootBundle.loadString(assetsPath));
  }

  @action
  Future readFilters() async {
    final json = await parseJsonFromAssets("assets/lang/en-US.json");
    final filtersJson = json["filter"] as Map<String, dynamic>;
    int i = 0;
    filtersJson.forEach((key, value) {
      specialization.add(FilterItem(
          header: key,
          list: new List<String>.from(value["arg"]),
          type: TypeFilter.values[i % 2]));
      i++;
    });
    isLoading = false;
  }
}

class FilterItem {
  FilterItem({
    required this.list,
    required this.header,
    this.type = TypeFilter.Radio,
  });
  List<String> list;
  String header;
  TypeFilter type;
}

enum TypeFilter { Radio, Check }
