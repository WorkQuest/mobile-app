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
    "filters.dd.1".tr(),
    "filters.dd.2".tr(),
    "filters.dd.3".tr(),
    "filters.dd.4".tr(),
    "filters.dd.5".tr(),
    "filters.dd.6".tr(),
    "filters.dd.7".tr(),
  ];

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
    filters.insert(0, FilterItem(
        header: "dd",
        list: sortBy,
        type: TypeFilter.Radio));
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
