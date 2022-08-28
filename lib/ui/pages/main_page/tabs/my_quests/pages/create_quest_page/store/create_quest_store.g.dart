// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_quest_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CreateQuestStore on _CreateQuestStore, Store {
  final _$questAtom = Atom(name: '_CreateQuestStore.quest');

  @override
  CreateQuestRequestModel get quest {
    _$questAtom.reportRead();
    return super.quest;
  }

  @override
  set quest(CreateQuestRequestModel value) {
    _$questAtom.reportWrite(value, super.quest, () {
      super.quest = value;
    });
  }

  final _$confirmUnderstandAboutEditAtom =
      Atom(name: '_CreateQuestStore.confirmUnderstandAboutEdit');

  @override
  bool get confirmUnderstandAboutEdit {
    _$confirmUnderstandAboutEditAtom.reportRead();
    return super.confirmUnderstandAboutEdit;
  }

  @override
  set confirmUnderstandAboutEdit(bool value) {
    _$confirmUnderstandAboutEditAtom
        .reportWrite(value, super.confirmUnderstandAboutEdit, () {
      super.confirmUnderstandAboutEdit = value;
    });
  }

  final _$skillFiltersAtom = Atom(name: '_CreateQuestStore.skillFilters');

  @override
  List<String> get skillFilters {
    _$skillFiltersAtom.reportRead();
    return super.skillFilters;
  }

  @override
  set skillFilters(List<String> value) {
    _$skillFiltersAtom.reportWrite(value, super.skillFilters, () {
      super.skillFilters = value;
    });
  }

  final _$getPredictionAsyncAction =
      AsyncAction('_CreateQuestStore.getPrediction');

  @override
  Future<Null> getPrediction(BuildContext context) {
    return _$getPredictionAsyncAction.run(() => super.getPrediction(context));
  }

  final _$checkAllowanceAsyncAction =
      AsyncAction('_CreateQuestStore.checkAllowance');

  @override
  Future checkAllowance({String? addressQuest}) {
    return _$checkAllowanceAsyncAction
        .run(() => super.checkAllowance(addressQuest: addressQuest));
  }

  final _$approveAsyncAction = AsyncAction('_CreateQuestStore.approve');

  @override
  Future approve({String? contractAddress}) {
    return _$approveAsyncAction
        .run(() => super.approve(contractAddress: contractAddress));
  }

  final _$editQuestAsyncAction = AsyncAction('_CreateQuestStore.editQuest');

  @override
  Future editQuest({required String questId}) {
    return _$editQuestAsyncAction.run(() => super.editQuest(questId: questId));
  }

  final _$createQuestAsyncAction = AsyncAction('_CreateQuestStore.createQuest');

  @override
  Future createQuest() {
    return _$createQuestAsyncAction.run(() => super.createQuest());
  }

  final _$getGasApproveAsyncAction =
      AsyncAction('_CreateQuestStore.getGasApprove');

  @override
  Future getGasApprove({String? addressQuest}) {
    return _$getGasApproveAsyncAction
        .run(() => super.getGasApprove(addressQuest: addressQuest));
  }

  final _$getGasEditQuestAsyncAction =
      AsyncAction('_CreateQuestStore.getGasEditQuest');

  @override
  Future getGasEditQuest() {
    return _$getGasEditQuestAsyncAction.run(() => super.getGasEditQuest());
  }

  final _$_CreateQuestStoreActionController =
      ActionController(name: '_CreateQuestStore');

  @override
  dynamic initQuest({required BaseQuestResponse? quest}) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.initQuest');
    try {
      return super.initQuest(quest: quest);
    } finally {
      _$_CreateQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setConfirmUnderstandAboutEdit(bool value) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.setConfirmUnderstandAboutEdit');
    try {
      return super.setConfirmUnderstandAboutEdit(value);
    } finally {
      _$_CreateQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setQuestTitle(String value) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.setQuestTitle');
    try {
      return super.setQuestTitle(value);
    } finally {
      _$_CreateQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAboutQuest(String value) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.setAboutQuest');
    try {
      return super.setAboutQuest(value);
    } finally {
      _$_CreateQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPrice(String value) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.setPrice');
    try {
      return super.setPrice(value);
    } finally {
      _$_CreateQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changedPriority(String selectedPriority) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.changedPriority');
    try {
      return super.changedPriority(selectedPriority);
    } finally {
      _$_CreateQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changedEmployment(String selectedEmployment) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.changedEmployment');
    try {
      return super.changedEmployment(selectedEmployment);
    } finally {
      _$_CreateQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changedPayPeriod(String value) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.changedPayPeriod');
    try {
      return super.changedPayPeriod(value);
    } finally {
      _$_CreateQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changedDistantWork(String selectedEmployment) {
    final _$actionInfo = _$_CreateQuestStoreActionController.startAction(
        name: '_CreateQuestStore.changedDistantWork');
    try {
      return super.changedDistantWork(selectedEmployment);
    } finally {
      _$_CreateQuestStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
quest: ${quest},
confirmUnderstandAboutEdit: ${confirmUnderstandAboutEdit},
skillFilters: ${skillFilters}
    ''';
  }
}
