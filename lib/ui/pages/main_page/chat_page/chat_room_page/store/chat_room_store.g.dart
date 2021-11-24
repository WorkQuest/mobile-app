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

  final _$chatNameAtom = Atom(name: '_ChatRoomStore.chatName');

  @override
  String get chatName {
    _$chatNameAtom.reportRead();
    return super.chatName;
  }

  @override
  set chatName(String value) {
    _$chatNameAtom.reportWrite(value, super.chatName, () {
      super.chatName = value;
    });
  }

  final _$indexAtom = Atom(name: '_ChatRoomStore.index');

  @override
  int get index {
    _$indexAtom.reportRead();
    return super.index;
  }

  @override
  set index(int value) {
    _$indexAtom.reportWrite(value, super.index, () {
      super.index = value;
    });
  }

  final _$messageSelectedAtom = Atom(name: '_ChatRoomStore.messageSelected');

  @override
  bool get messageSelected {
    _$messageSelectedAtom.reportRead();
    return super.messageSelected;
  }

  @override
  set messageSelected(bool value) {
    _$messageSelectedAtom.reportWrite(value, super.messageSelected, () {
      super.messageSelected = value;
    });
  }

  final _$userInChatAtom = Atom(name: '_ChatRoomStore.userInChat');

  @override
  ObservableList<bool> get userInChat {
    _$userInChatAtom.reportRead();
    return super.userInChat;
  }

  @override
  set userInChat(ObservableList<bool> value) {
    _$userInChatAtom.reportWrite(value, super.userInChat, () {
      super.userInChat = value;
    });
  }

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

  final _$infoMessageValueAtom = Atom(name: '_ChatRoomStore.infoMessageValue');

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

  final _$usersIdAtom = Atom(name: '_ChatRoomStore.usersId');

  @override
  ObservableList<String> get usersId {
    _$usersIdAtom.reportRead();
    return super.usersId;
  }

  @override
  set usersId(ObservableList<String> value) {
    _$usersIdAtom.reportWrite(value, super.usersId, () {
      super.usersId = value;
    });
  }

  final _$availableUsersAtom = Atom(name: '_ChatRoomStore.availableUsers');

  @override
  ObservableList<ProfileMeResponse> get availableUsers {
    _$availableUsersAtom.reportRead();
    return super.availableUsers;
  }

  @override
  set availableUsers(ObservableList<ProfileMeResponse> value) {
    _$availableUsersAtom.reportWrite(value, super.availableUsers, () {
      super.availableUsers = value;
    });
  }

  final _$selectedUsersAtom = Atom(name: '_ChatRoomStore.selectedUsers');

  @override
  ObservableList<bool> get selectedUsers {
    _$selectedUsersAtom.reportRead();
    return super.selectedUsers;
  }

  @override
  set selectedUsers(ObservableList<bool> value) {
    _$selectedUsersAtom.reportWrite(value, super.selectedUsers, () {
      super.selectedUsers = value;
    });
  }

  final _$starredMessageAtom = Atom(name: '_ChatRoomStore.starredMessage');

  @override
  ObservableList<MessageModel> get starredMessage {
    _$starredMessageAtom.reportRead();
    return super.starredMessage;
  }

  @override
  set starredMessage(ObservableList<MessageModel> value) {
    _$starredMessageAtom.reportWrite(value, super.starredMessage, () {
      super.starredMessage = value;
    });
  }

  final _$getUsersForGroupCHatAsyncAction =
      AsyncAction('_ChatRoomStore.getUsersForGroupCHat');

  @override
  Future<dynamic> getUsersForGroupCHat() {
    return _$getUsersForGroupCHatAsyncAction
        .run(() => super.getUsersForGroupCHat());
  }

  final _$getStarredMessageAsyncAction =
      AsyncAction('_ChatRoomStore.getStarredMessage');

  @override
  Future<dynamic> getStarredMessage() {
    return _$getStarredMessageAsyncAction.run(() => super.getStarredMessage());
  }

  final _$createGroupChatAsyncAction =
      AsyncAction('_ChatRoomStore.createGroupChat');

  @override
  Future<dynamic> createGroupChat() {
    return _$createGroupChatAsyncAction.run(() => super.createGroupChat());
  }

  final _$getMessagesAsyncAction = AsyncAction('_ChatRoomStore.getMessages');

  @override
  Future getMessages(bool isPagination) {
    return _$getMessagesAsyncAction.run(() => super.getMessages(isPagination));
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
  void setMessageHighlighted(String value) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
        name: '_ChatRoomStore.setMessageHighlighted');
    try {
      return super.setMessageHighlighted(value);
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setChatName(String value) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
        name: '_ChatRoomStore.setChatName');
    try {
      return super.setChatName(value);
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectUser(int index) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
        name: '_ChatRoomStore.selectUser');
    try {
      return super.selectUser(index);
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String setInfoMessage(String infoMessage) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
        name: '_ChatRoomStore.setInfoMessage');
    try {
      return super.setInfoMessage(infoMessage);
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic generateListUserInChat() {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
        name: '_ChatRoomStore.generateListUserInChat');
    try {
      return super.generateListUserInChat();
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
chatName: ${chatName},
index: ${index},
messageSelected: ${messageSelected},
userInChat: ${userInChat},
infoMessageValue: ${infoMessageValue},
isLoadingMessages: ${isLoadingMessages},
refresh: ${refresh},
usersId: ${usersId},
availableUsers: ${availableUsers},
selectedUsers: ${selectedUsers},
starredMessage: ${starredMessage},
chat: ${chat}
    ''';
  }
}
