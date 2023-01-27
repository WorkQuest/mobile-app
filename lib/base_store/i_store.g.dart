// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'i_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$IStore<T> on _IStore<T>, Store {
  Computed<bool>? _$isSuccessComputed;

  @override
  bool get isSuccess => (_$isSuccessComputed ??=
          Computed<bool>(() => super.isSuccess, name: '_IStore.isSuccess'))
      .value;

  final _$isLoadingAtom = Atom(name: '_IStore.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$successDataAtom = Atom(name: '_IStore.successData');

  @override
  T? get successData {
    _$successDataAtom.reportRead();
    return super.successData;
  }

  @override
  set successData(T? value) {
    _$successDataAtom.reportWrite(value, super.successData, () {
      super.successData = value;
    });
  }

  final _$errorMessageAtom = Atom(name: '_IStore.errorMessage');

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
successData: ${successData},
errorMessage: ${errorMessage},
isSuccess: ${isSuccess}
    ''';
  }
}
