// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$TransferStore on TransferStoreBase, Store {
  Computed<bool>? _$statusButtonTransferComputed;

  @override
  bool get statusButtonTransfer => (_$statusButtonTransferComputed ??=
          Computed<bool>(() => super.statusButtonTransfer,
              name: 'TransferStoreBase.statusButtonTransfer'))
      .value;

  final _$maxAmountAtom = Atom(name: 'TransferStoreBase.maxAmount');

  @override
  double? get maxAmount {
    _$maxAmountAtom.reportRead();
    return super.maxAmount;
  }

  @override
  set maxAmount(double? value) {
    _$maxAmountAtom.reportWrite(value, super.maxAmount, () {
      super.maxAmount = value;
    });
  }

  final _$currentCoinAtom = Atom(name: 'TransferStoreBase.currentCoin');

  @override
  CoinItem? get currentCoin {
    _$currentCoinAtom.reportRead();
    return super.currentCoin;
  }

  @override
  set currentCoin(CoinItem? value) {
    _$currentCoinAtom.reportWrite(value, super.currentCoin, () {
      super.currentCoin = value;
    });
  }

  final _$addressToAtom = Atom(name: 'TransferStoreBase.addressTo');

  @override
  String get addressTo {
    _$addressToAtom.reportRead();
    return super.addressTo;
  }

  @override
  set addressTo(String value) {
    _$addressToAtom.reportWrite(value, super.addressTo, () {
      super.addressTo = value;
    });
  }

  final _$amountAtom = Atom(name: 'TransferStoreBase.amount');

  @override
  String get amount {
    _$amountAtom.reportRead();
    return super.amount;
  }

  @override
  set amount(String value) {
    _$amountAtom.reportWrite(value, super.amount, () {
      super.amount = value;
    });
  }

  final _$feeAtom = Atom(name: 'TransferStoreBase.fee');

  @override
  String get fee {
    _$feeAtom.reportRead();
    return super.fee;
  }

  @override
  set fee(String value) {
    _$feeAtom.reportWrite(value, super.fee, () {
      super.fee = value;
    });
  }

  final _$setCoinAsyncAction = AsyncAction('TransferStoreBase.setCoin');

  @override
  Future setCoin(CoinItem? value) {
    return _$setCoinAsyncAction.run(() => super.setCoin(value));
  }

  final _$getMaxAmountAsyncAction =
      AsyncAction('TransferStoreBase.getMaxAmount');

  @override
  Future getMaxAmount() {
    return _$getMaxAmountAsyncAction.run(() => super.getMaxAmount());
  }

  final _$getFeeAsyncAction = AsyncAction('TransferStoreBase.getFee');

  @override
  Future getFee() {
    return _$getFeeAsyncAction.run(() => super.getFee());
  }

  late final _$checkBeforeSendAsyncAction =
  AsyncAction('TransferStoreBase.checkBeforeSend', context: context);

  @override
  Future checkBeforeSend() {
    return _$checkBeforeSendAsyncAction.run(() => super.checkBeforeSend());
  }

  final _$TransferStoreBaseActionController =
      ActionController(name: 'TransferStoreBase');

  @override
  dynamic setAddressTo(String value) {
    final _$actionInfo = _$TransferStoreBaseActionController.startAction(
        name: 'TransferStoreBase.setAddressTo');
    try {
      return super.setAddressTo(value);
    } finally {
      _$TransferStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setAmount(String value) {
    final _$actionInfo = _$TransferStoreBaseActionController.startAction(
        name: 'TransferStoreBase.setAmount');
    try {
      return super.setAmount(value);
    } finally {
      _$TransferStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setFee(String value) {
    final _$actionInfo = _$TransferStoreBaseActionController.startAction(
        name: 'TransferStoreBase.setFee');
    try {
      return super.setFee(value);
    } finally {
      _$TransferStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic clearData() {
    final _$actionInfo = _$TransferStoreBaseActionController.startAction(
        name: 'TransferStoreBase.clearData');
    try {
      return super.clearData();
    } finally {
      _$TransferStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
maxAmount: ${maxAmount},
currentCoin: ${currentCoin},
addressTo: ${addressTo},
amount: ${amount},
fee: ${fee},
statusButtonTransfer: ${statusButtonTransfer}
    ''';
  }
}
