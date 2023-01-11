import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:mobx/mobx.dart';

class Chats {
  final Atom _atom;
  ChatModel _chatModel;
  List<MessageModel> _messages = [];

  ChatModel get chatModel {
    read();
    return _chatModel;
  }

  List<MessageModel> get messages {
    read();
    return _messages;
  }

  set messages(List<MessageModel> list) {
    _messages = list;
    update();
  }

  void read() => _atom.reportRead();

  void update() => _atom.reportChanged();

  Chats(this._chatModel) : _atom = Atom(name: '_Chat${_chatModel.id}');
}
