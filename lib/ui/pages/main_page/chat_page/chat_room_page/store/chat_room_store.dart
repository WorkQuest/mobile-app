import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
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

  int count = 0;
  int offset = 0;
  int limit = 10;

  @observable
  ChatModel? chat;

  @observable
  bool isloadingMessages = false;

  @action
  Future loadChat() async {
    try {
      this.onLoading();
      if (chat!.messages == null)
        chat!.messages = ObservableList<MessageModel>.of([]);
      count = chat!.messages!.length + 1;
      await getMessages();
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  getMessages() async {
    if (chat!.messages!.length >= count) return;
    isloadingMessages = true;
    final responseData = await _apiProvider.getMessages(
      chatId: chat!.id,
      offset: offset,
      limit: limit,
    );
    count = responseData["count"];
    if (count == 0) return;
    if (chat!.messages!.length >= count) return;
    offset = count - offset > limit
        ? offset + limit
        : offset == 0
            ? count
            : offset + (count % limit);
    chat!.messages!.insertAll(
      chat!.messages!.length,
      ObservableList<MessageModel>.of(
        List<MessageModel>.from(
          responseData["messages"].map(
            (x) => MessageModel.fromJson(x),
          ),
        ),
      ),
    );
    isloadingMessages = false;
  }

  @action
  Future sendMessage(String text) async {
    var message = MessageModel(
      id: "id",
      chatId: chat!.id,
      isMy: true,
      text: text,
      senderUserId: "senderUserId",
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
      medias: [],
      status: MessageStatus.Wait,
    );
    chat!.messages!.insert(0, message);
    final check = await _apiProvider.sendMessageToChat(
      chatId: chat!.id,
      text: text,
    );

    chat!.messages!.remove(message);
    message.updatedAt = DateTime.now();
    if (check)
      message.status = MessageStatus.Send;
    else
      message.status = MessageStatus.Error;
    chat!.messages!.insert(0, message);
  }
}
