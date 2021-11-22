// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatRoomStore on _ChatRoomStore, Store {
  Computed<Chats?>? _$chatComputed;

  @override
  Chats? get chat => (_$chatComputed ??=
          Computed<Chats?>(() => super.chat, name: '_ChatRoomStore.chat'))
      .value;

  final _$_myIdAtom = Atom(name: '_ChatRoomStore._myId');

  @override
  String get _myId {
    _$_myIdAtom.reportRead();
    return super._myId;
  }

  @override
  set _myId(String value) {
    _$_myIdAtom.reportWrite(value, super._myId, () {
      super._myId = value;
    });
  }

  final _$isLoadingMessagesAtom =
      Atom(name: '_ChatRoomStore.isLoadingMessages');

  @override
  bool get isLoadingMessages {
    _$isLoadingMessagesAtom.reportRead();
    return super.isLoadingMessages;
  }

  @override
  set isLoadingMessages(bool value) {
    _$isLoadingMessagesAtom.reportWrite(value, super.isLoadingMessages, () {
      super.isLoadingMessages = value;
    });
  }

  final _$refreshAtom = Atom(name: '_ChatRoomStore.refresh');

  @override
  bool get refresh {
    _$refreshAtom.reportRead();
    return super.refresh;
  }

  @override
  set refresh(bool value) {
    _$refreshAtom.reportWrite(value, super.refresh, () {
      super.refresh = value;
    });
  }

  final _$flagAtom = Atom(name: '_ChatRoomStore.flag');

  @override
  bool get flag {
    _$flagAtom.reportRead();
    return super.flag;
  }

  @override
  set flag(bool value) {
    _$flagAtom.reportWrite(value, super.flag, () {
      super.flag = value;
    });
  }

  final _$getMessagesAsyncAction = AsyncAction('_ChatRoomStore.getMessages');

  @override
  Future getMessages() {
    return _$getMessagesAsyncAction.run(() => super.getMessages());
  }

  final _$sendMessageAsyncAction = AsyncAction('_ChatRoomStore.sendMessage');

  @override
  Future<dynamic> sendMessage(String text, String chatId, String userId) {
    return _$sendMessageAsyncAction
        .run(() => super.sendMessage(text, chatId, userId));
  }

  final _$_ChatRoomStoreActionController =
      ActionController(name: '_ChatRoomStore');

  @override
  void updateMessages(List<MessageModel> msg) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
        name: '_ChatRoomStore.updateMessages');
    try {
      return super.updateMessages(msg);
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadChat(String chatId) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
        name: '_ChatRoomStore.loadChat');
    try {
      return super.loadChat(chatId);
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoadingMessages: ${isLoadingMessages},
refresh: ${refresh},
flag: ${flag},
chat: ${chat}
    ''';
  }
}
