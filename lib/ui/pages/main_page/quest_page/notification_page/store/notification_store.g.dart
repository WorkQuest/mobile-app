// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$NotificationStore on _NotificationStore, Store {
  final _$listOfNotificationsAtom =
      Atom(name: '_NotificationStore.listOfNotifications');

  @override
  ObservableList<Notifications> get listOfNotifications {
    _$listOfNotificationsAtom.reportRead();
    return super.listOfNotifications;
  }

  @override
  set listOfNotifications(ObservableList<Notifications> value) {
    _$listOfNotificationsAtom.reportWrite(value, super.listOfNotifications, () {
      super.listOfNotifications = value;
    });
  }

  final _$_NotificationStoreActionController =
      ActionController(name: '_NotificationStore');

  @override
  void changeQuests(dynamic json) {
    final _$actionInfo = _$_NotificationStoreActionController.startAction(
        name: '_NotificationStore.changeQuests');
    try {
      return super.changeQuests(json);
    } finally {
      _$_NotificationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeChats(dynamic json) {
    final _$actionInfo = _$_NotificationStoreActionController.startAction(
        name: '_NotificationStore.changeChats');
    try {
      return super.changeChats(json);
    } finally {
      _$_NotificationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listOfNotifications: ${listOfNotifications}
    ''';
  }
}
