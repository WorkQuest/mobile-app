import 'dart:convert';

import 'package:app/ui/widgets/skill_specialization_selection/store/skill_specialization_store.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';
import 'package:easy_localization/easy_localization.dart';

part 'user_profile_worker_store.g.dart';

class UserProfileWorkerStore = _UserProfileWorkerStore
    with _$UserProfileWorkerStore;

abstract class _UserProfileWorkerStore extends IStore<bool> with Store {
  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return jsonDecode(await rootBundle.loadString(assetsPath));
  }

  @observable
  List<Specialization> allSpices = [];

  @observable
  bool expandedSkills = false;

  @observable
  bool expandedDescription = false;

  @action
  setExpandedSkills(bool value) => expandedSkills = value;

  @action
  setExpandedDescription(bool value) => expandedDescription = value;

  Future readSpecialization() async {
    final json = await parseJsonFromAssets("assets/lang/en-US.json");
    final filtersJson = json["filters"]["items"] as Map<String, dynamic>;
    filtersJson.forEach(
      (key, value) {
        allSpices.add(
          Specialization(
            header: key,
            list: (value["sub"] as Map<String, dynamic>).keys.toList(),
          ),
        );
      },
    );
    isLoading = false;
  }

  @action
  List<String> parser(List<String> skills) {
    List<String> result = [];
    for (String skill in skills ){
      final _spec = skill.split(".").first;
      final _skill = skill.split('.').last;
      result.add("filters.items.$_spec.sub.$_skill".tr());
    }
    return result;
  }
}
