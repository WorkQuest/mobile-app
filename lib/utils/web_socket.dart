import 'dart:convert';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/ui/pages/main_page/chat_page/repository/conversation_repository.dart';
import 'package:app/utils/storage.dart';
import 'package:web_socket_channel/io.dart';

class WebSocket {
  static final WebSocket _singleton = WebSocket._internal();

  // Function(Map<String, dynamic> message)? _messageHandler;
  //
  // setListener(Function(Map<String, dynamic> message)? messageHandler) {
  //   this._messageHandler = messageHandler;
  // }

  late IOWebSocketChannel _channel;

  String _url = "wss://app.workquest.co/api";

  int _counter = 0;

  bool shouldReconnectFlag = true;

  int closeCode = 4001;

  factory WebSocket() {
    return _singleton;
  }

  void connect() async {
    shouldReconnectFlag = true;
    _counter = 0;
    String? token = await Storage.readAccessToken();
    print("[WebSocket]  connecting ...");
    this._channel = IOWebSocketChannel.connect(_url);

    this._channel.sink.add("""{
          "type": "hello",
          "id": 1,
          "version": "2",
          "auth": {
            "headers": {"authorization": "Bearer $token"}
          },
          "subs": ["/notifications/chat"]
        }""");

    this._channel.stream.listen(
          this._onData,
          onError: this._onError,
          onDone: this._onDone,
        );
  }

  void _handleSubscription(dynamic json) async {
    if (json["path"] == "/notifications/chat") {
      // changeFreezeBalance(json);
      // changeBalance(json);
      getMessage(json);
    }
  }

  void getMessage(dynamic json) async {
    try {
      var message;
      if (json["type"] == "pub")
        message = MessageModel.fromJson(json["message"]["data"]);
      else
        message = MessageModel.fromJson(json["payload"]["result"]);

      ConversationRepository().addedMsg(message);
      print("chatMessage: ${message.toJson()}");
    } catch (e) {
      print("WebSocket message ERROR: ${e.toString()}");
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String text,
    required List<String> medias,
  }) async {
    Object payload = {
      "type": "request",
      "id": "$_counter",
      "method": "POST",
      "path": "/api/v1/chat/$chatId/send-message",
      "payload": {
        "text": "$text",
        "medias": [],
      }
    };
    String textPayload = json.encode(payload).toString();
    _channel.sink.add(textPayload);
    print("Send Message: $textPayload");
    // ConversationRepository().sendMsg(message)
    _counter++;
  }

  void _onData(message) {
    print("WebSocket message: $message");
    final json = jsonDecode(message.toString());
    switch (json["type"]) {
      case "pub":
        _handleSubscription(json);
        break;
      case "ping":
        _ping();
        break;
      case "request":
        getMessage(json);
        break;
    }
  }

  void _ping() {
    Object payload = {
      "type": "ping",
      "id": "$_counter",
    };
    String textPayload = json.encode(payload).toString();
    _channel.sink.add(textPayload);
    _counter++;
  }

  void _onError(error) {
    print("WebSocket error: $error");
  }

  void _onDone() {
    if (shouldReconnectFlag) connect();
    print("WebSocket onDone ${_channel.closeReason}");
  }

  WebSocket._internal();
}
