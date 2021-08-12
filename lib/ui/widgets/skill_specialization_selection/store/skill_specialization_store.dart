import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';

part 'skill_specialization_store.g.dart';

class SkillSpecializationStore = SkillSpecializationStoreBase
    with _$SkillSpecializationStore;

abstract class SkillSpecializationStoreBase with Store {
  SkillSpecializationStoreBase() {
    readSpecialization();
  }

  @observable
  int numberOfSpices = 0;

  @observable
  bool isLoading = true;

  @observable
  List<Specialization> allSpices = [];

  @observable
  Map<int, Specialization> selectedSpices = {};

  @observable
  Map<int, List<String>> selectedSkills = {};

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return jsonDecode(await rootBundle.loadString(assetsPath));
  }

  @action
  addSpices() {
    numberOfSpices += 1;
  }

  @action
  deleteSpices() {
    if (this.selectedSkills[numberOfSpices - 1] != null) {
      this.selectedSkills.remove(numberOfSpices - 1);
    }
    this.selectedSpices.remove(numberOfSpices - 1);
    numberOfSpices -= 1;
  }

  @action
  Future readSpecialization() async {
    final json = await parseJsonFromAssets("assets/lang/en-US.json");
    final filtersJson = json["filter"] as Map<String, dynamic>;
    filtersJson.forEach((key, value) {
      allSpices.add(Specialization(
        header: key,
        list: (value["arg"] as Map<String, dynamic>).keys.toList(),
      ));
    });
    isLoading = false;
  }
}

class Specialization {
  Specialization({
    required this.list,
    required this.header,
  });
  List<String> list;
  String header;
}

enum TypeFilter { Radio, Check }
