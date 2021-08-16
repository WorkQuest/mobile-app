// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatRoomStore on _ChatRoomStore, Store {
  final _$messagesAtom = Atom(name: '_ChatRoomStore.messages');

  @override
  ObservableList<MessageModel>? get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(ObservableList<MessageModel>? value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  final _$loadChatAsyncAction = AsyncAction('_ChatRoomStore.loadChat');

  @override
  Future<dynamic> loadChat() {
    return _$loadChatAsyncAction.run(() => super.loadChat());
  }

  final _$sendMessageAsyncAction = AsyncAction('_ChatRoomStore.sendMessage');

  @override
  Future<dynamic> sendMessage(String text) {
    return _$sendMessageAsyncAction.run(() => super.sendMessage(text));
  }

  @override
  String toString() {
    return '''
messages: ${messages}
    ''';
  }
}
