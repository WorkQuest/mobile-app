import 'package:app/model/chat_model/chat_model.dart';

import '../../../../model/chat_model/message_model.dart';

class Chats {
  Chats(this.chat);

  late List<ChatModel> chat;

  void setChats(List<ChatModel> listChats) => chat.addAll(listChats);

  void clearChat() => chat.clear();

  int? getQuestChatStatus() => chat.first.questChat?.status;

  void setLastMessage(int chatIndex, MessageModel message) {}
}
