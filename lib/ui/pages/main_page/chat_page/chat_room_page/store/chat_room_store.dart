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

  int _count = 0;
  int _offset = 0;
  int _limit = 20;

  String _myId = "";

  @observable
  ChatModel? chat;

  @observable
  bool isloadingMessages = false;

  @action
  Future loadChat(String myId) async {
    this._myId = myId;
    try {
      isloadingMessages = true;
      this.onLoading();
      if (chat!.messages == null)
        chat!.messages = ObservableList<MessageModel>.of([]);
      _offset = chat!.messages!.length;
      final responseData = await _apiProvider.getMessages(
        chatId: chat!.id,
        offset: 0,
        limit: 1,
      );
      _count = responseData["count"];
      isloadingMessages = false;
      this.onSuccess(true);
    } catch (e) {
      isloadingMessages = false;
      this.onError(e.toString());
    }
  }

  getMessages() async {
    if (chat!.messages!.length >= _count) return;
    isloadingMessages = true;
    final responseData = await _apiProvider.getMessages(
      chatId: chat!.id,
      offset: _offset,
      limit: _limit,
    );
    _count = responseData["count"];
    // if (_count == 0) return;

    // if (chat!.messages!.length >= _count) return;
    // _offset = _count - _offset > _limit
    //     ? _offset + _limit
    //     : _offset == 0
    //         ? _count
    //         : _offset + (_count % _limit);
    chat!.messages!.insertAll(
      chat!.messages!.length,
      List<MessageModel>.from(
        responseData["messages"].map(
          (x) => MessageModel.fromJson(x, this._myId),
        ),
      ),
    );
    _offset = chat!.messages!.length;

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
