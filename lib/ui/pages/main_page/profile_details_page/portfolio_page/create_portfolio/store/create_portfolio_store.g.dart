// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_portfolio_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CreatePortfolioStore on _CreatePortfolioStore, Store {
  Computed<bool>? _$canSubmitComputed;

  @override
  bool get canSubmit =>
      (_$canSubmitComputed ??= Computed<bool>(() => super.canSubmit,
              name: '_CreatePortfolioStore.canSubmit'))
          .value;

  final _$titleAtom = Atom(name: '_CreatePortfolioStore.title');

  @override
  String get title {
    _$titleAtom.reportRead();
    return super.title;
  }

  @override
  set title(String value) {
    _$titleAtom.reportWrite(value, super.title, () {
      super.title = value;
    });
  }

  final _$descriptionAtom = Atom(name: '_CreatePortfolioStore.description');

  @override
  String get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  final _$createPortfolioAsyncAction =
      AsyncAction('_CreatePortfolioStore.createPortfolio');

  @override
  Future createPortfolio() {
    return _$createPortfolioAsyncAction.run(() => super.createPortfolio());
  }

  final _$editPortfolioAsyncAction =
      AsyncAction('_CreatePortfolioStore.editPortfolio');

  @override
  Future editPortfolio({required String portfolioId}) {
    return _$editPortfolioAsyncAction
        .run(() => super.editPortfolio(portfolioId: portfolioId));
  }

  final _$_CreatePortfolioStoreActionController =
      ActionController(name: '_CreatePortfolioStore');

  @override
  dynamic setTitle(String value) {
    final _$actionInfo = _$_CreatePortfolioStoreActionController.startAction(
        name: '_CreatePortfolioStore.setTitle');
    try {
      return super.setTitle(value);
    } finally {
      _$_CreatePortfolioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setDescription(String value) {
    final _$actionInfo = _$_CreatePortfolioStoreActionController.startAction(
        name: '_CreatePortfolioStore.setDescription');
    try {
      return super.setDescription(value);
    } finally {
      _$_CreatePortfolioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
title: ${title},
description: ${description},
canSubmit: ${canSubmit}
    ''';
  }
}
