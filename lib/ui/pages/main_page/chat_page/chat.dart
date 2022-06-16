import 'package:app/model/chat_model/chat_model.dart';

class Chats {
  Chats(this.chat);

  late List<ChatModel> chat;

  void setChat(List<ChatModel> listChats) => chat.addAll(listChats);

  void clearChat() => chat.clear();

  int? getQuestChatStatus() => chat.first.questChat?.status;
}
