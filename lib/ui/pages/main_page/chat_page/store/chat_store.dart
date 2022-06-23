import 'dart:async';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
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
  bool starred = false;

  @observable
  bool chatSelected = false;

  @observable
  ObservableMap<TypeChat, Chats> chats = ObservableMap.of({});

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
    chats[type] ??= Chats([]);
    if (!loadMore) {
      chats[type]!.clearChat();
      offset = 0;
      this.onLoading();
    } else if (chats[type]!.chat.length != offset) return;
    try {
      final listChats = await _apiProvider.getChats(
        offset: this.offset,
        query: query,
        type: getChatTypeValue(type),
        questChatStatus: questChatStatus,
        starred: type == TypeChat.favourites ? true : null,
      );

      // listChats.removeWhere((element) => element.meMember?.status == -1);

      chats[type]!.setChats(listChats);

      listChats.forEach((element) {
        if (selectedChats[element] == null) selectedChats[element] = false;
      });

      offset += 10;
      checkMessage();
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

  void getChatTypeFromIndex(int index) {
    switch (index) {
      case 0:
        typeChat = TypeChat.active;
        return;
      case 1:
        typeChat = TypeChat.privates;
        return;
      case 2:
        typeChat = TypeChat.favourites;
        return;
      case 3:
        typeChat = TypeChat.group;
        return;
      case 4:
        typeChat = TypeChat.completed;
        return;
    }
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
      if (json["message"]["action"] == "QuestStatusUpdated") return;
      if (json["type"] == "request") {
        message = MessageModel.fromJson(json["payload"]["result"]);
      } else if (json["message"]["action"] == "groupChatCreate") {
        message = MessageModel.fromJson(json["message"]["data"]);
      } else if (json["type"] == "pub" ||
          json["message"]["action"] == "messageReadByRecipient") {
        message = MessageModel.fromJson(json["message"]["data"]);
      }

      bool isChatExist = false;
      chats.forEach((key, value) {
        value.chat.forEach((element) {
          if (element.id == message!.chatId) {
            chats[key]!.chat.removeWhere((chat) => chat.id == element.id);
            element.chatData.lastMessage = message;
            chats[key]!.chat.insert(0, element);
            isChatExist = true;
          }
        });
      });

      if (!isChatExist) getChat(message!.chatId!);
      checkMessage();
    } catch (e, trace) {
      this.onError(e.toString());
      print("ERROR: $e");
      print("ERROR: $trace");
    }
  }

  @action
  Future<void> getChat(String chatId) async {
    try {
      this.onLoading();
      final response = await _apiProvider.getChat(chatId: chatId);
      (chats[response.type] ?? Chats([])).chat.insert(0, response);
      if (selectedChats[response] == null) selectedChats[response] = false;
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  void checkMessage() {
    bool check = false;
    chats.forEach((key, value) {
      value.chat.forEach((element) {
        if (element.chatData.lastMessage!.senderStatus == "Unread" &&
            element.chatData.lastMessage!.sender?.userId != myId) {
          check = true;
          return;
        }
      });
    });
    if (check)
      streamChatNotification!.sink.add(true);
    else
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
