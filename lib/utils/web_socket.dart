import 'dart:convert';
import 'dart:developer';
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
  int _senderCounter = 0;
  int _notifyCounter = 0;
  int closeCode = 4001;
  bool shouldReconnectFlag = true;
  void Function(dynamic)? handlerChats;
  void Function(dynamic)? handlerMessages;
  void Function(dynamic)? handlerQuests;
  void Function(dynamic)? handlerQuestList;
  IOWebSocketChannel? walletChannel;
  IOWebSocketChannel? _senderChannel;
  IOWebSocketChannel? _notificationChannel;

  factory WebSocket() {
    return _singleton;
  }

  void connect() async {
    shouldReconnectFlag = true;
    token = await Storage.readAccessToken();
    print("[WebSocket]  connecting ...");
    _connectWallet();
    _connectListen();

    _connectSender();
  }

  void _connectWallet() {
    walletChannel = IOWebSocketChannel.connect(
      "${AccountRepository().getConfigNetwork().wss}/tendermint-rpc/websocket",
    );
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

  _closeWalletSocket() {
    if (walletChannel != null) {
      walletChannel!.sink.close();
    }
  }

  reconnectWalletSocket() {
    _closeWalletSocket();
  }

  void _connectSender() {
    _senderChannel =
        IOWebSocketChannel.connect("wss://dev-app.workquest.co/api");
    _senderChannel?.sink.add("""{
          "type": "hello",
          "id": 1,
          "version": "2",
          "auth": {
            "headers": {"authorization": "Bearer $token"}
          }
        }""");

    _senderChannel?.stream.listen(
      (message) => _onData(message, _senderChannel!, "sender"),
      onError: _onError,
      onDone: () => _onDone(_senderChannel!, false),
    );
  }

  void _connectListen() {
    _notificationChannel =
        IOWebSocketChannel.connect("wss://notifications.workquest.co/api/v1/notifications");

    _notificationChannel?.sink.add("""{
          "type": "hello",
          "id": 1,
          "version": "2",
          "auth": {
            "headers": {"authorization": "Bearer $token"}
          },
          "subs": ["/notifications/chat","/notifications/quest"]
        }""");

    _notificationChannel?.stream.listen(
      (message) => _onData(message, _notificationChannel!, "notify"),
      onError: _onError,
      onDone: () => _onDone(_notificationChannel!, true),
    );
  }

  void _onData(message, IOWebSocketChannel channel, String type) {
    try {
      log("WebSocket message: $type $message");
      final json = jsonDecode(message.toString());
      switch (json["type"]) {
        case "pub":
          _handleSubscription(json);
          break;
        case "ping":
          _ping(channel, type == "sender" ? _senderCounter : _notifyCounter);
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
      if (json["path"] == "/notifications/quest")
        questNotification(json["message"]);
      getMessage(json);
    } catch (e, trace) {
      print("ERROR: $e \n $trace");
    }
  }

  void getMessage(dynamic json) async {
    try {
      if (handlerChats != null) handlerChats!(json);
      if (handlerMessages != null) handlerMessages!(json);
    } catch (e, trace) {
      print("WebSocket message ERROR: $e \n $trace");
    }
  }

  void questNotification(dynamic json) async {
    try {
      if (handlerQuests != null) handlerQuests!(json);
      if (handlerQuestList != null) handlerQuestList!(json);
    } catch (e, trace) {
      print("WebSocket message ERROR: $e \n $trace");
    }
  }

  Future<void> sendMessage({
    required String chatId,
    required String text,
    required List<String> medias,
    required String entity,
  }) async {
    Object payload = {
      "type": "request",
      "id": "$_senderCounter",
      "method": "POST",
      "path": "/api/v1/$entity/$chatId/send-message",
      "payload": {
        "text": "$text",
        "mediaIds": medias,
      }
    };
    String textPayload = json.encode(payload).toString();
    _senderChannel?.sink.add(textPayload);
    print("Send Message: $textPayload");
    ++_senderCounter;
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
    log("WebSocket error: $error");
  }

  void _onDone(IOWebSocketChannel channel, bool connectNotify) {
    print("WebSocket onDone ${channel.closeReason}");
    if (shouldReconnectFlag)
      connectNotify ? _connectSender() : _connectListen();
  }

  String get myAddress => AccountRepository().userAddress;

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
    } catch (e) {
      // print('web socket e - $e\ntrace - $trace');
    }
  }

  WebSocket._internal();
}
