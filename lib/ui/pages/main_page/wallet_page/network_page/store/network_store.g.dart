// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$NetworkStore on _NetworkStoreBase, Store {
  final _$networkAtom = Atom(name: '_NetworkStoreBase.network');

  @override
  Network? get network {
    _$networkAtom.reportRead();
    return super.network;
  }

  @override
  set network(Network? value) {
    _$networkAtom.reportWrite(value, super.network, () {
      super.network = value;
    });
  }

  final _$changeNetworkAsyncAction =
      AsyncAction('_NetworkStoreBase.changeNetwork');

  @override
  Future changeNetwork(Network newNetwork) {
    return _$changeNetworkAsyncAction
        .run(() => super.changeNetwork(newNetwork));
  }

  final _$_NetworkStoreBaseActionController =
      ActionController(name: '_NetworkStoreBase');

  @override
  dynamic setNetwork(Network value) {
    final _$actionInfo = _$_NetworkStoreBaseActionController.startAction(
        name: '_NetworkStoreBase.setNetwork');
    try {
      return super.setNetwork(value);
    } finally {
      _$_NetworkStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
network: ${network}
    ''';
  }
}
