// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatStore on _ChatStore, Store {
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

  final _$chatsAtom = Atom(name: '_ChatStore.chats');

  @override
  ObservableMap<TypeChat, Chats> get chats {
    _$chatsAtom.reportRead();
    return super.chats;
  }

  @override
  set chats(ObservableMap<TypeChat, Chats> value) {
    _$chatsAtom.reportWrite(value, super.chats, () {
      super.chats = value;
    });
  }

  final _$typeChatAtom = Atom(name: '_ChatStore.typeChat');

  @override
  TypeChat get typeChat {
    _$typeChatAtom.reportRead();
    return super.typeChat;
  }

  @override
  set typeChat(TypeChat value) {
    _$typeChatAtom.reportWrite(value, super.typeChat, () {
      super.typeChat = value;
    });
  }

  final _$loadChatsAsyncAction = AsyncAction('_ChatStore.loadChats');

  @override
  Future<void> loadChats(
      {bool loadMore = false,
      bool? starred,
      String query = '',
      TypeChat type = TypeChat.all,
      int? questChatStatus}) {
    return _$loadChatsAsyncAction.run(() => super.loadChats(
        loadMore: loadMore,
        starred: starred,
        query: query,
        type: type,
        questChatStatus: questChatStatus));
  }

  final _$setStarAsyncAction = AsyncAction('_ChatStore.setStar');

  @override
  Future<void> setStar() {
    return _$setStarAsyncAction.run(() => super.setStar());
  }

  final _$getChatAsyncAction = AsyncAction('_ChatStore.getChat');

  @override
  Future<void> getChat(String chatId) {
    return _$getChatAsyncAction.run(() => super.getChat(chatId));
  }

  final _$setMessageReadAsyncAction = AsyncAction('_ChatStore.setMessageRead');

  @override
  Future<void> setMessageRead(String chatId, String messageId) {
    return _$setMessageReadAsyncAction
        .run(() => super.setMessageRead(chatId, messageId));
  }

  final _$_ChatStoreActionController = ActionController(name: '_ChatStore');

  @override
  dynamic setChatType(int indexTab) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.setChatType');
    try {
      return super.setChatType(indexTab);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setChatSelected(bool value) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.setChatSelected');
    try {
      return super.setChatSelected(value);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetSelectedChats() {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.resetSelectedChats');
    try {
      return super.resetSelectedChats();
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setChatHighlighted(ChatModel chat) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.setChatHighlighted');
    try {
      return super.setChatHighlighted(chat);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeChat(ChatModel chat) {
    final _$actionInfo =
        _$_ChatStoreActionController.startAction(name: '_ChatStore.changeChat');
    try {
      return super.changeChat(chat);
    } finally {
      _$_ChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addedMessage(dynamic json) {
    final _$actionInfo = _$_ChatStoreActionController.startAction(
        name: '_ChatStore.addedMessage');
    try {
      return super.addedMessage(json);
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
starred: ${starred},
chatSelected: ${chatSelected},
chats: ${chats},
typeChat: ${typeChat}
    ''';
  }
}
