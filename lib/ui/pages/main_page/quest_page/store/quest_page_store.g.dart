// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_page_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$QuestPageStore on QuestPageStoreBase, Store {
  final _$selectPageAtom = Atom(name: 'QuestPageStoreBase.selectPage');

  @override
  PageState get selectPage {
    _$selectPageAtom.reportRead();
    return super.selectPage;
  }

  @override
  set selectPage(PageState value) {
    _$selectPageAtom.reportWrite(value, super.selectPage, () {
      super.selectPage = value;
    });
  }

  final _$QuestPageStoreBaseActionController =
      ActionController(name: 'QuestPageStoreBase');

  @override
  void changePage() {
    final _$actionInfo = _$QuestPageStoreBaseActionController.startAction(
        name: 'QuestPageStoreBase.changePage');
    try {
      return super.changePage();
    } finally {
      _$QuestPageStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectPage: ${selectPage}
    ''';
  }
}
