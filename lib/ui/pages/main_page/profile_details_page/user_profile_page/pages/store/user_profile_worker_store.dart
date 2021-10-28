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
}
