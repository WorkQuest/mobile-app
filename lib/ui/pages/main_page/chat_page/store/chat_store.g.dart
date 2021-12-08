// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatStore on _ChatStore, Store {
  final _$unreadAtom = Atom(name: '_ChatStore.unread');

  @override
  bool get unread {
    _$unreadAtom.reportRead();
    return super.unread;
  }

  @override
  set unread(bool value) {
    _$unreadAtom.reportWrite(value, super.unread, () {
      super.unread = value;
    });
  }

  final _$starredAtom = Atom(name: '_ChatStore.starred');

  @override
  bool get starred {
    _$starredAtom.reportRead();
    return super.starred;
  }

  @override
  set starred(bool value) {
    _$starredAtom.reportWrite(value, super.starred, () {
      super.starred = value;
    });
  }

  final _$isChatHighlightedAtom = Atom(name: '_ChatStore.isChatHighlighted');

  @override
  ObservableList<bool> get isChatHighlighted {
    _$isChatHighlightedAtom.reportRead();
    return super.isChatHighlighted;
  }

  @override
  set isChatHighlighted(ObservableList<bool> value) {
    _$isChatHighlightedAtom.reportWrite(value, super.isChatHighlighted, () {
      super.isChatHighlighted = value;
    });
  }

  final _$idChatAtom = Atom(name: '_ChatStore.idChat');

  @override
  ObservableList<String> get idChat {
    _$idChatAtom.reportRead();
    return super.idChat;
  }

  @override
  set idChat(ObservableList<String> value) {
    _$idChatAtom.reportWrite(value, super.idChat, () {
      super.idChat = value;
    });
  }

  final _$chatSelectedAtom = Atom(name: '_ChatStore.chatSelected');

  @override
  bool get chatSelected {
    _$chatSelectedAtom.reportRead();
    return super.chatSelected;
  }

  @override
  set chatSelected(bool value) {
    _$chatSelectedAtom.reportWrite(value, super.chatSelected, () {
      super.chatSelected = value;
    });
  }

  final _$starredChatsAtom = Atom(name: '_ChatStore.starredChats');

  @override
  ObservableList<Chats> get starredChats {
    _$starredChatsAtom.reportRead();
    return super.starredChats;
  }

  @override
  set starredChats(ObservableList<Chats> value) {
    _$starredChatsAtom.reportWrite(value, super.starredChats, () {
      super.starredChats = value;
    });
  }

  final _$infoMessageValueAtom = Atom(name: '_ChatStore.infoMessageValue');

  @override
  String get infoMessageValue {
    _$infoMessageValueAtom.reportRead();
    return super.infoMessageValue;
  }

  @override
  set infoMessageValue(String value) {
    _$infoMessageValueAtom.reportWrite(value, super.infoMessageValue, () {
      super.infoMessageValue = value;
    });
  }

  final _$isLoadingChatsAtom = Atom(name: '_ChatStore.isLoadingChats');

  @override
  bool get isLoadingChats {
    _$isLoadingChatsAtom.reportRead();
    return super.isLoadingChats;
  }

  @override
  set isLoadingChats(bool value) {
    _$isLoadingChatsAtom.reportWrite(value, super.isLoadingChats, () {
      super.isLoadingChats = value;
    });
  }

  final _$refreshAtom = Atom(name: '_ChatStore.refresh');

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

  final _$_countAtom = Atom(name: '_ChatStore._count');

  @override
  int get _count {
    _$_countAtom.reportRead();
    return super._count;
  }

  @override
  set _count(int value) {
    _$_countAtom.reportWrite(value, super._count, () {
      super._count = value;
    });
  }

  final _$loadChatsAsyncAction = AsyncAction('_ChatStore.loadChats');

  @override
  Future<dynamic> loadChats(bool isNewList) {
    return _$loadChatsAsyncAction.run(() => super.loadChats(isNewList));
  }

  final _$setMessageReadAsyncAction = AsyncAction('_ChatStore.setMessageRead');

  @override
  Future<dynamic> setMessageRead(String chatId, String messageId) {
    return _$setMessageReadAsyncAction
        .run(() => super.setMessageRead(chatId, messageId));
  }

  final _$_ChatStoreActionController = ActionController(name: '_ChatStore');

  @override
  dynamic openStarredChats(bool value) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.openStarredChats');
    try {
      return super.openStarredChats(value);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String setInfoMessage(String infoMessage) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.setInfoMessage');
    try {
      return super.setInfoMessage(infoMessage);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void checkMessage() {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.checkMessage');
    try {
      return super.checkMessage();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
unread: ${unread},
starred: ${starred},
isChatHighlighted: ${isChatHighlighted},
idChat: ${idChat},
chatSelected: ${chatSelected},
starredChats: ${starredChats},
infoMessageValue: ${infoMessageValue},
isLoadingChats: ${isLoadingChats},
refresh: ${refresh}
    ''';
  }
}
