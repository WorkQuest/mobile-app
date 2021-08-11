// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw_page_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$WithdrawPageStore on _WithdrawPageStore, Store {
  Computed<bool>? _$canSubmitComputed;

  @override
  bool get canSubmit =>
      (_$canSubmitComputed ??= Computed<bool>(() => super.canSubmit,
              name: '_WithdrawPageStore.canSubmit'))
          .value;

  final _$_recipientAddressAtom =
      Atom(name: '_WithdrawPageStore._recipientAddress');

  @override
  String get _recipientAddress {
    _$_recipientAddressAtom.reportRead();
    return super._recipientAddress;
  }

  @override
  set _recipientAddress(String value) {
    _$_recipientAddressAtom.reportWrite(value, super._recipientAddress, () {
      super._recipientAddress = value;
    });
  }

  final _$_amountAtom = Atom(name: '_WithdrawPageStore._amount');

  @override
  String get _amount {
    _$_amountAtom.reportRead();
    return super._amount;
  }

  @override
  set _amount(String value) {
    _$_amountAtom.reportWrite(value, super._amount, () {
      super._amount = value;
    });
  }

  final _$_WithdrawPageStoreActionController =
      ActionController(name: '_WithdrawPageStore');

  @override
  void setRecipientAddress(String value) {
    final _$actionInfo = _$_WithdrawPageStoreActionController.startAction(
        name: '_WithdrawPageStore.setRecipientAddress');
    try {
      return super.setRecipientAddress(value);
    } finally {
      _$_WithdrawPageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAmount(String value) {
    final _$actionInfo = _$_WithdrawPageStoreActionController.startAction(
        name: '_WithdrawPageStore.setAmount');
    try {
      return super.setAmount(value);
    } finally {
      _$_WithdrawPageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String getAmount() {
    final _$actionInfo = _$_WithdrawPageStoreActionController.startAction(
        name: '_WithdrawPageStore.getAmount');
    try {
      return super.getAmount();
    } finally {
      _$_WithdrawPageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String getAddress() {
    final _$actionInfo = _$_WithdrawPageStoreActionController.startAction(
        name: '_WithdrawPageStore.getAddress');
    try {
      return super.getAddress();
    } finally {
      _$_WithdrawPageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
canSubmit: ${canSubmit}
    ''';
  }
}
