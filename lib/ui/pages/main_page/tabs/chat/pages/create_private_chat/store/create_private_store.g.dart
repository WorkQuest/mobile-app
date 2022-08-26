// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_private_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CreatePrivateStore on _CreatePrivateStore, Store {
  final _$messageAtom = Atom(name: '_CreatePrivateStore.message');

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

  final _$chatIdAtom = Atom(name: '_CreatePrivateStore.chatId');

  @override
  String get chatId {
    _$chatIdAtom.reportRead();
    return super.chatId;
  }

  @override
  set chatId(String value) {
    _$chatIdAtom.reportWrite(value, super.chatId, () {
      super.chatId = value;
    });
  }

  final _$sendMessageAsyncAction =
      AsyncAction('_CreatePrivateStore.sendMessage');

  @override
  Future<void> sendMessage(String userId) {
    return _$sendMessageAsyncAction.run(() => super.sendMessage(userId));
  }

  final _$_CreatePrivateStoreActionController =
      ActionController(name: '_CreatePrivateStore');

  @override
  void setMessage(String text) {
    final _$actionInfo = _$_CreatePrivateStoreActionController.startAction(
        name: '_CreatePrivateStore.setMessage');
    try {
      return super.setMessage(text);
    } finally {
      _$_CreatePrivateStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
message: ${message},
chatId: ${chatId}
    ''';
  }
}
