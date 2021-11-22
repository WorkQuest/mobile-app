import 'dart:async';

import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/ui/pages/main_page/chat_page/repository/chat.dart';
import 'package:app/ui/pages/main_page/chat_page/repository/conversation_repository.dart';
import 'package:app/utils/web_socket.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'chat_room_store.g.dart';

@injectable
class ChatRoomStore extends _ChatRoomStore with _$ChatRoomStore {
  ChatRoomStore(ApiProvider apiProvider, ConversationRepository repo)
      : super(apiProvider, repo);
}

abstract class _ChatRoomStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;
  final ConversationRepository repo;

  _ChatRoomStore(this._apiProvider, this.repo);

  int _count = 0;
  int _offset = 0;
  int _limit = 20;
  String? idChat;

  @observable
  String _myId = "";

  @computed
  Chats? get chat => repo.chatByID(idChat);

  // List<MessageModel> get messages {
  //   if (chatId == null) return [];
  //   return repo.chats
  //       .firstWhere((chat) => chat.chatModel?.id == chatId)
  //       .messages;
  // }

  // void addMessages(List<MessageModel> list) {
  //   _messages.addAll(list);
  //   _$messagesAtom.reportChanged();
  // }

  // set addFirstMessage(MessageModel mess) {
  //   _messages.insert(0, mess);
  //   _$messagesAtom.reportChanged();
  // }

  @observable
  bool isLoadingMessages = false;

  @observable
  bool refresh = false;

  @observable
  bool flag = false;

  @action
  void updateMessages(List<MessageModel> msg) {
    // messages = msg;
    // print("HEEEEEEEEY: ${msg.first.text}");
  }

  @action
  void loadChat(String chatId) {
    idChat = chatId;
    print("${chat?.messages.length}");
    // this.chat = repo.chats.firstWhere((chat) => chat.chatModel?.id == chatId);
    // repo.chats.forEach((element) {
    //   if (element.chatModel!.id == chatId) {
    //     chat = element.chatModel;
    //     _count = element.messages.lengthx;
    //
    //     // messages = element.messages;
    //   }
    // });
    for (int index = 0; index < chat!.messages.length; index++)
      if (chat!.messages[index].text == null) chat!.messages.removeAt(index);
  }

  @action
  getMessages() async {
    if (chat!.messages.length >= _count && refresh) {
      refresh = true;
      return;
    }
    isLoadingMessages = true;
    final responseData = await _apiProvider.getMessages(
      chatId: chat!.chatModel.id,
      offset: _offset,
      limit: _limit,
    );

    _count = responseData["count"];

    repo.addAllMessages(
        List<MessageModel>.from(
            responseData["messages"].map((x) => MessageModel.fromJson(x))),
        chat!.chatModel.id);

    for (int index = 0; index < chat!.messages.length; index++)
      if (chat!.messages[index].text == null) chat!.messages.removeAt(index);
    _offset = chat!.messages.length;
    isLoadingMessages = false;
  }

  @action
  Future sendMessage(String text, String chatId, String userId) async {
    WebSocket().sendMessage(chatId: chatId, text: text, medias: []);
    // var message = MessageModel(
    //   id: "",
    //   number: messages.length,
    //   chatId: chatId,
    //   senderUserId: userId,
    //   senderStatus: "",
    //   type: "",
    //   text: text,
    //   createdAt: DateTime.now(),
    //   medias: [],
    //   sender: null,
    //   infoMessage: null,
    //   star: null,
    // );
    // flag = ConversationRepository().flag;
    // messages.insert(0, message);
    // Timer.periodic(Duration(milliseconds: 100), (timer) {
    //   flag = false;
    //   timer.cancel();
    // });
    // ConversationRepository().updateMessages(messages, chatId);
  }
}
