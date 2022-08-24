import 'dart:async';
import 'dart:developer';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/chat_model/star.dart';
import 'package:app/model/profile_response/profile_statistic.dart';
import 'package:app/ui/pages/main_page/chat_page/chat.dart';
import 'package:app/http/web_socket.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:get_it/get_it.dart';
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

  @observable
  bool starred = false;

  @observable
  bool chatSelected = false;

  @observable
  ObservableMap<TypeChat, Chats> chats = ObservableMap.of({});

  @observable
  TypeChat typeChat = TypeChat.all;

  String myId = "";

  ProfileStatistic? profileStatistic;

  ObservableMap<ChatModel, bool> selectedChats = ObservableMap.of({});

  void initialStore() async {
    if (streamChatNotification != null) await streamChatNotification!.close();
    streamChatNotification = StreamController<bool>.broadcast();
    getProfileStatistic();
  }

  void initialSetup(String myId) async => WebSocket().connect();

  void setMyId(String value) => myId = value;

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
      this.onLoading();
    }
    try {
      final listChats = await _apiProvider.getChats(
        offset: chats[type]!.chat.length,
        query: query,
        type: getChatTypeValue(type),
        questChatStatus: questChatStatus,
        starred: type == TypeChat.favourites ? true : null,
      );
      chats[type]!.setChats(listChats);

      listChats.forEach((element) {
        if (selectedChats[element] == null) selectedChats[element] = false;
      });
      checkMessage();
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  void refreshChats() {
    loadChats(type: TypeChat.all);
    loadChats(type: TypeChat.privates);
    loadChats(type: TypeChat.group);
    loadChats(type: TypeChat.active, questChatStatus: 0);
    loadChats(type: TypeChat.completed, questChatStatus: -1);
    loadChats(starred: true, type: TypeChat.favourites);
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
  setChatType(int indexTab) => typeChat = getChatTypeFromIndex(indexTab);

  @action
  void setChatSelected(bool value) => chatSelected = value;

  @action
  void resetSelectedChats() => selectedChats.forEach((key, value) {
        selectedChats[key] = false;
      });

  @action
  void setChatHighlighted(ChatModel chat) => selectedChats[chat] = !selectedChats[chat]!;

  String getCountStarredChats() {
    int count = 0;
    selectedChats.values.toList().forEach((element) {
      if (element) count++;
    });
    return count.toString();
  }

  @action
  Future<void> setStar() async {
    selectedChats.forEach((key1, value1) async {
      if (selectedChats[key1] == true) {
        if (key1.star == null) {
          await _apiProvider.setChatStar(chatId: key1.id);
          key1.star = Star(id: "");
        } else {
          await _apiProvider.removeStarFromChat(chatId: key1.id);
          key1.star = null;
        }
        changeChat(key1);
      }
    });

    setChatSelected(false);
    resetSelectedChats();
  }

  @action
  void changeChat(ChatModel chat) {
    chats = ObservableMap.of(chats.map((key, value) {
      value.chat.map((element) {
        if (element.id == chat.id) {
          final _old = chats[key]!.chat.firstWhere((chat) => chat.id == element.id);
          _old.star = chat.star;
          final index = chats[key]!.chat.indexWhere((chat) => chat.id == element.id);
          chats[key]!.chat.removeWhere((chat) => chat.id == element.id);
          chats[key]!.chat.insert(index, _old);
        }
      }).toList();
      return MapEntry(key, value);
    }));
  }

  @action
  void addedMessage(dynamic json) {
    try {
      MessageModel? message;
      log('addedMessage json: $json');
      if (json["type"] == "request") {
        message = MessageModel.fromJson(json["payload"]["result"]);
      } else if (json["message"]["action"] == "QuestStatusUpdated") {
        refreshChats();
        return;
      }
      else if (json["message"]["action"] == "employerInvitedWorkerToQuest") {
        refreshChats();
        return;
      }
      else if (json["message"]["action"] == "workerRespondedToQuest") {
        refreshChats();
        return;
      } else if (json["message"]["action"] == "groupChatCreate") {
        message = MessageModel.fromJson(json["message"]["data"]);
      } else if (json["type"] == "pub" || json["message"]["action"] == "messageReadByRecipient") {
        message = MessageModel.fromJson(json["message"]["data"]);
      }

      bool isChatExist = false;

      chats = ObservableMap.of(chats.map((key, value) {
        value.chat.forEach((element) {
          if (element.id == message!.chatId) {
            final _old = chats[key]!.chat.firstWhere((chat) => chat.id == element.id);
            _old.chatData.lastMessage = message;
            chats[key]!.chat.removeWhere((chat) => chat.id == element.id);
            chats[key]!.chat.insert(0, _old);
            isChatExist = true;
          }
        });
        return MapEntry(key, value);
      }));

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
            element.chatData.lastMessage!.sender?.userId != GetIt.I.get<ProfileMeStore>().userData!.id) {
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
      chats = ObservableMap.of(chats.map((key, value) {
        value.chat.map((element) {
          if (element.id == chatId) {
            final _old = chats[key]!.chat.firstWhere((chat) => chat.id == element.id);
            _old.chatData.lastMessage!.senderStatus = "Read";
            final index = chats[key]!.chat.indexWhere((chat) => chat.id == element.id);
            chats[key]!.chat.removeWhere((chat) => chat.id == element.id);
            chats[key]!.chat.insert(index, _old);
          }
        }).toList();
        return MapEntry(key, value);
      }));
      await _apiProvider.setMessageRead(chatId: chatId, messageId: messageId);
      checkMessage();
    } catch (e) {
      this.onError(e.toString());
    }
  }

  getChatTypeFromIndex(int index) {
    switch (index) {
      case 0:
        return TypeChat.all;
      case 1:
        return TypeChat.privates;
      case 2:
        return TypeChat.group;
      case 3:
        return TypeChat.active;
      case 4:
        return TypeChat.completed;
      case 5:
        return TypeChat.favourites;
    }
  }

  clearData() => streamChatNotification?.close();

  Future getProfileStatistic() async {
    try {
      this.onLoading();
      Future.delayed(Duration(milliseconds: 250));
      profileStatistic = await _apiProvider.getProfileStatistic();
      if (profileStatistic!.chatsStatistic.unreadCountChats > 0)
        streamChatNotification!.sink.add(true);
      else
        streamChatNotification!.sink.add(true);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
