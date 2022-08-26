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

  final _$portfolioListAtom = Atom(name: '_PortfolioStore.portfolioList');

  @override
  ObservableList<PortfolioModel> get portfolioList {
    _$portfolioListAtom.reportRead();
    return super.portfolioList;
  }

  @override
  set portfolioList(ObservableList<PortfolioModel> value) {
    _$portfolioListAtom.reportWrite(value, super.portfolioList, () {
      super.portfolioList = value;
    });
  }

  final _$reviewsListAtom = Atom(name: '_PortfolioStore.reviewsList');

  @override
  ObservableList<Review> get reviewsList {
    _$reviewsListAtom.reportRead();
    return super.reviewsList;
  }

  @override
  set reviewsList(ObservableList<Review> value) {
    _$reviewsListAtom.reportWrite(value, super.reviewsList, () {
      super.reviewsList = value;
    });
  }

  final _$deletePortfolioAsyncAction =
      AsyncAction('_PortfolioStore.deletePortfolio');

  @override
  Future deletePortfolio(
      {required String portfolioId, required String userId}) {
    return _$deletePortfolioAsyncAction.run(
        () => super.deletePortfolio(portfolioId: portfolioId, userId: userId));
  }

  final _$getPortfolioAsyncAction = AsyncAction('_PortfolioStore.getPortfolio');

  @override
  Future getPortfolio({required String userId, bool isForce = false}) {
    return _$getPortfolioAsyncAction
        .run(() => super.getPortfolio(userId: userId, isForce: isForce));
  }

  final _$getReviewsAsyncAction = AsyncAction('_PortfolioStore.getReviews');

  @override
  Future getReviews({required String userId, bool isForce = false}) {
    return _$getReviewsAsyncAction
        .run(() => super.getReviews(userId: userId, isForce: isForce));
  }

  final _$_PortfolioStoreActionController =
      ActionController(name: '_PortfolioStore');

  @override
  dynamic changePageNumber(int value) {
    final _$actionInfo = _$_PortfolioStoreActionController.startAction(
        name: '_PortfolioStore.changePageNumber');
    try {
      return super.changePageNumber(value);
    } finally {
      _$_PortfolioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addPortfolio(PortfolioModel portfolio) {
    final _$actionInfo = _$_PortfolioStoreActionController.startAction(
        name: '_PortfolioStore.addPortfolio');
    try {
      return super.addPortfolio(portfolio);
    } finally {
      _$_PortfolioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
pageNumber: ${pageNumber},
portfolioList: ${portfolioList},
reviewsList: ${reviewsList}
    ''';
  }
}
