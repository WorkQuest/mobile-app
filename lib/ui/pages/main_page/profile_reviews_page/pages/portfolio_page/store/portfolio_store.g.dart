// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PortfolioStore on _PortfolioStore, Store {
  final _$pageNumberAtom = Atom(name: '_PortfolioStore.pageNumber');

  @override
  int get pageNumber {
    _$pageNumberAtom.reportRead();
    return super.pageNumber;
  }

  @override
  set pageNumber(int value) {
    _$pageNumberAtom.reportWrite(value, super.pageNumber, () {
      super.pageNumber = value;
    });
  }

  final _$_PortfolioStoreActionController =
      ActionController(name: '_PortfolioStore');

  @override
  void changePageNumber(int number) {
    final _$actionInfo = _$_PortfolioStoreActionController.startAction(
        name: '_PortfolioStore.changePageNumber');
    try {
      return super.changePageNumber(number);
    } finally {
      _$_PortfolioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pageNumber: ${pageNumber}
    ''';
  }
}
