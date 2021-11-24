import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/ui/pages/main_page/chat_page/repository/conversation_repository.dart';
import 'package:app/utils/web_socket.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../enums.dart';

part 'chat_store.g.dart';

@singleton
class ChatStore extends _ChatStore with _$ChatStore {
  ChatStore(ApiProvider apiProvider, ConversationRepository repo)
      : super(apiProvider, repo);
}

abstract class _ChatStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;
  final ConversationRepository repo;

  String _myId = "";
  int offset = 0;
  int limit = 10;

  UserRole? role;

  _ChatStore(this._apiProvider, this.repo) {
    // WebSocket().setListener(this._handle);
  }

  // _handle(Map<String, dynamic> json) {
  //   print("qwerqwerqwerqwerqwre");
  //   final indexChat = chats.indexWhere(
  //       (element) => (element.id) == (json["message"]?["chatId"] ?? ""));
  //   if (indexChat >= 0) {
  //     // if (chats[indexChat].lastMessage == null)
  //     //   chats[indexChat].lastMessage = LastMessage(
  //     //     id: '',
  //     //     number: 0,
  //     //     senderUserId: '',
  //     //     chatId: '',
  //     //     text: '',
  //     //     type: '',
  //     //     senderStatus: '',
  //     //     sender: null,
  //     //     medias: [],
  //     //   );
  //     chats[indexChat].lastMessage =
  //         MessageModel.fromJson(json["message"]["message"]);
  //     print("indexChat: ${chats[indexChat].lastMessage}");
  //   }
  // }

  @observable
  List<String> selectedCategoriesWorker = [
    "Starred message",
    "Report",
    "Create group chat",
  ];

  @observable
  List<String> selectedCategoriesEmployer = [
    "Starred message",
    "Report",
  ];

  @observable
  ObservableList<ChatModel> chats = ObservableList.of([]);

  @observable
  String infoMessageValue = "";

  @observable
  bool isLoadingChats = false;

  @observable
  bool refresh = false;

  @observable
  int _count = 0;

  @observable
  ObservableList<MessageModel> messages = ObservableList.of([]);

  @action
  String setInfoMessage(String infoMessage) {
    switch (infoMessage) {
      case "groupChatCreate":
        return infoMessageValue = "You created a group chat";
      case "employerRejectResponseOnQuest":
        return infoMessageValue =
            "The employer rejected the response to the request";
      case "workerResponseOnQuest":
        return infoMessageValue = "You have responded to the quest";
    }
    return infoMessageValue;
  }

  initialSetup(String myId) async {
    this._myId = myId;
    await loadChats(false);
    WebSocket().connect();
  }

  @action
  Future loadChats(bool isNewList) async {
    if (isNewList) {
      chats = ObservableList.of([]);
      this.offset = 0;
      refresh = false;
    }
    if (this._myId.isEmpty || (_count == chats.length && refresh) )
      return;
    try {
      // this.offset = 0;
      // this.limit = 10;
      _count = chats.length;
      this.onLoading();
      chats.addAll(await _apiProvider.getChats(
        offset: this.offset,
        limit: this.limit,
      ));
      this.offset = chats.length;
      getMessages();
      refresh = true;
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  getMessages() async {
    chats.forEach((element) async {
      final responseData = await _apiProvider.getMessages(
        chatId: element.id,
        offset: 0,
        limit: 20,
      );
      messages = ObservableList.of([]);
      messages.insertAll(
        messages.length,
        List<MessageModel>.from(
          responseData["messages"].map(
            (x) => MessageModel.fromJson(x),
          ),
        ),
      );
      repo.setMessage(messages, element);
    });
  }
}
