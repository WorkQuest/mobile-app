// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_chat_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$GroupChatStore on _GroupChatStore, Store {
  Computed<bool>? _$isSelectedUsersComputed;

  @override
  bool get isSelectedUsers =>
      (_$isSelectedUsersComputed ??= Computed<bool>(() => super.isSelectedUsers,
              name: '_GroupChatStore.isSelectedUsers'))
          .value;

  final _$usersAtom = Atom(name: '_GroupChatStore.users');

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

  final _$foundUsersAtom = Atom(name: '_GroupChatStore.foundUsers');

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

  final _$indexAtom = Atom(name: '_GroupChatStore.index');

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

  final _$chatNameAtom = Atom(name: '_GroupChatStore.chatName');

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

  final _$userNameAtom = Atom(name: '_GroupChatStore.userName');

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

  final _$userIdAtom = Atom(name: '_GroupChatStore.userId');

  @override
  String get userId {
    _$userIdAtom.reportRead();
    return super.userId;
  }

  @override
  set userId(String value) {
    _$userIdAtom.reportWrite(value, super.userId, () {
      super.userId = value;
    });
  }

  final _$getUsersAsyncAction = AsyncAction('_GroupChatStore.getUsers');

  @override
  Future<void> getUsers() {
    return _$getUsersAsyncAction.run(() => super.getUsers());
  }

  final _$_GroupChatStoreActionController =
      ActionController(name: '_GroupChatStore');

  @override
  void setChatName(String value) {
    final _$actionInfo = _$_GroupChatStoreActionController.startAction(
        name: '_GroupChatStore.setChatName');
    try {
      return super.setChatName(value);
    } finally {
      _$_GroupChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void findUser(String text) {
    final _$actionInfo = _$_GroupChatStoreActionController.startAction(
        name: '_GroupChatStore.findUser');
    try {
      return super.findUser(text);
    } finally {
      _$_GroupChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setUserId(String value) {
    final _$actionInfo = _$_GroupChatStoreActionController.startAction(
        name: '_GroupChatStore.setUserId');
    try {
      return super.setUserId(value);
    } finally {
      _$_GroupChatStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
users: ${users},
foundUsers: ${foundUsers},
index: ${index},
chatName: ${chatName},
userName: ${userName},
userId: ${userId},
isSelectedUsers: ${isSelectedUsers}
    ''';
  }
}
