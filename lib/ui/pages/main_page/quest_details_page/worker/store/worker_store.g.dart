// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WorkerStore on _WorkerStore, Store {
  final _$opinionAtom = Atom(name: '_WorkerStore.opinion');

  @override
  String get opinion {
    _$opinionAtom.reportRead();
    return super.opinion;
  }

  @override
  set opinion(String value) {
    _$opinionAtom.reportWrite(value, super.opinion, () {
      super.opinion = value;
    });
  }

  final _$responseAtom = Atom(name: '_WorkerStore.response');

  @override
  bool get response {
    _$responseAtom.reportRead();
    return super.response;
  }

  @override
  set response(bool value) {
    _$responseAtom.reportWrite(value, super.response, () {
      super.response = value;
    });
  }

  final _$mediaFileAtom = Atom(name: '_WorkerStore.mediaFile');

  @override
  ObservableList<File> get mediaFile {
    _$mediaFileAtom.reportRead();
    return super.mediaFile;
  }

  @override
  set mediaFile(ObservableList<File> value) {
    _$mediaFileAtom.reportWrite(value, super.mediaFile, () {
      super.mediaFile = value;
    });
  }

  final _$mediaIdsAtom = Atom(name: '_WorkerStore.mediaIds');

  @override
  ObservableList<Media> get mediaIds {
    _$mediaIdsAtom.reportRead();
    return super.mediaIds;
  }

  @override
  set mediaIds(ObservableList<Media> value) {
    _$mediaIdsAtom.reportWrite(value, super.mediaIds, () {
      super.mediaIds = value;
    });
  }

  final _$_WorkerStoreActionController = ActionController(name: '_WorkerStore');

  @override
  void setOpinion(String value) {
    final _$actionInfo = _$_WorkerStoreActionController.startAction(
        name: '_WorkerStore.setOpinion');
    try {
      return super.setOpinion(value);
    } finally {
      _$_WorkerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeQuest(dynamic json) {
    final _$actionInfo = _$_WorkerStoreActionController.startAction(
        name: '_WorkerStore.changeQuest');
    try {
      return super.changeQuest(json);
    } finally {
      _$_WorkerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
opinion: ${opinion},
response: ${response},
mediaFile: ${mediaFile},
mediaIds: ${mediaIds}
    ''';
  }
}
