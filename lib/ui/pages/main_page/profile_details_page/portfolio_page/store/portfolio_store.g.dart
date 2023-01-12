// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PortfolioStore on _PortfolioStore, Store {
  Computed<bool>? _$canSubmitComputed;

  @override
  bool get canSubmit =>
      (_$canSubmitComputed ??= Computed<bool>(() => super.canSubmit,
              name: '_PortfolioStore.canSubmit'))
          .value;

  final _$tabBarScrollingAtom = Atom(name: '_PortfolioStore.tabBarScrolling');

  @override
  bool get tabBarScrolling {
    _$tabBarScrollingAtom.reportRead();
    return super.tabBarScrolling;
  }

  @override
  set tabBarScrolling(bool value) {
    _$tabBarScrollingAtom.reportWrite(value, super.tabBarScrolling, () {
      super.tabBarScrolling = value;
    });
  }

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

  final _$titleAtom = Atom(name: '_PortfolioStore.title');

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

  final _$descriptionAtom = Atom(name: '_PortfolioStore.description');

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

  final _$mediaIdsAtom = Atom(name: '_PortfolioStore.mediaIds');

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

  final _$mediaAtom = Atom(name: '_PortfolioStore.media');

  @override
  ObservableList<File> get media {
    _$mediaAtom.reportRead();
    return super.media;
  }

  @override
  set media(ObservableList<File> value) {
    _$mediaAtom.reportWrite(value, super.media, () {
      super.media = value;
    });
  }

  final _$createPortfolioAsyncAction =
      AsyncAction('_PortfolioStore.createPortfolio');

  @override
  Future<void> createPortfolio({required String userId}) {
    return _$createPortfolioAsyncAction
        .run(() => super.createPortfolio(userId: userId));
  }

  final _$editPortfolioAsyncAction =
      AsyncAction('_PortfolioStore.editPortfolio');

  @override
  Future<void> editPortfolio(
      {required String portfolioId, required String userId}) {
    return _$editPortfolioAsyncAction.run(
        () => super.editPortfolio(portfolioId: portfolioId, userId: userId));
  }

  final _$deletePortfolioAsyncAction =
      AsyncAction('_PortfolioStore.deletePortfolio');

  @override
  Future<void> deletePortfolio(
      {required String portfolioId, required String userId}) {
    return _$deletePortfolioAsyncAction.run(
        () => super.deletePortfolio(portfolioId: portfolioId, userId: userId));
  }

  final _$getPortfolioAsyncAction = AsyncAction('_PortfolioStore.getPortfolio');

  @override
  Future<void> getPortfolio({required String userId, required bool newList}) {
    return _$getPortfolioAsyncAction
        .run(() => super.getPortfolio(userId: userId, newList: newList));
  }

  final _$getReviewsAsyncAction = AsyncAction('_PortfolioStore.getReviews');

  @override
  Future<void> getReviews({required String userId, required bool newList}) {
    return _$getReviewsAsyncAction
        .run(() => super.getReviews(userId: userId, newList: newList));
  }

  final _$_PortfolioStoreActionController =
      ActionController(name: '_PortfolioStore');

  @override
  void setScrolling(bool value) {
    final _$actionInfo = _$_PortfolioStoreActionController.startAction(
        name: '_PortfolioStore.setScrolling');
    try {
      return super.setScrolling(value);
    } finally {
      _$_PortfolioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changePageNumber(int value) {
    final _$actionInfo = _$_PortfolioStoreActionController.startAction(
        name: '_PortfolioStore.changePageNumber');
    try {
      return super.changePageNumber(value);
    } finally {
      _$_PortfolioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTitle(String value) {
    final _$actionInfo = _$_PortfolioStoreActionController.startAction(
        name: '_PortfolioStore.setTitle');
    try {
      return super.setTitle(value);
    } finally {
      _$_PortfolioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescription(String value) {
    final _$actionInfo = _$_PortfolioStoreActionController.startAction(
        name: '_PortfolioStore.setDescription');
    try {
      return super.setDescription(value);
    } finally {
      _$_PortfolioStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tabBarScrolling: ${tabBarScrolling},
pageNumber: ${pageNumber},
title: ${title},
description: ${description},
portfolioList: ${portfolioList},
reviewsList: ${reviewsList},
mediaIds: ${mediaIds},
media: ${media},
canSubmit: ${canSubmit}
    ''';
  }
}
