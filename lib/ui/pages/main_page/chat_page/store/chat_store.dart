import 'dart:async';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/chat_model/star.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/chat_page/chat.dart';
import 'package:app/utils/web_socket.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app/http/chat_extension.dart';
import '../../../../../enums.dart';

part 'chat_store.g.dart';

@singleton
class ChatStore extends _ChatStore with _$ChatStore {
  ChatStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ChatStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;
  StreamController<bool>? streamChatNotification;

  @observable
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
  String query = '';

  @observable
  ObservableList<ChatModel> activeChats = ObservableList.of([]);

  @observable
  ObservableList<ChatModel> favouritesChats = ObservableList.of([]);

  @observable
  ObservableList<ChatModel> groupChats = ObservableList.of([]);

  @observable
  ObservableList<ChatModel> completedChats = ObservableList.of([]);

  @observable
  ObservableList<String> chatsId = ObservableList.of([]);

  @observable
  ObservableMap<String, bool> idChatsForStar = ObservableMap.of({});

  Chats? chatByID(String id) {
    if (chats[id] == null) return null;
    chats[id]!.read();
    // updateListsChats();
    return chats[id];
  }

  final _atomChats = Atom(name: 'ChatStore._atomChats');

  List<String> get chatKeyList {
    _atomChats.reportRead();
    var keys = chats.keys.toList();
    var values = chats.values.toList();

    chatSort();

    values.forEach((element) {
      if (idChatsForStar[element.chatModel.id] == null) idChatsForStar[element.chatModel.id] = false;
    });
    return keys;
  }

  int compareTest(int a, int b) {
    if (a == b) return 0;
    return a > b ? 1 : -1;
  }

  @action
  setQuery(String value) => query = value;

