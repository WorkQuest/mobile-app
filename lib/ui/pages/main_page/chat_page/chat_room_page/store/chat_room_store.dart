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

  ChatModel? chat;

  @observable
  ObservableList<MessageModel>? messages;

  @action
  Future loadChat() async {
    try {
      this.onLoading();
      chat!.messages = await _apiProvider.getMessages(chatId: chat!.id);
      if (chat!.messages == null) chat!.messages = [];
      messages = ObservableList<MessageModel>.of(chat!.messages!);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
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
    messages!.insert(0, message);
    final data =
        await _apiProvider.sendMessageToChat(chatId: chat!.id, text: text);

    messages!.remove(message);
    message.updatedAt = DateTime.now();
    if (data)
      message.status = MessageStatus.Send;
    else
      message.status = MessageStatus.Error;
    messages!.insert(0, message);
  }
}
