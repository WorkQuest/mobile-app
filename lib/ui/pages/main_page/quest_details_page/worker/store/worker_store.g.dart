// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WorkerStore on _WorkerStore, Store {
  final _$mediaAtom = Atom(name: '_WorkerStore.media');

  @override
  ObservableList<DrishyaEntity> get media {
    _$mediaAtom.reportRead();
    return super.media;
  }

  @override
  set media(ObservableList<DrishyaEntity> value) {
    _$mediaAtom.reportWrite(value, super.media, () {
      super.media = value;
    });
  }

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
  String toString() {
    return '''
media: ${media},
opinion: ${opinion},
response: ${response}
    ''';
  }
}
