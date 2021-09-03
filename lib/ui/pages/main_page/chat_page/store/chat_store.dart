import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/utils/web_socket.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'chat_store.g.dart';

@singleton
class ChatStore extends _ChatStore with _$ChatStore {
  ChatStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ChatStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  String _myId = "";

  _ChatStore(this._apiProvider) {
    WebSocket().setListener(this._handle);
  }

  _handle(Map<String, dynamic> json) {
    final indexChat = chats.indexWhere(
        (element) => (element.id) == (json["message"]?["chatId"] ?? ""));
    if (indexChat >= 0) {
      if (chats[indexChat].messages == null)
        chats[indexChat].messages = ObservableList<MessageModel>.of([]);
      chats[indexChat]
          .messages!
          .insert(0, MessageModel.fromJson(json["message"]["message"], ""));
    }
  }

  @observable
  List<String> selectedCategories = [
    'Starred message',
    'Report',
    'Create group chat'
  ];

  @observable
  List<ChatModel> chats = [];

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

  getMessages() async {
    chats.forEach((element) async {
      final responseData = await _apiProvider.getMessages(
        chatId: element.id,
        offset: 0,
        limit: 20,
      );
      element.messages = ObservableList<MessageModel>.of([]);
      element.messages!.insertAll(
        element.messages!.length,
        ObservableList<MessageModel>.of(
          List<MessageModel>.from(
            responseData["messages"].map(
              (x) => MessageModel.fromJson(x, this._myId),
            ),
          ),
        ),
      );
    });
  }
}
