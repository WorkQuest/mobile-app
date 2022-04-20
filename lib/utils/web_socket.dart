import 'dart:convert';
import 'package:app/model/web3/TrxEthereumResponse.dart';
import 'package:app/ui/pages/main_page/wallet_page/store/wallet_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/transactions/store/transactions_store.dart';
import 'package:app/utils/storage.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/io.dart';

class WebSocket {
  static final WebSocket _singleton = WebSocket._internal();

  String? token;
  int _notifyCounter = 0;
  int closeCode = 4001;
  bool shouldReconnectFlag = true;
  void Function(dynamic)? handlerChats;
  void Function(dynamic)? handlerQuests;
  IOWebSocketChannel? walletChannel;
  IOWebSocketChannel? _notificationChannel;

  factory WebSocket() {
    return _singleton;
  }

  void connect() async {
    shouldReconnectFlag = true;
    token = await Storage.readAccessToken();
    print("[WebSocket]  connecting ...");
    _connectWallet();
    _connectNotification();
  }

  void _connectWallet() {
    walletChannel = IOWebSocketChannel.connect(
        "wss://dev-node-nyc3.workquest.co/tendermint-rpc/websocket");
    walletChannel!.sink.add("""
      {
          "jsonrpc": "2.0",
          "method": "subscribe",
          "id": 0,
          "params": {
              "query": "tm.event='Tx'"
          }
      }
      """);

    walletChannel!.stream.listen(
      (message) {
        var jsonResponse = jsonDecode(message);
        handleSubscription(jsonResponse);
      },
      onDone: () async {
        if (shouldReconnectFlag) {
          _connectWallet();
        }
        print("WebSocket onDone ${walletChannel!.closeReason}");
      },
      onError: (error) => print("Wallet WebSocket error: $error"),
    );
  }

  void _connectNotification() {
    _notificationChannel =
        IOWebSocketChannel.connect("wss://app-ver1.workquest.co/api");
    _notificationChannel!.sink.add("""{
          "type": "hello",
          "id": 1,
          "version": "2",
          "auth": {
            "headers": {"authorization": "Bearer $token"}
          },
          "subs": ["/notifications/chat", "/notifications/quest"]
        }""");

    _notificationChannel!.stream.listen(
      (message) => _onData(message, _notificationChannel!),
      onError: _onError,
      onDone: () => _onDone(_notificationChannel!, false),
    );
  }

  void _onData(message, IOWebSocketChannel channel) {
    try {
      print("WebSocket message: $message");
      final json = jsonDecode(message.toString());
      switch (json["type"]) {
        case "pub":
          _handleSubscription(json);
          break;
        case "ping":
          _ping(channel, _notifyCounter);
          break;
        case "request":
          getMessage(json);
          break;
        default:
          print("default $json");
      }
    } catch (e, tr) {
      print("$e $tr");
    }
  }

  void _handleSubscription(dynamic json) async {
    try {
      print("notification path: ${json["path"]}");
      if (json["path"] == "/notifications/quest") {
        questNotification(json["message"]);
      } else if (json["path"] == "/notifications/chat") {
        getMessage(json);
      } else
        print("new message");
    } catch (e, trace) {
      print("ERROR: $e \n $trace");
    }
  }

  void getMessage(dynamic json) async {
    try {
      if (handlerChats != null) handlerChats!(json);
      print("chatMessage: ${json.toString()}");
    } catch (e, trace) {
      print("WebSocket message ERROR: $e \n $trace");
    }
  }

  void questNotification(dynamic json) async {
    try {
      print("quest notification");
      print(json);
      if (handlerQuests != null) handlerQuests!(json);
      print("questMessage: ${json.toString()}");
    } catch (e, trace) {
      print("WebSocket message ERROR: $e \n $trace");
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String text,
    required List<String> medias,
  }) async {
    Object payload = {
      "type": "request",
      "id": "$_notifyCounter",
      "method": "POST",
      "path": "/api/v1/chat/$chatId/send-message",
      "payload": {
        "text": "$text",
        "medias": medias,
      }
    };
    String textPayload = json.encode(payload).toString();
    _notificationChannel?.sink.add(textPayload);
    print("Send Message: $textPayload");
    ++_notifyCounter;
  }

  void _ping(IOWebSocketChannel channel, counter) {
    Object payload = {
      "type": "ping",
      "id": "$counter",
    };
    String textPayload = json.encode(payload).toString();
    channel.sink.add(textPayload);
    ++counter;
  }

  void _onError(error) {
    print("WebSocket error: $error");
  }

  void _onDone(IOWebSocketChannel channel, bool connectNotify) {
    print("WebSocket onDone ${channel.closeReason}");
    if (shouldReconnectFlag) _connectNotification();
  }

  String get myAddress => AccountRepository().userAddress!;

  void handleSubscription(dynamic jsonResponse) async {
    print("wallet $jsonResponse");
    try {
      final transaction = TrxEthereumResponse.fromJson(jsonResponse);
      if (transaction.result?.events != null) {
        if (transaction.result!.events!['ethereum_tx.recipient']!.first
                .toString()
                .toLowerCase() ==
            myAddress.toLowerCase()) {
          await Future.delayed(const Duration(seconds: 8));
          GetIt.I.get<WalletStore>().getCoins(isForce: false);
          GetIt.I.get<TransactionsStore>().getTransactions(isForce: true);
        } else {
          final decode =
              json.decode(transaction.result!.events!['tx_log.txLog']!.first);
          if ((decode['topics'] as List<dynamic>).last.substring(26) ==
              myAddress.substring(2)) {
            await Future.delayed(const Duration(seconds: 8));
            GetIt.I.get<WalletStore>().getCoins(isForce: false);
            GetIt.I.get<TransactionsStore>().getTransactions(isForce: true);
          }
        }
      }
    } catch (e, trace) {
      // print('web socket e - $e\ntrace - $trace');
    }
  }

  WebSocket._internal();
}
