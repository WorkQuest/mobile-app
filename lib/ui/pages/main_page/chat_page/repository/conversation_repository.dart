import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/utils/web_socket.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import 'chat.dart';

@singleton
class ConversationRepository {
  ConversationRepository() {
    WebSocket().handlerChats = this.addedMessage;
  }

  // static final ConversationRepository _singleton =
  //     ConversationRepository._internal();
  //
  // factory ConversationRepository() {
  //   return _singleton;
  // }

  // ConversationRepository._internal();

  // ChatRoomStore? store;

  bool flag = false;
  final _$messagesAtom = Atom(name: '_ChatRoomStore.messages');
  Map<String, Chats> _chats = {};

  Chats? chatByID(String? id) {
    _$messagesAtom.reportRead();
    if (id == null) return null;
    return _chats[id];
  }

  void setMessage(List<MessageModel> messages, ChatModel chat) {
    try {
      _chats[chat.id] = Chats(chat);
      _chats[chat.id]!.messages =  messages;
      _$messagesAtom.reportChanged();
      // if (index >= chats.length) chats.add(Chats(chat));
      // chats[index].messages = messages;
    } catch (e, trace) {
      print("ERROR: $e");
      print("ERROR: $trace");
    }
  }

  void addAllMessages(List<MessageModel> messages, String id) {
    try {
      if (_chats[id] == null) return;
      _chats[id]!.messages.addAll(messages);
      _$messagesAtom.reportChanged();
    } catch (e, trace) {
      print("$e $trace");
    }
  }

  void addedMessage(MessageModel message) {
    var chat = _chats[message.chatId];
    if (chat == null) return;
    // for (int index = 0; index < chats.length; index++) {
    //   if ((chats[index].chatModel?.id ?? "") == message.chatId) {
    chat.chatModel.lastMessage = message;
    chat.messages.insert(0, message);
    print("LENGTH: ${chat.messages.length}");
    _$messagesAtom.reportChanged();
    // updateMessages(chats[index].messages);
    // print("MESSAGE: ${chats[index].messages.first.text}");
    // }
    // print("ADDMESSAGE");
    // }
    // flag = true;
  }

  void updateMessages(List<MessageModel> messages) {
    // store!.updateMessages(messages);
    print("UPDATEMESSAGE");
  }
}