  @action
  void chatSort() {
    chats = Map.fromEntries(chats.entries.toList()
      ..sort((a, b) => compareTest(b.value.chatModel.lastMessage.createdAt.millisecondsSinceEpoch,
          a.value.chatModel.lastMessage.createdAt.millisecondsSinceEpoch))
      ..takeWhile((_) => true));
    updateListsChats();
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
  setChatHighlighted(ChatModel chat) {
    idChatsForStar[chat.id] = !idChatsForStar[chat.id]!;
    for (int i = 0; i < chatsId.length; i++) {
      if (chatsId[i] == chat.id) {
        chatsId.removeAt(i);
        return;
      }
    }
    chatsId.add(chat.id);
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
    updateListsChats();
    uncheck();
    _atomChats.reportRead();
  }

  void setMessages(List<MessageModel> messages, ChatModel chat) {
    if (chats[chat.id] == null) chats[chat.id] = Chats(chat);
    chats[chat.id]!.messages = messages;
    chats[chat.id]!.update();
    _atomChats.reportChanged();
    updateListsChats();
    chatSort();
  }

  void addAllMessages(List<MessageModel> messages, String id) {
    try {
      if (chats[id] == null) return;
      chats[id]!.messages.addAll(messages);
      checkMessage();
      chats[id]!.update();
      updateListsChats();
    } catch (e, trace) {
      print("$e $trace");
    }
  }

  void addedMessage(dynamic json) {
    try {
      MessageModel? message;
      if (json["path"] == "/notifications/quest") {
        final quest = BaseQuestResponse.fromJson(json["message"]["data"]["quest"] ?? json["message"]["data"]);
        if (quest.status == 5) {
          loadChats();
        }
        return;
      }
      if (json["type"] == "request") {
        message = MessageModel.fromJson(json["payload"]["result"]);
      } else if (json["message"]["action"] == "groupChatCreate") {
        print(json["message"]["data"]);
        print(json["message"]["data"]["lastMessage"]);
        message = MessageModel.fromJson(json["message"]["data"]["lastMessage"]);
        setMessages([MessageModel.fromJson(json["message"]["data"]["lastMessage"])],
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
      var chat = chats[message!.chatId];
      print('chatId: ${message.chatId}');
      if (chat == null) {
        print('chat is null');
        chat = Chats(ChatModel(
          id: message.chatId,
          ownerUserId: null,
          lastMessageId: message.id,
          lastMessageDate: message.createdAt,
          name: null,
          type: '',
          owner: null,
          lastMessage: message,
          meMember: null,
          userMembers: [userData!, message.sender!],
          star: null,
          questChat: null,
        ));
        chats[message.chatId] = chat;
      } else {
        chat.chatModel.lastMessage = message;
        chat.messages.insert(0, message);
      }

      final saveChat = chats.remove(message.chatId);

      chats[message.chatId] = saveChat!;

      chatSort();
      updateListsChats();
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
  String setInfoMessage(String infoMessage) {
    switch (infoMessage) {
      case "groupChatCreate":
        return infoMessageValue = "chat.infoMessage.groupChatCreate".tr();
      case "employerRejectResponseOnQuest":
        return infoMessageValue = "chat.infoMessage.employerRejectResponseOnQuest".tr();
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
    await loadChats();
    WebSocket().connect();
  }

  @action
  void checkMessage() {
    int i = 0;
    unread = false;
    while (i != chats.values.length && unread == false) {
      if (chats.values.toList()[i].chatModel.lastMessage.senderStatus == "unread" &&
          chats.values.toList()[i].chatModel.lastMessage.senderUserId != this._myId) {
        streamChatNotification!.sink.add(true);
        unread = true;
        return;
      }
      i++;
    }
    streamChatNotification!.sink.add(false);
  }

  void initialStore() async {
    if (streamChatNotification != null) await streamChatNotification!.close();
    streamChatNotification = StreamController<bool>.broadcast();
  }

  @action
  updateListsChats() {
    List<ChatModel> bufferActive = [];
    chats.forEach((key, value) {
      final indexActive = activeChats.indexWhere((element) => element.id == key);
      if (indexActive != -1) {
        activeChats[indexActive] = value.chatModel;
      } else {
        activeChats.add(value.chatModel);
      }
      activeChats.sort((a, b) {
        final aTime = a.lastMessage.createdAt.millisecondsSinceEpoch;
        final bTime = b.lastMessage.createdAt.millisecondsSinceEpoch;
        if (aTime == bTime) return 0;
        return aTime < bTime ? 1 : -1;
      });
      bufferActive.addAll(activeChats);
      activeChats
        ..clear()
        ..addAll(bufferActive);
      bufferActive.clear();
      final indexFavourites = favouritesChats.indexWhere((element) => element.id == key);
      if (indexFavourites != -1) {
        favouritesChats[indexFavourites] = value.chatModel;
      }
      bufferActive.addAll(favouritesChats);
      favouritesChats
        ..clear()
        ..addAll(bufferActive);
      bufferActive.clear();
      favouritesChats.sort((a, b) {
        final aTime = a.lastMessage.createdAt.millisecondsSinceEpoch;
        final bTime = b.lastMessage.createdAt.millisecondsSinceEpoch;
        if (aTime == bTime) return 0;
        return aTime < bTime ? 1 : -1;
      });
      //TODO: End update other lists where adding requests
    });
  }

  @action
  Future loadChats({bool loadMore = false, bool? starred, String query = '', TypeChat type = TypeChat.active}) async {
    print('loadChats | loadMore = $loadMore | type = $type');
    if (!loadMore) {
      // chats = {};
      // starredChats.clear();

      this.offset = 0;
      refresh = false;
      isLoadingChats = false;
    } else {
      isLoadingChats = true;
    }

    if (this._myId.isEmpty || (_count == chats.length && refresh)) {
      isLoadingChats = false;
      return;
    }
    try {
      _count = chats.length;
      if (!loadMore) this.onLoading();
      List<ChatModel> listChats;
      switch (type) {
        case TypeChat.active:
          if (!loadMore) {
            activeChats.clear();
          }
          listChats = await _apiProvider.getChats(
            offset: this.activeChats.length,
            limit: this.limit,
            query: query,
          );
          activeChats.addAll(listChats);
          break;
        case TypeChat.favourites:
          if (!loadMore) {
            favouritesChats.clear();
          }
          listChats = await _apiProvider.getChats(
            offset: this.favouritesChats.length,
            limit: this.limit,
            query: query,
            starred: true,
          );
          favouritesChats.addAll(listChats);
          break;
        case TypeChat.group:
          await Future.delayed(const Duration(seconds: 1));
          listChats = [];
          break;
        case TypeChat.completed:
          await Future.delayed(const Duration(seconds: 1));
          listChats = [];
          break;
      }

      listChats.forEach((chat) {
        chats[chat.id] = Chats(chat);
        // if (chats[chat.id]!.chatModel.star != null)
        //   starredChats.add(chats[chat.id]!);
      });
      checkMessage();
      this.offset = chats.length;
      refresh = true;
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
    isLoadingChats = false;
  }

  @action
  Future getUserData(ProfileMeResponse profile) async {
    userData = profile;
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

enum TypeChat { active, favourites, group, completed }
