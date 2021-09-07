// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_quests_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$FilterQuestsStore on FilterQuestsStoreBase, Store {
  final _$isLoadingAtom = Atom(name: 'FilterQuestsStoreBase.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$filtersAtom = Atom(name: 'FilterQuestsStoreBase.filters');

  @override
  List<FilterItem> get filters {
    _$filtersAtom.reportRead();
    return super.filters;
  }

  @override
  set filters(List<FilterItem> value) {
    _$filtersAtom.reportWrite(value, super.filters, () {
      super.filters = value;
    });
  }

  final _$sortByAtom = Atom(name: 'FilterQuestsStoreBase.sortBy');

  @override
  List<String> get sortBy {
    _$sortByAtom.reportRead();
    return super.sortBy;
  }

  @override
  set sortBy(List<String> value) {
    _$sortByAtom.reportWrite(value, super.sortBy, () {
      super.sortBy = value;
    });
  }

  final _$readFiltersAsyncAction =
      AsyncAction('FilterQuestsStoreBase.readFilters');

  @override
  Future<dynamic> readFilters() {
    return _$readFiltersAsyncAction.run(() => super.readFilters());
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
filters: ${filters},
sortBy: ${sortBy}
    ''';
  }
}
