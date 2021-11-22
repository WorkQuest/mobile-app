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
  List<ChatModel> get chats {
    _$chatsAtom.reportRead();
    return super.chats;
  }

  @override
  set chats(List<ChatModel> value) {
    _$chatsAtom.reportWrite(value, super.chats, () {
      super.chats = value;
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
  Future<dynamic> loadChats() {
    return _$loadChatsAsyncAction.run(() => super.loadChats());
  }

  final _$getMessagesAsyncAction = AsyncAction('_ChatStore.getMessages');

  @override
  Future getMessages() {
    return _$getMessagesAsyncAction.run(() => super.getMessages());
  }

  @override
  String toString() {
    return '''
selectedCategoriesWorker: ${selectedCategoriesWorker},
selectedCategoriesEmployer: ${selectedCategoriesEmployer},
chats: ${chats},
messages: ${messages}
    ''';
  }
}
