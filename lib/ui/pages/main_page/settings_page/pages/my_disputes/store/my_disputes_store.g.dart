// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_disputes_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MyDisputesStore on _MyDisputesStore, Store {
  final _$disputesAtom = Atom(name: '_MyDisputesStore.disputes');

  @override
  ObservableList<DisputeModel> get disputes {
    _$disputesAtom.reportRead();
    return super.disputes;
  }

  @override
  set disputes(ObservableList<DisputeModel> value) {
    _$disputesAtom.reportWrite(value, super.disputes, () {
      super.disputes = value;
    });
  }

  final _$getDisputesAsyncAction = AsyncAction('_MyDisputesStore.getDisputes');

  @override
  Future<void> getDisputes() {
    return _$getDisputesAsyncAction.run(() => super.getDisputes());
  }

  final _$getDisputeAsyncAction = AsyncAction('_MyDisputesStore.getDispute');

  @override
  Future<void> getDispute(String disputeId) {
    return _$getDisputeAsyncAction.run(() => super.getDispute(disputeId));
  }

  @override
  String toString() {
    return '''
disputes: ${disputes}
    ''';
  }
}
