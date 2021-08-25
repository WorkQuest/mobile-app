import 'dart:convert';
import 'package:app/utils/storage.dart';
import 'package:web_socket_channel/io.dart';

class WebSocket {
  static final WebSocket _singleton = WebSocket._internal();

  Function(Map<String, dynamic> message)? _messageHandler;

  setListener(Function(Map<String, dynamic> message)? messageHandler) {
    this._messageHandler = messageHandler;
  }

  late IOWebSocketChannel _channel;
  String _url = "wss://app-ver1.workquest.co/api";
  int _counter = 0;
  factory WebSocket() {
    return _singleton;
  }

  void connect() async {
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

  void _onData(message) {
    final json = jsonDecode(message.toString());
    switch (json["type"]) {
      case "hello":
        break;
      case "pub":
        if (this._messageHandler != null) this._messageHandler!(json);
        break;
      case "ping":
        this._channel.sink.add('{"type":"ping","id":$_counter}');
        _counter++;
        break;
      default:
        print("[WebSocket] onData  default $message");
        break;
    }
  }

  void _onError(error) {
    print("[WebSocket] onError $error");
  }

  void _onDone() {
    print("[WebSocket] Close chanel!!");
  }

  WebSocket._internal();
}
