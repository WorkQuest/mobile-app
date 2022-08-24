import 'dart:convert';
import 'dart:developer';
import 'package:app/constants.dart';
import 'package:app/model/web3/TrxEthereumResponse.dart';
import 'package:app/model/web3/transactions_response.dart';
import 'package:app/ui/pages/main_page/wallet_page/store/wallet_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/transactions/store/transactions_store.dart';
import 'package:app/utils/storage.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:app/web3/service/address_service.dart';
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

  String? currentWss;

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
    currentWss = AccountRepository().getConfigNetworkWorknet().wss;
    walletChannel = IOWebSocketChannel.connect(currentWss!);
    walletChannel =
        IOWebSocketChannel.connect(AccountRepository().getConfigNetwork().wss);
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

  void closeWebSocket() {
    print('closeWebSocket');
    shouldReconnectFlag = false;
    walletChannel?.sink.close(closeCode, "closeCode");
    _senderChannel?.sink.close(closeCode, "closeCode");
    _notificationChannel?.sink.close(closeCode, "closeCode");
  }

  _closeWalletSocket() {
    if (walletChannel != null) {
      walletChannel!.sink.close();
    }
  }

  reconnectWalletSocket() {
    if (currentWss == AccountRepository().getConfigNetworkWorknet().wss) {
      return;
    }
    _closeWalletSocket();
  }

  void _connectSender() {
    final _wssPath =
        AccountRepository().notifierNetwork.value == Network.testnet
            ? Constants.isTestnet
                ? "wss://testnet-app.workquest.co/api"
                : "wss://dev-app.workquest.co/api"
            : "wss://app.workquest.co/api";
    _senderChannel = IOWebSocketChannel.connect(_wssPath);
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
    final _wsPath = AccountRepository().notifierNetwork.value == Network.testnet
        ? Constants.isTestnet
            ? 'wss://testnet-notification.workquest.co/api/v1/notifications'
            : 'wss://notifications.workquest.co/api/v1/notifications'
        : 'wss://mainnet-notification.workquest.co/api/v1/notifications';
    _notificationChannel = IOWebSocketChannel.connect(_wsPath);

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
        questNotification(json);
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
      final needUpdate = json['action'] != 'userLeftReviewAboutQuest';
      if (!needUpdate) return;
      if (handlerQuests != null) handlerQuests!(json["message"]);
      if (handlerQuestList != null) handlerQuestList!(json["message"]);
      if (handlerChats != null) handlerChats!(json);
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
    try {
      final transaction = TrxEthereumResponse.fromJson(jsonResponse);
      final _events = transaction.result?.events;
      final _recipient = _events?['ethereum_tx.recipient']?[0];
      late String? _sender;
      try {
        _sender = _events?['message.sender']?[3].toString().toLowerCase();
      } catch (e) {
        _sender = _events?['message.sender']?[2].toString().toLowerCase();
      }
      final _txHash =
          _events?['ethereum_tx.ethereumTxHash']?[0]?.toString().toLowerCase();
      final _blockNumber = _events?['tx.height']?[0];
      final _block = DateTime.now();
      final _value = _events?['ethereum_tx.amount']?[0];
      final _transactionFee =
          _events?['tx.fee']?[0].toString().split('a').first;

      if (_recipient.toString().toLowerCase() == myAddress.toLowerCase()) {
        if (double.parse(_value) == 0.0) {
          await Future.delayed(const Duration(seconds: 9));
          print('getCoins 1');
          GetIt.I.get<WalletStore>().getCoins(isForce: false);
          GetIt.I.get<TransactionsStore>().getTransactions();
        } else {
          final _tx = Tx(
            hash: _txHash,
            fromAddressHash: AddressHash(
              bech32: AddressService.hexToBech32(_sender!),
              hex: _sender,
            ),
            toAddressHash: AddressHash(
              bech32: AddressService.hexToBech32(_recipient),
              hex: _recipient,
            ),
            amount: _value,
            blockNumber: int.parse(_blockNumber),
            gasUsed: _transactionFee,
            insertedAt: _block,
            block: Block(timestamp: _block),
          );
          GetIt.I.get<TransactionsStore>().addTransaction(_tx);
          print('getCoins 2');
          GetIt.I.get<WalletStore>().getCoins(isForce: false);
        }
      } else {
        final _txLog = json.decode(transaction
            .result!.events!['tx_log.txLog']![0]
            .toString()
            .replaceAll('\\', ""));
        final _address = _txLog['topics'][2].toString().split('x').first +
            'x' +
            _txLog['topics'][2].toString().split('x').last.substring(24);
        if (_address.toLowerCase() == myAddress) {
          await Future.delayed(const Duration(seconds: 9));
          print('getCoins 3');
          GetIt.I.get<WalletStore>().getCoins(isForce: false);
          GetIt.I.get<TransactionsStore>().getTransactions();
        }
      }
    } catch (e) {
      // print('web socket e - $e\ntrace - $trace');
    }
  }

  WebSocket._internal();
}
