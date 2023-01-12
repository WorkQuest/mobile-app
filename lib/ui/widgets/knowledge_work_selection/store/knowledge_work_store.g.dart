// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_work_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$KnowledgeWorkStore on _KnowledgeWorkStore, Store {
  final _$numberOfFiledAtom = Atom(name: '_KnowledgeWorkStore.numberOfFiled');

  @override
  ObservableList<KnowledgeWork> get numberOfFiled {
    _$numberOfFiledAtom.reportRead();
    return super.numberOfFiled;
  }

  @override
  set numberOfFiled(ObservableList<KnowledgeWork> value) {
    _$numberOfFiledAtom.reportWrite(value, super.numberOfFiled, () {
      super.numberOfFiled = value;
    });
  }

  final _$_KnowledgeWorkStoreActionController =
      ActionController(name: '_KnowledgeWorkStore');

  @override
  void addField(KnowledgeWork value) {
    final _$actionInfo = _$_KnowledgeWorkStoreActionController.startAction(
        name: '_KnowledgeWorkStore.addField');
    try {
      return super.addField(value);
    } finally {
      _$_KnowledgeWorkStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteField(KnowledgeWork kng) {
    final _$actionInfo = _$_KnowledgeWorkStoreActionController.startAction(
        name: '_KnowledgeWorkStore.deleteField');
    try {
      return super.deleteField(kng);
    } finally {
      _$_KnowledgeWorkStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
numberOfFiled: ${numberOfFiled}
    ''';
  }
}
