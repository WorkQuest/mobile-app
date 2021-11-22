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
  ChatStore(ApiProvider apiProvider, ConversationRepository repo) : super(apiProvider,repo);
}

abstract class _ChatStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;
  final ConversationRepository repo;

  String _myId = "";

  UserRole? role;

  _ChatStore(this._apiProvider,this.repo) {

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
    "chat.favoriteMessages".tr(),
    "chat.openDispute".tr(),
    "chat.createGroupChat".tr(),
  ];

  @observable
  List<String> selectedCategoriesEmployer = [
    "chat.favoriteMessages".tr(),
    "chat.openDispute".tr(),
  ];

  @observable
  List<ChatModel> chats = [];

  @observable
  ObservableList<MessageModel> messages = ObservableList.of([]);

  initialSetup(String myId) async {
    this._myId = myId;
    await loadChats();
    WebSocket().connect();
  }

  @action
  Future loadChats() async {
    if (this._myId.isEmpty) return;
    try {
      this.onLoading();
      chats = await _apiProvider.getChats();
      getMessages();
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
