// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'starred_message_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StarredMessageStore on _StarredMessageStore, Store {
  final _$messagesAtom = Atom(name: '_StarredMessageStore.messages');

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

  final _$mediaPathsAtom = Atom(name: '_StarredMessageStore.mediaPaths');

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

  final _$getMessagesAsyncAction =
      AsyncAction('_StarredMessageStore.getMessages');

  @override
  Future getMessages({bool isForce = false}) {
    return _$getMessagesAsyncAction
        .run(() => super.getMessages(isForce: isForce));
  }

  final _$removeStarAsyncAction =
      AsyncAction('_StarredMessageStore.removeStar');

  @override
  Future removeStar(MessageModel message) {
    return _$removeStarAsyncAction.run(() => super.removeStar(message));
  }

  @override
  String toString() {
    return '''
messages: ${messages},
mediaPaths: ${mediaPaths}
    ''';
  }
}
