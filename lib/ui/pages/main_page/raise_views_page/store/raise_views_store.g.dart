// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raise_views_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$RaiseViewStore on _RaiseViewStore, Store {
  Computed<bool>? _$canSubmitComputed;

  @override
  bool get canSubmit =>
      (_$canSubmitComputed ??= Computed<bool>(() => super.canSubmit,
              name: '_RaiseViewStore.canSubmit'))
          .value;

  final _$typeCoinAtom = Atom(name: '_RaiseViewStore.typeCoin');

  @override
  TYPE_COINS? get typeCoin {
    _$typeCoinAtom.reportRead();
    return super.typeCoin;
  }

  @override
  set typeCoin(TYPE_COINS? value) {
    _$typeCoinAtom.reportWrite(value, super.typeCoin, () {
      super.typeCoin = value;
    });
  }

  final _$typeWalletAtom = Atom(name: '_RaiseViewStore.typeWallet');

  @override
  TYPE_WALLET? get typeWallet {
    _$typeWalletAtom.reportRead();
    return super.typeWallet;
  }

  @override
  set typeWallet(TYPE_WALLET? value) {
    _$typeWalletAtom.reportWrite(value, super.typeWallet, () {
      super.typeWallet = value;
    });
  }

  final _$periodGroupValueAtom = Atom(name: '_RaiseViewStore.periodGroupValue');

  @override
  int get periodGroupValue {
    _$periodGroupValueAtom.reportRead();
    return super.periodGroupValue;
  }

  @override
  set periodGroupValue(int value) {
    _$periodGroupValueAtom.reportWrite(value, super.periodGroupValue, () {
      super.periodGroupValue = value;
    });
  }

  final _$levelGroupValueAtom = Atom(name: '_RaiseViewStore.levelGroupValue');

  @override
  int get levelGroupValue {
    _$levelGroupValueAtom.reportRead();
    return super.levelGroupValue;
  }

  @override
  set levelGroupValue(int value) {
    _$levelGroupValueAtom.reportWrite(value, super.levelGroupValue, () {
      super.levelGroupValue = value;
    });
  }

  final _$raiseProfileAsyncAction = AsyncAction('_RaiseViewStore.raiseProfile');

  @override
  Future<void> raiseProfile() {
    return _$raiseProfileAsyncAction.run(() => super.raiseProfile());
  }

  final _$raiseQuestAsyncAction = AsyncAction('_RaiseViewStore.raiseQuest');

  @override
  Future<void> raiseQuest(String questId) {
    return _$raiseQuestAsyncAction.run(() => super.raiseQuest(questId));
  }

  final _$_RaiseViewStoreActionController =
      ActionController(name: '_RaiseViewStore');

  @override
  dynamic setTitleSelectedCoin(TYPE_COINS? value) {
    final _$actionInfo = _$_RaiseViewStoreActionController.startAction(
        name: '_RaiseViewStore.setTitleSelectedCoin');
    try {
      return super.setTitleSelectedCoin(value);
    } finally {
      _$_RaiseViewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setTitleSelectedWallet(TYPE_WALLET? value) {
    final _$actionInfo = _$_RaiseViewStoreActionController.startAction(
        name: '_RaiseViewStore.setTitleSelectedWallet');
    try {
      return super.setTitleSelectedWallet(value);
    } finally {
      _$_RaiseViewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void initPrice() {
    final _$actionInfo = _$_RaiseViewStoreActionController.startAction(
        name: '_RaiseViewStore.initPrice');
    try {
      return super.initPrice();
    } finally {
      _$_RaiseViewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changePeriod(int? value) {
    final _$actionInfo = _$_RaiseViewStoreActionController.startAction(
        name: '_RaiseViewStore.changePeriod');
    try {
      return super.changePeriod(value);
    } finally {
      _$_RaiseViewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic changeLevel(int? value) {
    final _$actionInfo = _$_RaiseViewStoreActionController.startAction(
        name: '_RaiseViewStore.changeLevel');
    try {
      return super.changeLevel(value);
    } finally {
      _$_RaiseViewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
typeCoin: ${typeCoin},
typeWallet: ${typeWallet},
periodGroupValue: ${periodGroupValue},
levelGroupValue: ${levelGroupValue},
canSubmit: ${canSubmit}
    ''';
  }
}
