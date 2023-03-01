// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DisputeStore on _DisputeStore, Store {
  final _$mediaPathsAtom = Atom(name: '_DisputeStore.mediaPaths');

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

  final _$statusAtom = Atom(name: '_DisputeStore.status');

  @override
  String get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(String value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$disputeAtom = Atom(name: '_DisputeStore.dispute');

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

  final _$messagesAtom = Atom(name: '_DisputeStore.messages');

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

  final _$getThumbnailAsyncAction = AsyncAction('_DisputeStore.getThumbnail');

  @override
  Future<void> getThumbnail(List<MessageModel> value) {
    return _$getThumbnailAsyncAction.run(() => super.getThumbnail(value));
  }

  final _$getDisputeAsyncAction = AsyncAction('_DisputeStore.getDispute');

  @override
  Future<void> getDispute(String disputeId) {
    return _$getDisputeAsyncAction.run(() => super.getDispute(disputeId));
  }

  final _$getMessagesAsyncAction = AsyncAction('_DisputeStore.getMessages');

  @override
  Future<void> getMessages(String chatId) {
    return _$getMessagesAsyncAction.run(() => super.getMessages(chatId));
  }

  @override
  String toString() {
    return '''
mediaPaths: ${mediaPaths},
status: ${status},
dispute: ${dispute},
messages: ${messages}
    ''';
  }
}
