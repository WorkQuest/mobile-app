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

  final _$chatsIdAtom = Atom(name: '_ChatStore.chatsId');

  @override
  ObservableList<String> get chatsId {
    _$chatsIdAtom.reportRead();
    return super.chatsId;
  }

  @override
  set chatsId(ObservableList<String> value) {
    _$chatsIdAtom.reportWrite(value, super.chatsId, () {
      super.chatsId = value;
    });
  }

  final _$idChatsForStarAtom = Atom(name: '_ChatStore.idChatsForStar');

  @override
  ObservableMap<String, bool> get idChatsForStar {
    _$idChatsForStarAtom.reportRead();
    return super.idChatsForStar;
  }

  @override
  set idChatsForStar(ObservableMap<String, bool> value) {
    _$idChatsForStarAtom.reportWrite(value, super.idChatsForStar, () {
      super.idChatsForStar = value;
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

  final _$setStarAsyncAction = AsyncAction('_ChatStore.setStar');

  @override
  Future<dynamic> setStar() {
    return _$setStarAsyncAction.run(() => super.setStar());
  }

  final _$loadChatsAsyncAction = AsyncAction('_ChatStore.loadChats');

  @override
  Future<dynamic> loadChats({bool loadMore = false, bool? starred, String query = ''}) {
    return _$loadChatsAsyncAction
        .run(() => super.loadChats(loadMore: loadMore, starred: starred, query: query));
  }

  final _$getUserDataAsyncAction = AsyncAction('_ChatStore.getUserData');

  @override
  Future<dynamic> getUserData(String idUser) {
    return _$getUserDataAsyncAction.run(() => super.getUserData(idUser));
  }

  final _$setMessageReadAsyncAction = AsyncAction('_ChatStore.setMessageRead');

  @override
  Future<dynamic> setMessageRead(String chatId, String messageId) {
    return _$setMessageReadAsyncAction
        .run(() => super.setMessageRead(chatId, messageId));
  }

  final _$_ChatStoreActionController = ActionController(name: '_ChatStore');

  @override
  void chatSort() {
    final _$actionInfo =
        _$_ChatStoreActionController.startAction(name: '_ChatStore.chatSort');
    try {
      return super.chatSort();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic uncheck() {
    final _$actionInfo =
        _$_ChatStoreActionController.startAction(name: '_ChatStore.uncheck');
    try {
      return super.uncheck();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setChatSelected(bool value) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.setChatSelected');
    try {
      return super.setChatSelected(value);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setChatHighlighted(Chats chatDetails) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.setChatHighlighted');
    try {
      return super.setChatHighlighted(chatDetails);
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
idChat: ${idChat},
chatSelected: ${chatSelected},
chatsId: ${chatsId},
idChatsForStar: ${idChatsForStar},
infoMessageValue: ${infoMessageValue},
isLoadingChats: ${isLoadingChats},
refresh: ${refresh}
    ''';
  }
}
