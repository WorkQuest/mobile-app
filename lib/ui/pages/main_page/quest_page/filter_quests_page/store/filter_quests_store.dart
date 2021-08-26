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

  Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    return jsonDecode(await rootBundle.loadString(assetsPath));
  }

  @action
  Future readFilters() async {
    final json = await parseJsonFromAssets("assets/lang/en-US.json");
    final filtersJson = json["filter"] as Map<String, dynamic>;
    int i = 0;
    filtersJson.forEach((key, value) {
      filters.add(FilterItem(
          header: key,
          list: (value["arg"] as Map<String, dynamic>).keys.toList(),
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
