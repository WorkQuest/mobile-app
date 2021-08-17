// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatRoomStore on _ChatRoomStore, Store {
  final _$chatAtom = Atom(name: '_ChatRoomStore.chat');

  @override
  ChatModel? get chat {
    _$chatAtom.reportRead();
    return super.chat;
  }

  @override
  set chat(ChatModel? value) {
    _$chatAtom.reportWrite(value, super.chat, () {
      super.chat = value;
    });
  }

  final _$isloadingMessagesAtom =
      Atom(name: '_ChatRoomStore.isloadingMessages');

  @override
  bool get isloadingMessages {
    _$isloadingMessagesAtom.reportRead();
    return super.isloadingMessages;
  }

  @override
  set isloadingMessages(bool value) {
    _$isloadingMessagesAtom.reportWrite(value, super.isloadingMessages, () {
      super.isloadingMessages = value;
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
chat: ${chat},
isloadingMessages: ${isloadingMessages}
    ''';
  }
}
