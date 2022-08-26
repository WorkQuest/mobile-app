// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$EditChatStore on _EditChatStore, Store {
  Computed<bool>? _$isSelectedUsersComputed;

  @override
  bool get isSelectedUsers =>
      (_$isSelectedUsersComputed ??= Computed<bool>(() => super.isSelectedUsers,
              name: '_EditChatStore.isSelectedUsers'))
          .value;

  final _$usersAtom = Atom(name: '_EditChatStore.users');

  @override
  ObservableMap<ProfileMeResponse, bool> get users {
    _$usersAtom.reportRead();
    return super.users;
  }

  @override
  set users(ObservableMap<ProfileMeResponse, bool> value) {
    _$usersAtom.reportWrite(value, super.users, () {
      super.users = value;
    });
  }

  final _$foundUsersAtom = Atom(name: '_EditChatStore.foundUsers');

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

  final _$userNameAtom = Atom(name: '_EditChatStore.userName');

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

  final _$getUsersForChatAsyncAction =
      AsyncAction('_EditChatStore.getUsersForChat');

  @override
  Future<void> getUsersForChat(String chatId) {
    return _$getUsersForChatAsyncAction
        .run(() => super.getUsersForChat(chatId));
  }

  final _$_EditChatStoreActionController =
      ActionController(name: '_EditChatStore');

  @override
  void findUser(String text) {
    final _$actionInfo = _$_EditChatStoreActionController.startAction(
        name: '_EditChatStore.findUser');
    try {
      return super.findUser(text);
    } finally {
      _$_EditChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
users: ${users},
foundUsers: ${foundUsers},
userName: ${userName},
isSelectedUsers: ${isSelectedUsers}
    ''';
  }
}
