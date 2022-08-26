// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_review_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CreateReviewStore on _CreateReviewStore, Store {
  final _$messageAtom = Atom(name: '_CreateReviewStore.message');

  @override
  String get message {
    _$messageAtom.reportRead();
    return super.message;
  }

  @override
  set message(String value) {
    _$messageAtom.reportWrite(value, super.message, () {
      super.message = value;
    });
  }

  final _$markAtom = Atom(name: '_CreateReviewStore.mark');

  @override
  int get mark {
    _$markAtom.reportRead();
    return super.mark;
  }

  @override
  set mark(int value) {
    _$markAtom.reportWrite(value, super.mark, () {
      super.mark = value;
    });
  }

  final _$starAtom = Atom(name: '_CreateReviewStore.star');

  @override
  ObservableList<bool> get star {
    _$starAtom.reportRead();
    return super.star;
  }

  @override
  set star(ObservableList<bool> value) {
    _$starAtom.reportWrite(value, super.star, () {
      super.star = value;
    });
  }

  final _$addReviewAsyncAction = AsyncAction('_CreateReviewStore.addReview');

  @override
  Future<void> addReview(String questId) {
    return _$addReviewAsyncAction.run(() => super.addReview(questId));
  }

  final _$addReviewDisputeAsyncAction =
      AsyncAction('_CreateReviewStore.addReviewDispute');

  @override
  Future<void> addReviewDispute(String disputeId) {
    return _$addReviewDisputeAsyncAction
        .run(() => super.addReviewDispute(disputeId));
  }

  final _$_CreateReviewStoreActionController =
      ActionController(name: '_CreateReviewStore');

  @override
  void setStar() {
    final _$actionInfo = _$_CreateReviewStoreActionController.startAction(
        name: '_CreateReviewStore.setStar');
    try {
      return super.setStar();
    } finally {
      _$_CreateReviewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMessage(String value) {
    final _$actionInfo = _$_CreateReviewStoreActionController.startAction(
        name: '_CreateReviewStore.setMessage');
    try {
      return super.setMessage(value);
    } finally {
      _$_CreateReviewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
message: ${message},
mark: ${mark},
star: ${star}
    ''';
  }
}
