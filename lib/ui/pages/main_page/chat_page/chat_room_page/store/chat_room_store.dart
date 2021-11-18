import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/ui/pages/main_page/chat_page/repository/conversation_repository.dart';
import 'package:app/utils/web_socket.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'chat_room_store.g.dart';

@injectable
class ChatRoomStore extends _ChatRoomStore with _$ChatRoomStore {
  ChatRoomStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ChatRoomStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _ChatRoomStore(this._apiProvider);

  int _count = 0;
  int _offset = 0;
  int _limit = 20;

  @observable
  String _myId = "";

  @observable
  ChatModel? chat;

  @observable
  ObservableList<MessageModel> messages = ObservableList.of([]);

  @observable
  bool isLoadingMessages = false;

  @observable
  bool refresh = false;

  @action
  void loadChat(String chatId) {
    // this.onLoading();
    // _offset = messages.length;
    // final responseData = await _apiProvider.getMessages(
    //   chatId: chatId,
    //   offset: 0,
    //   limit: 1,
    // );
    ConversationRepository().chats.forEach((element) {
      if (element.chatModel!.id == chatId) {
        chat = element.chatModel;
        _count = element.messages.length;
        messages = ObservableList.of(element.messages);
      }
    });

    for (int index = 0; index < messages.length; index++)
      if (messages[index].text == null) messages.removeAt(index);
    // print("hello: ${chat.id}");
    // _count = responseData["count"];
    // chat = ChatModel.fromJson(responseData["chat"]);
  }

  @action
  getMessages(String chatId) async {
    if (messages.length >= _count && refresh) {
      refresh = true;
      return;
    }
    isLoadingMessages = true;
    final responseData = await _apiProvider.getMessages(
      chatId: chatId,
      offset: _offset,
      limit: _limit,
    );

    _count = responseData["count"];
    messages.addAll(
      List<MessageModel>.from(
        responseData["messages"].map(
          (x) => MessageModel.fromJson(x),
        ),
      ),
    );
    for (int index = 0; index < messages.length; index++)
      if (messages[index].text == null) messages.removeAt(index);
    _offset = messages.length;
    isLoadingMessages = false;
  }

  @action
  Future sendMessage(String text, String chatId, String userId) async {
    WebSocket().sendMessage(chatId: chatId, text: text, medias: []);
    var message = MessageModel(
      id: "",
      number: messages.length,
      chatId: chatId,
      senderUserId: userId,
      senderStatus: "",
      type: "",
      text: text,
      createdAt: DateTime.now(),
      medias: [],
      sender: null,
      infoMessage: null,
      star: null,
    );
    // ConversationRepository().chats.forEach((element) {
    //   if (element.chatModel!.id == chatId) {
    messages.insert(0, message);
    //   }
    // });
  }
}
