import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';

import 'chat.dart';

class ConversationRepository {
  static final ConversationRepository _singleton =
      ConversationRepository._internal();

  factory ConversationRepository() {
    return _singleton;
  }

  ConversationRepository._internal();

  List<Chats> chats = [];

  void getMsg(List<MessageModel> messages, ChatModel chat, int index) {
    try {
      chats.add(Chats());
      chats[index].messages = messages;
      chats[index].chatModel = chat;
    } catch (e, trace) {
      print("ERROR: $e");
      print("ERROR: $trace");
    }
  }

  void addedMsg(MessageModel message) {
    for (int index = 0; index < chats.length; index++) {
      if ((chats[index].chatModel?.id ?? "") == message.chatId) {
        chats[index].chatModel!.lastMessage = message;
        chats[index].messages.insert(0, message);
      }
    }
    // chats.forEach((element) {
    //   if ((element.chatModel?.id ?? "") == message.chatId) {
    //     element.chatModel!.lastMessage = message;
    //     element.messages.insert(0,message);
    //   }
    // });
  }
}
