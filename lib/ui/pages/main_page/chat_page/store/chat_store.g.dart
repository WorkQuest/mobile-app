// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatStore on _ChatStore, Store {
  final _$selectedCategoriesWorkerAtom =
      Atom(name: '_ChatStore.selectedCategoriesWorker');

  @override
  List<String> get selectedCategoriesWorker {
    _$selectedCategoriesWorkerAtom.reportRead();
    return super.selectedCategoriesWorker;
  }

  @override
  set selectedCategoriesWorker(List<String> value) {
    _$selectedCategoriesWorkerAtom
        .reportWrite(value, super.selectedCategoriesWorker, () {
      super.selectedCategoriesWorker = value;
    });
  }

  final _$selectedCategoriesEmployerAtom =
      Atom(name: '_ChatStore.selectedCategoriesEmployer');

  @override
  List<String> get selectedCategoriesEmployer {
    _$selectedCategoriesEmployerAtom.reportRead();
    return super.selectedCategoriesEmployer;
  }

  @override
  set selectedCategoriesEmployer(List<String> value) {
    _$selectedCategoriesEmployerAtom
        .reportWrite(value, super.selectedCategoriesEmployer, () {
      super.selectedCategoriesEmployer = value;
    });
  }

  final _$chatsAtom = Atom(name: '_ChatStore.chats');

  @override
  ObservableList<ChatModel> get chats {
    _$chatsAtom.reportRead();
    return super.chats;
  }

  @override
  set chats(ObservableList<ChatModel> value) {
    _$chatsAtom.reportWrite(value, super.chats, () {
      super.chats = value;
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

  final _$messagesAtom = Atom(name: '_ChatStore.messages');

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

  final _$loadChatsAsyncAction = AsyncAction('_ChatStore.loadChats');

  @override
  Future<dynamic> loadChats(bool isNewList) {
    return _$loadChatsAsyncAction.run(() => super.loadChats(isNewList));
  }

  final _$getMessagesAsyncAction = AsyncAction('_ChatStore.getMessages');

  @override
  Future getMessages() {
    return _$getMessagesAsyncAction.run(() => super.getMessages());
  }

  final _$_ChatStoreActionController = ActionController(name: '_ChatStore');

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
  String toString() {
    return '''
selectedCategoriesWorker: ${selectedCategoriesWorker},
selectedCategoriesEmployer: ${selectedCategoriesEmployer},
chats: ${chats},
infoMessageValue: ${infoMessageValue},
isLoadingChats: ${isLoadingChats},
refresh: ${refresh},
messages: ${messages}
    ''';
  }
}
