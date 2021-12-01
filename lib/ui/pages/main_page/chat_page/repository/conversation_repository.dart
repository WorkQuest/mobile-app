// import 'package:app/model/chat_model/chat_model.dart';
// import 'package:app/model/chat_model/message_model.dart';
// import 'package:app/utils/web_socket.dart';
// import 'package:injectable/injectable.dart';
// import 'package:mobx/mobx.dart';
//
// import 'chat.dart';
//
// @singleton
// class ConversationRepository {
//   ConversationRepository() {
//     WebSocket().handlerChats = this.addedMessage;
//   }
//
//   final _$messagesAtom = Atom(name: '_ChatRoomStore.messages');
//   Map<String, Chats> chats = {};
//
//   Chats? chatByID(String? id) {
//     _$messagesAtom.reportRead();
//     if (id == null) return null;
//     return chats[id];
//   }
//
//   void setMessage(List<MessageModel> messages, ChatModel chat) {
//     chats[chat.id] = Chats(chat);
//     chats[chat.id]!.messages = messages;
//     _$messagesAtom.reportChanged();
//   }
//
//   void addAllMessages(List<MessageModel> messages, String id) {
//     try {
//       if (chats[id] == null) return;
//       chats[id]!.messages.addAll(messages);
//       _$messagesAtom.reportChanged();
//     } catch (e, trace) {
//       print("$e $trace");
//     }
//   }
//
//   MessageModel? getLastMessage(String chatId) {
//     _$messagesAtom.reportRead();
//     return chats[chatId]?.chatModel.lastMessage;
//   }
//
//   void addedMessage(MessageModel message) {
//     var chat = chats[message.chatId];
//     if (chat == null) return;
//     chat.chatModel.lastMessage = message;
//     chat.messages.insert(0, message);
//     _$messagesAtom.reportChanged();
//   }
// }
