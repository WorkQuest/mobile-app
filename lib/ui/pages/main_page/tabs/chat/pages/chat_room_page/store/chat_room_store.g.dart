// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatRoomStore on _ChatRoomStore, Store {
  final _$disputeAtom = Atom(name: '_ChatRoomStore.dispute');

  @override
  DisputeModel? get dispute {
    _$disputeAtom.reportRead();
    return super.dispute;
  }

  @override
  set dispute(DisputeModel? value) {
    _$disputeAtom.reportWrite(value, super.dispute, () {
      super.dispute = value;
    });
  }

  final _$initPageAtom = Atom(name: '_ChatRoomStore.initPage');

  @override
  bool get initPage {
    _$initPageAtom.reportRead();
    return super.initPage;
  }

  @override
  set initPage(bool value) {
    _$initPageAtom.reportWrite(value, super.initPage, () {
      super.initPage = value;
    });
  }

  final _$loadMessageAtom = Atom(name: '_ChatRoomStore.loadMessage');

  @override
  bool get loadMessage {
    _$loadMessageAtom.reportRead();
    return super.loadMessage;
  }

  @override
  set loadMessage(bool value) {
    _$loadMessageAtom.reportWrite(value, super.loadMessage, () {
      super.loadMessage = value;
    });
  }

  final _$chatRoomAtom = Atom(name: '_ChatRoomStore.chatRoom');

  @override
  ChatModel? get chatRoom {
    _$chatRoomAtom.reportRead();
    return super.chatRoom;
  }

  @override
  set chatRoom(ChatModel? value) {
    _$chatRoomAtom.reportWrite(value, super.chatRoom, () {
      super.chatRoom = value;
    });
  }

  final _$messagesAtom = Atom(name: '_ChatRoomStore.messages');

  @override
  ObservableList<MessageModel> get messages {
    _$messagesAtom.reportRead();
    return super.messages;
  }

  @override
  set messages(ObservableList<MessageModel> value) {
    _$messagesAtom.reportWrite(value, super.messages, () {
      super.messages = value;
    });
  }

  final _$selectedMessagesAtom = Atom(name: '_ChatRoomStore.selectedMessages');

  @override
  ObservableMap<MessageModel, bool> get selectedMessages {
    _$selectedMessagesAtom.reportRead();
    return super.selectedMessages;
  }

  @override
  set selectedMessages(ObservableMap<MessageModel, bool> value) {
    _$selectedMessagesAtom.reportWrite(value, super.selectedMessages, () {
      super.selectedMessages = value;
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

  final _$mediaPathsAtom = Atom(name: '_ChatRoomStore.mediaPaths');

  @override
  ObservableMap<Media, String> get mediaPaths {
    _$mediaPathsAtom.reportRead();
    return super.mediaPaths;
  }

  @override
  set mediaPaths(ObservableMap<Media, String> value) {
    _$mediaPathsAtom.reportWrite(value, super.mediaPaths, () {
      super.mediaPaths = value;
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

  final _$getMessagesAsyncAction = AsyncAction('_ChatRoomStore.getMessages');

  @override
  Future<void> getMessages({required String chatId, bool newList = false}) {
    return _$getMessagesAsyncAction
        .run(() => super.getMessages(chatId: chatId, newList: newList));
  }

  final _$leaveFromChatAsyncAction =
      AsyncAction('_ChatRoomStore.leaveFromChat');

  @override
  Future<void> leaveFromChat() {
    return _$leaveFromChatAsyncAction.run(() => super.leaveFromChat());
  }

  final _$setStarAsyncAction = AsyncAction('_ChatRoomStore.setStar');

  @override
  Future<void> setStar() {
    return _$setStarAsyncAction.run(() => super.setStar());
  }

  final _$getDisputeAsyncAction = AsyncAction('_ChatRoomStore.getDispute');

  @override
  Future<void> getDispute(String disputeId) {
    return _$getDisputeAsyncAction.run(() => super.getDispute(disputeId));
  }

  final _$_ChatRoomStoreActionController =
      ActionController(name: '_ChatRoomStore');

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
  void resetSelectedMessages() {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
        name: '_ChatRoomStore.resetSelectedMessages');
    try {
      return super.resetSelectedMessages();
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addedMessage(dynamic json) {
    final _$actionInfo = _$_ChatRoomStoreActionController.startAction(
        name: '_ChatRoomStore.addedMessage');
    try {
      return super.addedMessage(json);
    } finally {
      _$_ChatRoomStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
dispute: ${dispute},
initPage: ${initPage},
loadMessage: ${loadMessage},
chatRoom: ${chatRoom},
messages: ${messages},
selectedMessages: ${selectedMessages},
sendingMessage: ${sendingMessage},
messageSelected: ${messageSelected},
starredMessage: ${starredMessage},
mediaPaths: ${mediaPaths},
star: ${star}
    ''';
  }
}
