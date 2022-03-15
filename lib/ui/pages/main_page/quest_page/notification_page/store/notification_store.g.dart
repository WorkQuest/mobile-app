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
  ObservableList<NotificationElement> get listOfNotifications {
    _$listOfNotificationsAtom.reportRead();
    return super.listOfNotifications;
  }

  @override
  set listOfNotifications(ObservableList<NotificationElement> value) {
    _$listOfNotificationsAtom.reportWrite(value, super.listOfNotifications, () {
      super.listOfNotifications = value;
    });
  }

  final _$getNotificationAsyncAction =
      AsyncAction('_NotificationStore.getNotification');

  @override
  Future<void> getNotification(bool newList) {
    return _$getNotificationAsyncAction
        .run(() => super.getNotification(newList));
  }

  final _$deleteNotificationAsyncAction =
      AsyncAction('_NotificationStore.deleteNotification');

  @override
  Future<void> deleteNotification(String notificationId) {
    return _$deleteNotificationAsyncAction
        .run(() => super.deleteNotification(notificationId));
  }

  @override
  String toString() {
    return '''
listOfNotifications: ${listOfNotifications}
    ''';
  }
}
