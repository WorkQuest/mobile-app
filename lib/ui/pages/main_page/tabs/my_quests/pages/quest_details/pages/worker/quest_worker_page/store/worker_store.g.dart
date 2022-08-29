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

  final _$questAtom = Atom(name: '_WorkerStore.quest');

  @override
  Observable<BaseQuestResponse?> get quest {
    _$questAtom.reportRead();
    return super.quest;
  }

  @override
  set quest(Observable<BaseQuestResponse?> value) {
    _$questAtom.reportWrite(value, super.quest, () {
      super.quest = value;
    });
  }

  final _$getQuestAsyncAction = AsyncAction('_WorkerStore.getQuest');

  @override
  Future getQuest(String questId) {
    return _$getQuestAsyncAction.run(() => super.getQuest(questId));
  }

  final _$onStarAsyncAction = AsyncAction('_WorkerStore.onStar');

  @override
  Future onStar() {
    return _$onStarAsyncAction.run(() => super.onStar());
  }

  final _$sendAcceptOnQuestAsyncAction =
      AsyncAction('_WorkerStore.sendAcceptOnQuest');

  @override
  Future sendAcceptOnQuest() {
    return _$sendAcceptOnQuestAsyncAction.run(() => super.sendAcceptOnQuest());
  }

  final _$acceptInviteAsyncAction = AsyncAction('_WorkerStore.acceptInvite');

  @override
  Future acceptInvite(String responseId) {
    return _$acceptInviteAsyncAction.run(() => super.acceptInvite(responseId));
  }

  final _$rejectInviteAsyncAction = AsyncAction('_WorkerStore.rejectInvite');

  @override
  Future rejectInvite(String responseId) {
    return _$rejectInviteAsyncAction.run(() => super.rejectInvite(responseId));
  }

  final _$sendCompleteWorkAsyncAction =
      AsyncAction('_WorkerStore.sendCompleteWork');

  @override
  Future sendCompleteWork() {
    return _$sendCompleteWorkAsyncAction.run(() => super.sendCompleteWork());
  }

  final _$sendRespondOnQuestAsyncAction =
      AsyncAction('_WorkerStore.sendRespondOnQuest');

  @override
  Future sendRespondOnQuest(String message) {
    return _$sendRespondOnQuestAsyncAction
        .run(() => super.sendRespondOnQuest(message));
  }

  final _$_WorkerStoreActionController = ActionController(name: '_WorkerStore');

  @override
  dynamic setOpinion(String value) {
    final _$actionInfo = _$_WorkerStoreActionController.startAction(
        name: '_WorkerStore.setOpinion');
    try {
      return super.setOpinion(value);
    } finally {
      _$_WorkerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeQuest(dynamic json) {
    final _$actionInfo = _$_WorkerStoreActionController.startAction(
        name: '_WorkerStore.changeQuest');
    try {
      return super.changeQuest(json);
    } finally {
      _$_WorkerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setQuestStatus(int value) {
    final _$actionInfo = _$_WorkerStoreActionController.startAction(
        name: '_WorkerStore.setQuestStatus');
    try {
      return super.setQuestStatus(value);
    } finally {
      _$_WorkerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
opinion: ${opinion},
mediaFile: ${mediaFile},
mediaIds: ${mediaIds},
quest: ${quest}
    ''';
  }
}
