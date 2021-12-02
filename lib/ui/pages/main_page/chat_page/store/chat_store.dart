import 'dart:async';

import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/ui/pages/main_page/chat_page/repository/chat.dart';
import 'package:app/utils/web_socket.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../../../../enums.dart';

part 'chat_store.g.dart';

@singleton
class ChatStore extends _ChatStore with _$ChatStore {
  ChatStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ChatStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;
  final StreamController<bool> streamChatNotification =
      StreamController<bool>();
  String _myId = "";
  int offset = 0;
  int limit = 10;

  UserRole? role;

  @observable
  bool unread = false;

  @observable
  bool starred = false;

  @observable
  ObservableList<bool> isChatHighlighted = ObservableList.of([]);

  @observable
  ObservableList<String> idChat = ObservableList.of([]);

  @observable
  bool chatSelected = false;

  _ChatStore(this._apiProvider) {
    WebSocket().handlerChats = this.addedMessage;
  }

  Map<String, Chats> chats = {};

  @observable
  ObservableList<Chats> starredChats = ObservableList.of([]);

  Chats? chatByID(String id) {
    if (chats[id] == null) return null;
    chats[id]!.read();
    return chats[id];
  }

  final _atomChats = Atom(name: 'ChatStore._atomChats');

  List<String> get chatKeyList {
    _atomChats.reportRead();
    var keys = chats.keys.toList();
    keys.sort((key1, key2) {
      final chat1 = chats[key1]!.chatModel;
      final chat2 = chats[key2]!.chatModel;

      return chat1.lastMessage.createdAt.millisecondsSinceEpoch <
              chat2.lastMessage.createdAt.millisecondsSinceEpoch
          ? 1
          : 0;
    });
    return keys;
  }

  void setMessages(List<MessageModel> messages, ChatModel chat) {
    if (chats[chat.id] == null) chats[chat.id] = Chats(chat);
    chats[chat.id]!.messages = messages;
    chats[chat.id]!.update();
  }

  void addAllMessages(List<MessageModel> messages, String id) {
    try {
      if (chats[id] == null) return;
      chats[id]!.messages.addAll(messages);
      chats[id]!.update();
    } catch (e, trace) {
      print("$e $trace");
    }
  }

  void addedMessage(MessageModel message) {
    var chat = chats[message.chatId];
    if (chat == null) return;
    chat.chatModel.lastMessage = message;
    chat.messages.insert(0, message);

    final saveChat = chats.remove(message.chatId);

    chats[message.chatId] = saveChat!;
    checkMessage();
    _atomChats.reportChanged();
    chat.update();
  }

  List<String> selectedCategories = [
    "Starred message",
    "Starred chat",
    "Report",
    "Create group chat",
  ];

  List<String> selectedCategoriesStarred = [
    "Starred message",
    "All chat",
    "Report",
    "Create group chat",
  ];

  @observable
  String infoMessageValue = "";

  @observable
  bool isLoadingChats = false;

  @observable
  bool refresh = false;

  @observable
  int _count = 0;

  @action
  openStarredChats(bool value) => starred = value;

  @action
  String setInfoMessage(String infoMessage) {
    switch (infoMessage) {
      case "groupChatCreate":
        return infoMessageValue = "You created a group chat";
      case "employerRejectResponseOnQuest":
        return infoMessageValue =
            "The employer rejected the response to the request";
      case "workerResponseOnQuest":
        return infoMessageValue = "The worker responded to the quest";
      case "groupChatAddUser":
        return infoMessageValue = "User added";
      case "groupChatDeleteUser":
        return infoMessageValue = "User deleted";
      case "groupChatLeaveUser":
        return infoMessageValue = "User left chat";
    }
    return infoMessageValue;
  }

  initialSetup(String myId) async {
    this._myId = myId;
    await loadChats(false);
    WebSocket().connect();
  }

  @action
  void checkMessage() {
    chats.values.forEach((element) {
      if (element.chatModel.lastMessage.senderStatus == "unread" &&
          element.chatModel.lastMessage.senderUserId != this._myId) {
        streamChatNotification.sink.add(true);
        unread = true;
        return;
      } else {
        streamChatNotification.sink.add(false);
        unread = false;
      }
    });
  }

  @action
  Future loadChats(bool isNewList) async {
    if (isNewList) {
      chats = {};
      starredChats = ObservableList.of([]);
      this.offset = 0;
      refresh = false;
    }
    if (this._myId.isEmpty || (_count == chats.length && refresh)) return;
    try {
      _count = chats.length;
      if (isNewList) this.onLoading();

      final listChats = await _apiProvider.getChats(
        offset: this.offset,
        limit: this.limit,
      );
      listChats.forEach((chat) {
        chats[chat.id] = Chats(chat);
        if (chats[chat.id]!.chatModel.star != null)
          starredChats.add(chats[chat.id]!);
      });
      this.offset = chats.length;
      refresh = true;
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future setMessageRead(String chatId, String messageId) async {
    try {
      await _apiProvider.setMessageRead(chatId: chatId, messageId: messageId);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
