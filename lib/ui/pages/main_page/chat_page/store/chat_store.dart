import 'dart:async';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/chat_page/chat.dart';
import 'package:app/utils/web_socket.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/http/chat_extension.dart';
import '../../../../../enums.dart';

part 'chat_store.g.dart';

@singleton
class ChatStore extends _ChatStore with _$ChatStore {
  ChatStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ChatStore extends IStore<bool> with Store {
  _ChatStore(this._apiProvider) {
    WebSocket().handlerChats = this.addedMessage;
  }

  final ApiProvider _apiProvider;

  StreamController<bool>? streamChatNotification;

  String myId = "";

  int offset = 0;

  @observable
  ProfileMeResponse? userData;

  @observable
  bool starred = false;

  @observable
  bool chatSelected = false;

  @observable
  Chats? chats;

  @observable
  TypeChat typeChat = TypeChat.active;

  ObservableMap<ChatModel, bool> selectedChats = ObservableMap.of({});

  void initialStore() async {
    if (streamChatNotification != null) await streamChatNotification!.close();
    streamChatNotification = StreamController<bool>.broadcast();
  }

  void initialSetup(String myId) async {
    this.myId = myId;
    WebSocket().connect();
  }

  @action
  Future<void> loadChats({
    bool loadMore = false,
    bool? starred,
    String query = '',
    TypeChat type = TypeChat.active,
    int? questChatStatus,
  }) async {
    if (this.myId.isEmpty) return;
    chats ??= Chats([]);
    if (!loadMore) {
      chats!.clearChat();
      offset = 0;
      this.onLoading();
    } else if (chats!.chat.length != offset) return;
    try {
      final listChats = await _apiProvider.getChats(
        offset: this.offset,
        query: query,
        type: getChatTypeValue(type),
        questChatStatus: questChatStatus,
        starred: type == TypeChat.favourites ? true : null,
      );
      for (int i = 0; i < listChats.length;)
        if (listChats[i].meMember?.status == -1)
          listChats.removeAt(i);
        else
          i++;

      for (int i = 0; i < listChats.length;)
        if (listChats[i].type != typeChat && listChats[i].star == null)
          listChats.removeAt(i);
        else
          i++;

      chats!.setChat(listChats);

      listChats.forEach((element) {
        if (selectedChats[element] == null) selectedChats[element] = false;
      });

      offset += 10;
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  String? getChatTypeValue(TypeChat type) {
    switch (type) {
      case TypeChat.active:
        return "Quest";
      case TypeChat.privates:
        return "Private";
      case TypeChat.group:
        return "Group";
      case TypeChat.completed:
        return "Quest";
      default:
        return null;
    }
  }

  @action
  void chatSort() {
    chats!.chat.sort((key1, key2) {
      return key1.updatedAt.millisecondsSinceEpoch <
              key2.updatedAt.millisecondsSinceEpoch
          ? 1
          : 0;
    });
  }

  @action
  void setChatSelected(bool value) => chatSelected = value;

  @action
  void resetSelectedChats() => selectedChats.forEach((key, value) {
        selectedChats[key] = false;
      });

  @action
  void setChatHighlighted(ChatModel chat) =>
      selectedChats[chat] = !selectedChats[chat]!;

  String getCountStarredChats() {
    int count = 0;
    selectedChats.values.toList().forEach((element) {
      if (element) count++;
    });
    return count.toString();
  }

  @action
  Future<void> setStar() async {
    selectedChats.forEach((key, value) async {
      if (selectedChats[key] == true) {
        if (key.star == null)
          await _apiProvider.setChatStar(chatId: key.id);
        else
          await _apiProvider.removeStarFromChat(chatId: key.id);
      }
    });
    setChatSelected(false);
    resetSelectedChats();
  }

  @action
  void addedMessage(dynamic json) {
    try {
      MessageModel? message;
      // if (json["path"] == "/notifications/quest") {
      //   final quest = BaseQuestResponse.fromJson(
      //       json["message"]["data"]["quest"] ?? json["message"]["data"]);
      //   if (quest.status == 5) {
      //     loadChats();
      //   }
      //   return;
      // }
      if (json["type"] == "request") {
        message = MessageModel.fromJson(json["payload"]["result"]);
        // } else if (json["message"]["action"] == "groupChatCreate") {
        //   print(json["message"]["data"]);
        //   print(json["message"]["data"]["lastMessage"]);
        //   message = MessageModel.fromJson(json["message"]["data"]["lastMessage"]);
        //   setMessages(
        //       [MessageModel.fromJson(json["message"]["data"]["lastMessage"])],
        //       ChatModel.fromJson(json["message"]["data"]));
        //   _atomChats.reportChanged();
        //   return;
      } else if (json["type"] == "pub") {
        message = MessageModel.fromJson(json["message"]["data"]);
        // } else if (json["message"]["action"] == "messageReadByRecipient") {
        //   message = MessageModel.fromJson(json["message"]["data"]);
        //   chats[message.chatId]!.chatModel.chatData.lastMessage.senderStatus =
        //       "read";
        //   _atomChats.reportChanged();
        //   return;
      }
      final chatIndex = chats?.chat
          .indexWhere((element) => element.chatData.chatId == message?.chatId);
      if (chatIndex! < 0) {
        loadChats(
          type: typeChat,
          questChatStatus: typeChat == TypeChat.active
              ? 0
              : typeChat == TypeChat.completed
                  ? -1
                  : null,
        );
      } else {
        chats!.chat[chatIndex].chatData.lastMessage = message!;
      }

      // final saveChat = chats.remove(message.chatId);
      //
      // chats[message.chatId] = saveChat!;
      //
      // chatSort();
      // updateListsChats();
      // checkMessage();
      chatSort();
    } catch (e, trace) {
      this.onError(e.toString());
      print("ERROR: $e");
      print("ERROR: $trace");
    }
  }

  @action
  void checkMessage() {
    for (int i = 0; i < (chats?.chat.length ?? 0); i++) {
      if (chats!.chat[i].chatData.lastMessage.senderStatus == "Unread" &&
          chats!.chat[i].chatData.lastMessage.senderMemberId != myId) {
        streamChatNotification!.sink.add(true);
        return;
      }
    }
    streamChatNotification!.sink.add(false);
  }

  @action
  Future<void> setMessageRead(String chatId, String messageId) async {
    try {
      await _apiProvider.setMessageRead(chatId: chatId, messageId: messageId);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
