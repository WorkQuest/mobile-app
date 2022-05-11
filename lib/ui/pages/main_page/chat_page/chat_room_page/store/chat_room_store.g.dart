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

  final _$sendingMessageAtom = Atom(name: '_ChatRoomStore.sendingMessage');

  @override
  bool get sendingMessage {
    _$sendingMessageAtom.reportRead();
    return super.sendingMessage;
  }

  @override
  set sendingMessage(bool value) {
    _$sendingMessageAtom.reportWrite(value, super.sendingMessage, () {
      super.sendingMessage = value;
    });
  }

  final _$idMessagesForStarAtom =
      Atom(name: '_ChatRoomStore.idMessagesForStar');

  @override
  ObservableMap<String, bool> get idMessagesForStar {
    _$idMessagesForStarAtom.reportRead();
    return super.idMessagesForStar;
  }

  @override
  set idMessagesForStar(ObservableMap<String, bool> value) {
    _$idMessagesForStarAtom.reportWrite(value, super.idMessagesForStar, () {
      super.idMessagesForStar = value;
    });
  }

  final _$idMessagesAtom = Atom(name: '_ChatRoomStore.idMessages');

  @override
  ObservableList<String> get idMessages {
    _$idMessagesAtom.reportRead();
    return super.idMessages;
  }

  @override
  set idMessages(ObservableList<String> value) {
    _$idMessagesAtom.reportWrite(value, super.idMessages, () {
      super.idMessages = value;
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
  ObservableMap<String, bool> get userInChat {
    _$userInChatAtom.reportRead();
    return super.userInChat;
  }

  @override
  set userInChat(ObservableMap<String, bool> value) {
    _$userInChatAtom.reportWrite(value, super.userInChat, () {
      super.userInChat = value;
    });
  }

  final _$userForDeletingAtom = Atom(name: '_ChatRoomStore.userForDeleting');

  @override
  ObservableList<String> get userForDeleting {
    _$userForDeletingAtom.reportRead();
    return super.userForDeleting;
  }

  @override
  set userForDeleting(ObservableList<String> value) {
    _$userForDeletingAtom.reportWrite(value, super.userForDeleting, () {
      super.userForDeleting = value;
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

  final _$userNameAtom = Atom(name: '_ChatRoomStore.userName');

  @override
  String get userName {
    _$userNameAtom.reportRead();
    return super.userName;
  }

  @override
  set userName(String value) {
    _$userNameAtom.reportWrite(value, super.userName, () {
      super.userName = value;
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

  final _$companionAtom = Atom(name: '_ChatRoomStore.companion');

  @override
  ProfileMeResponse? get companion {
    _$companionAtom.reportRead();
    return super.companion;
  }

  @override
  set companion(ProfileMeResponse? value) {
    _$companionAtom.reportWrite(value, super.companion, () {
      super.companion = value;
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

  final _$foundUsersAtom = Atom(name: '_ChatRoomStore.foundUsers');

  @override
  ObservableList<ProfileMeResponse> get foundUsers {
    _$foundUsersAtom.reportRead();
    return super.foundUsers;
  }

  @override
  set foundUsers(ObservableList<ProfileMeResponse> value) {
    _$foundUsersAtom.reportWrite(value, super.foundUsers, () {
      super.foundUsers = value;
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

  final _$pageNumberAtom = Atom(name: '_ChatRoomStore.pageNumber');

  @override
  int get pageNumber {
    _$pageNumberAtom.reportRead();
    return super.pageNumber;
  }

  @override
  set pageNumber(int value) {
    _$pageNumberAtom.reportWrite(value, super.pageNumber, () {
      super.pageNumber = value;
    });
  }

  final _$starAtom = Atom(name: '_ChatRoomStore.star');

  @override
  Map<String, Star?> get star {
    _$starAtom.reportRead();
    return super.star;
  }

  @override
  set star(Map<String, Star?> value) {
    _$starAtom.reportWrite(value, super.star, () {
      super.star = value;
    });
  }

  final _$mapOfPathAtom = Atom(name: '_ChatRoomStore.mapOfPath');

  @override
  ObservableMap<String, dynamic> get mapOfPath {
    _$mapOfPathAtom.reportRead();
    return super.mapOfPath;
  }

  @override
  set mapOfPath(ObservableMap<String, dynamic> value) {
    _$mapOfPathAtom.reportWrite(value, super.mapOfPath, () {
      super.mapOfPath = value;
    });
  }

  final _$leaveFromChatAsyncAction =
      AsyncAction('_ChatRoomStore.leaveFromChat');

  @override
  Future<void> leaveFromChat() {
    return _$leaveFromChatAsyncAction.run(() => super.leaveFromChat());
  }

  final _$setStarAsyncAction = AsyncAction('_ChatRoomStore.setStar');

  @override
  Future<dynamic> setStar(bool allMsg) {
    return _$setStarAsyncAction.run(() => super.setStar(allMsg));
  }

  final _$getUsersForGroupCHatAsyncAction =
      AsyncAction('_ChatRoomStore.getUsersForGroupCHat');

  @override
  Future<dynamic> getUsersForGroupCHat() {
    return _$getUsersForGroupCHatAsyncAction
        .run(() => super.getUsersForGroupCHat());
  }

  final _$getCompanionAsyncAction = AsyncAction('_ChatRoomStore.getCompanion');

  @override
  Future<dynamic> getCompanion(String userId) {
    return _$getCompanionAsyncAction.run(() => super.getCompanion(userId));
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

  final _$addUsersInChatAsyncAction =
      AsyncAction('_ChatRoomStore.addUsersInChat');

  @override
  Future<dynamic> addUsersInChat() {
    return _$addUsersInChatAsyncAction.run(() => super.addUsersInChat());
  }

  final _$removeUserFromChatAsyncAction =
      AsyncAction('_ChatRoomStore.removeUserFromChat');

  @override
  Future<dynamic> removeUserFromChat() {
    return _$removeUserFromChatAsyncAction
        .run(() => super.removeUserFromChat());
  }

  final _$getMessagesAsyncAction = AsyncAction('_ChatRoomStore.getMessages');

  @override
  Future getMessages(bool isPagination) {
    return _$getMessagesAsyncAction.run(() => super.getMessages(isPagination));
  }

  final _$_ChatRoomStoreActionController =
      ActionController(name: '_ChatRoomStore');

  @override
  void changePageNumber(int value) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
        name: '_ChatRoomStore.changePageNumber');
    try {
      return super.changePageNumber(value);
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSendingMessage(bool value) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
        name: '_ChatRoomStore.setSendingMessage');
    try {
      return super.setSendingMessage(value);
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMessageSelected(bool value) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
        name: '_ChatRoomStore.setMessageSelected');
    try {
      return super.setMessageSelected(value);
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMessageHighlighted(MessageModel message) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
        name: '_ChatRoomStore.setMessageHighlighted');
    try {
      return super.setMessageHighlighted(message);
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String copyMessage() {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
        name: '_ChatRoomStore.copyMessage');
    try {
      return super.copyMessage();
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
  void findUser(String text) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
        name: '_ChatRoomStore.findUser');
    try {
      return super.findUser(text);
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
  void undeletingUser(ProfileMeResponse user) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
        name: '_ChatRoomStore.undeletingUser');
    try {
      return super.undeletingUser(user);
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void deleteUser(ProfileMeResponse user) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
        name: '_ChatRoomStore.deleteUser');
    try {
      return super.deleteUser(user);
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
sendingMessage: ${sendingMessage},
idMessagesForStar: ${idMessagesForStar},
idMessages: ${idMessages},
index: ${index},
messageSelected: ${messageSelected},
userInChat: ${userInChat},
userForDeleting: ${userForDeleting},
infoMessageValue: ${infoMessageValue},
userName: ${userName},
refresh: ${refresh},
companion: ${companion},
usersId: ${usersId},
availableUsers: ${availableUsers},
foundUsers: ${foundUsers},
selectedUsers: ${selectedUsers},
starredMessage: ${starredMessage},
pageNumber: ${pageNumber},
star: ${star},
mapOfPath: ${mapOfPath},
chat: ${chat}
    ''';
  }
}
