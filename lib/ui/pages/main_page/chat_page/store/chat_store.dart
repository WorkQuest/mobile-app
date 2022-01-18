import 'dart:async';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/chat_model/star.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/chat_page/chat.dart';
import 'package:app/utils/web_socket.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../enums.dart';

part 'chat_store.g.dart';

@singleton
class ChatStore extends _ChatStore with _$ChatStore {
  ChatStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ChatStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;
  StreamController<bool>? streamChatNotification;
  ProfileMeResponse? userData;

  String _myId = "";
  int offset = 0;
  int limit = 10;

  UserRole? role;

  @observable
  bool unread = false;

  @observable
  bool starred = false;

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

  @observable
  ObservableList<String> chatsId = ObservableList.of([]);

  @observable
  ObservableMap<String, bool> idChatsForStar = ObservableMap.of({});

  Chats? chatByID(String id) {
    if (chats[id] == null) return null;
    chats[id]!.read();
    return chats[id];
  }

  final _atomChats = Atom(name: 'ChatStore._atomChats');

  List<String> get chatKeyList {
    _atomChats.reportRead();
    var keys = chats.keys.toList();
    var values = chats.values.toList();

    values.forEach((element) {
      if (idChatsForStar[element.chatModel.id] == null)
        idChatsForStar[element.chatModel.id] = false;
    });

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

  @action
  uncheck() {
    for (int i = 0; i < chatsId.length; i++) {
      idChatsForStar[chatsId[i]] = false;
    }
    chatsId.clear();
  }

  @action
  setChatSelected(bool value) => chatSelected = value;

  @action
  setChatHighlighted(Chats chatDetails) {
    idChatsForStar[chatDetails.chatModel.id] =
        !idChatsForStar[chatDetails.chatModel.id]!;
    for (int i = 0; i < chatsId.length; i++) {
      if (chatsId[i] == chatDetails.chatModel.id) {
        chatsId.removeAt(i);
        return;
      }
    }
    chatsId.add(chatDetails.chatModel.id);
  }

  @action
  Future setStar() async {
    chatsId.forEach((element) async {
      if (chats[element]!.chatModel.star == null) {
        await _apiProvider.setChatStar(chatId: element);
        chats[element]!.chatModel.star = Star(
          id: "",
          userId: "",
          messageId: null,
          chatId: element,
          createdAt: DateTime.now(),
        );
      } else {
        await _apiProvider.removeStarFromChat(chatId: element);
        chats[element]!.chatModel.star = null;
      }
      chats[element]!.update();
    });
    uncheck();
    _atomChats.reportRead();
  }

  void setMessages(List<MessageModel> messages, ChatModel chat) {
    if (chats[chat.id] == null) chats[chat.id] = Chats(chat);
    chats[chat.id]!.messages = messages;
    chats[chat.id]!.update();
    _atomChats.reportChanged();
  }

  void addAllMessages(List<MessageModel> messages, String id) {
    try {
      if (chats[id] == null) return;
      chats[id]!.messages.addAll(messages);
      checkMessage();
      chats[id]!.update();
    } catch (e, trace) {
      print("$e $trace");
    }
  }

  void addedMessage(dynamic json) {
    try {
      var message;
      if (json["type"] == "request") {
        message = MessageModel.fromJson(json["payload"]["result"]);
      } else if (json["message"]["action"] == "groupChatCreate") {
        message = MessageModel.fromJson(json["message"]["data"]["lastMessage"]);
        setMessages(
            [MessageModel.fromJson(json["message"]["data"]["lastMessage"])],
            ChatModel.fromJson(json["message"]["data"]));
        _atomChats.reportChanged();
        return;
      } else if (json["message"]["action"] == "newMessage") {
        message = MessageModel.fromJson(json["message"]["data"]);
      } else if (json["message"]["action"] == "messageReadByRecipient") {
        message = MessageModel.fromJson(json["message"]["data"]);
        chats[message.chatId]!.chatModel.lastMessage.senderStatus = "read";
        _atomChats.reportChanged();
        return;
      }
      var chat = chats[message.chatId];
      if (chat == null) return;
      chat.chatModel.lastMessage = message;
      chat.messages.insert(0, message);

      final saveChat = chats.remove(message.chatId);

      chats[message.chatId] = saveChat!;

      checkMessage();
      _atomChats.reportChanged();
      chat.update();
    } catch (e, trace) {
      print("ERROR: $e");
      print("ERROR: $trace");
    }
  }

  @observable
  String infoMessageValue = "";

  @observable
  bool isLoadingChats = false;

  @observable
  bool refresh = false;

  @observable
  int _count = 0;

  @action
  void openStarredChats(bool value) {
    starred = value;
    starredChats.clear();
    chats.forEach((key, value) {
      if (value.chatModel.star != null) {
        starredChats.add(value);
      }
    });
  }

  @action
  String setInfoMessage(String infoMessage) {
    switch (infoMessage) {
      case "groupChatCreate":
        return infoMessageValue = "chat.infoMessage.groupChatCreate".tr();
      case "employerRejectResponseOnQuest":
        return infoMessageValue =
            "chat.infoMessage.employerRejectResponseOnQuest".tr();
      case "workerResponseOnQuest":
        return infoMessageValue = "chat.infoMessage.workerResponseOnQuest".tr();
      case "groupChatAddUser":
        return infoMessageValue = "chat.infoMessage.groupChatAddUser".tr();
      case "groupChatDeleteUser":
        return infoMessageValue = "chat.infoMessage.groupChatDeleteUser".tr();
      case "groupChatLeaveUser":
        return infoMessageValue = "chat.infoMessage.groupChatLeaveUser".tr();
    }
    return infoMessageValue;
  }

  initialSetup(String myId) async {
    this._myId = myId;
    await loadChats(true);
    WebSocket().connect();
  }

  @action
  void checkMessage() {
    chats.values.forEach((element) {
      if (element.chatModel.lastMessage.senderStatus == "unread" &&
          element.chatModel.lastMessage.senderUserId != this._myId) {
        streamChatNotification!.sink.add(true);
        unread = true;
        return;
      } else {
        streamChatNotification!.sink.add(false);
        unread = false;
      }
    });
  }

  void initialStore() async {
    if (streamChatNotification != null) await streamChatNotification!.close();
    streamChatNotification = StreamController<bool>.broadcast();
  }

  @action
  Future loadChats(bool isNewList) async {
    if (isNewList) {
      chats = {};
      starredChats.clear();
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
  Future getUserData(String idUser) async {
    try {
      userData = await _apiProvider.getProfileUser(userId: idUser);
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
