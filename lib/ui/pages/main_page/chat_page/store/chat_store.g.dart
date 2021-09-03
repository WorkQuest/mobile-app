// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ChatStore on _ChatStore, Store {
  final _$selectedCategoriesAtom = Atom(name: '_ChatStore.selectedCategories');

  @override
  List<String> get selectedCategories {
    _$selectedCategoriesAtom.reportRead();
    return super.selectedCategories;
  }

  @override
  set selectedCategories(List<String> value) {
    _$selectedCategoriesAtom.reportWrite(value, super.selectedCategories, () {
      super.selectedCategories = value;
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

  final _$loadChatsAsyncAction = AsyncAction('_ChatStore.loadChats');

  @override
  Future<dynamic> loadChats() {
    return _$loadChatsAsyncAction.run(() => super.loadChats());
  }

  @override
  String toString() {
    return '''
selectedCategories: ${selectedCategories},
chats: ${chats}
    ''';
  }
}
