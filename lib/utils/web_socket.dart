import 'dart:convert';
import 'package:app/utils/storage.dart';
import 'package:web_socket_channel/io.dart';

class WebSocket {
  static final WebSocket _singleton = WebSocket._internal();

  void Function(dynamic)? handlerChats;
  void Function(dynamic)? handlerQuests;

  late IOWebSocketChannel _channelListener;
  late List<IOWebSocketChannel> _channels = [];
  late IOWebSocketChannel _channelSender;

  final String _urlSender = "wss://app.workquest.co/api";
  final String _urlListener =
      "wss://notifications.workquest.co/api/v1/notifications";

  int _counter = 0;

  bool shouldReconnectFlag = true;

  int closeCode = 4001;

  factory WebSocket() {
    return _singleton;
  }

  void getChannels() {
    List<String> _url = [_urlListener, _urlSender];
    _channels = _url.map((url) => IOWebSocketChannel.connect(url)).toList();
  }

  void connect() async {
    shouldReconnectFlag = true;
    _counter = 0;
    String? token = await Storage.readAccessToken();
    print("[WebSocket]  connecting ...");
    //getChannels();
    this._channelListener = IOWebSocketChannel.connect(_urlListener);
    this._channelSender = IOWebSocketChannel.connect(_urlSender);

    // this._channels.forEach((element) {
    //   element.sink.add("""{
    //       "type": "hello",
    //       "id": 1,
    //       "version": "2",
    //       "auth": {
    //         "headers": {"authorization": "Bearer $token"}
    //       },
    //       "sub": element"/notifications/chat"
    //     }""");
    // });
    //
    // this._channels.forEach((element) {
    //   element.stream.listen(
    //     this._onData,
    //     onError: this._onError,
    //     onDone: this._onDone,
    //   );
    // });

    this._channelSender.sink.add("""{
          "type": "hello",
          "id": 1,
          "version": "2",
          "auth": {
            "headers": {"authorization": "Bearer $token"}
          },
          "sub": "/notifications/chat"
        }""");

    this._channelListener.sink.add("""{
          "type": "hello",
          "id": 1,
          "version": "2",
          "auth": {
            "headers": {"authorization": "Bearer $token"}
          },
          "sub": "/notifications/chat"
        }""");

    this._channelListener.stream.listen(
          this._onData,
          onError: this._onError,
          onDone: this._onDone,
        );

    this._channelSender.stream.listen(
          this._onData,
          onError: this._onError,
          onDone: this._onDone,
        );
  }

  void _onData(message) {
    try {
      print("WebSocket message: $message");
      final json = jsonDecode(message.toString());
      switch (json["type"]) {
        case "pub":
          print("pub_object");
          _handleSubscription(json);
          break;
        case "ping":
          _ping();
          break;
        case "request":
          getMessage(json);
          break;
      }
    } catch (e, tr) {
      print(e);
      print(tr);
    }
  }

  void _handleSubscription(dynamic json) async {
    try {
      if (json["path"].toString().contains("/api/v1/chat/")) {
        getMessage(json);
      } else if (json["path"] == "/notifications/quest") {
        questNotification(json["message"]["data"]);
      } else if (json["path"] == "/notifications/chat") {
        print("new${json["message"]["data"]}");
        //questNotification(json["message"]["data"]);
      }
    } catch (e, trace) {
      print("ERROR: $e");
      print("ERROR: $trace");
    }
  }

  void getMessage(dynamic json) async {
    try {
      if (handlerChats != null) handlerChats!(json);
      print("chatMessage: ${json.toString()}");
    } catch (e, trace) {
      print("WebSocket message ERROR: $e");
      print("WebSocket message ERROR: $trace");
    }
  }

  void questNotification(dynamic json) async {
    try {
      if (handlerQuests != null) handlerQuests!(json);
      print("questMessage: ${json.toString()}");
    } catch (e, trace) {
      print("WebSocket message ERROR: $e");
      print("WebSocket message ERROR: $trace");
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
        "medias": medias,
      }
    };
    String textPayload = json.encode(payload).toString();
    _channelSender.sink.add(textPayload);
    //_channels[1].sink.add(textPayload);
    print("Send Message: $textPayload");
    _counter++;
  }

  void _ping() {
    Object payload = {
      "type": "ping",
      "id": "$_counter",
    };
    String textPayload = json.encode(payload).toString();
     _channelListener.sink.add(textPayload);
    _channelSender.sink.add(textPayload);
    _counter++;
  }

  void _onError(error) {
    print("WebSocket error: $error");
  }

  void _onDone() {
    if (shouldReconnectFlag) connect();
    print("WebSocket onDone ${_channelListener.closeReason}");
    _channels.forEach((element) {element.closeReason;});
    print("WebSocket onDone ${_channelSender.closeReason}");
  }

  WebSocket._internal();
}
