// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WorkerStore on _WorkerStore, Store {
  final _$questAtom = Atom(name: '_WorkerStore.quest');

  @override
  BaseQuestResponse? get quest {
    _$questAtom.reportRead();
    return super.quest;
  }

  @override
  set quest(BaseQuestResponse? value) {
    _$questAtom.reportWrite(value, super.quest, () {
      super.quest = value;
    });
  }

  @override
  String toString() {
    return '''
quest: ${quest}
    ''';
  }
}
