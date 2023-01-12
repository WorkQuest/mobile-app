// To parse this JSON data, do
//
//     final trxEthereumResponse = trxEthereumResponseFromJson(jsonString);

import 'dart:convert' as con;

TrxEthereumResponse trxEthereumResponseFromJson(String str) =>
    TrxEthereumResponse.fromJson(con.json.decode(str));

String trxEthereumResponseToJson(TrxEthereumResponse data) =>
    con.json.encode(data.toJson());

class TrxEthereumResponse {
  TrxEthereumResponse({
    this.jsonrpc,
    this.id,
    this.result,
  });

  String? jsonrpc;
  int? id;
  TrxEthereumResponseResult? result;

  factory TrxEthereumResponse.fromJson(Map<String, dynamic> json) => TrxEthereumResponse(
        jsonrpc: json["jsonrpc"],
        id: json["id"],
        result: json["result"] == null
            ? null
            : TrxEthereumResponseResult.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "jsonrpc": jsonrpc,
        "id": id,
        "result": result == null ? null : result!.toJson(),
      };
}

class TrxEthereumResponseResult {
  TrxEthereumResponseResult({
    this.query,
    this.data,
    this.events,
  });

  String? query;
  TrxData? data;
  Map<String, List<dynamic>>? events;

  factory TrxEthereumResponseResult.fromJson(Map<String, dynamic> json) {
    return TrxEthereumResponseResult(
      query: json["query"],
      data: json["data"] == null ? null : TrxData.fromJson(json["data"]),
      events: json["events"] == null
          ? null
          : Map.from(json["events"]).map((k, v) =>
              MapEntry<String, List<dynamic>>(k, List<dynamic>.from(v.map((x) => x)))),
    );
  }

  Map<String, dynamic> toJson() => {
        "query": query,
        "data": data == null ? null : data!.toJson(),
        "events": events == null
            ? null
            : Map.from(events!).map((k, v) =>
                MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x)))),
      };
}

class TrxData {
  TrxData({
    this.type,
    this.value,
  });

  String? type;
  Value? value;

  factory TrxData.fromJson(Map<String, dynamic> json) => TrxData(
        type: json["type"],
        value: json["value"] == null ? null : Value.fromJson(json["value"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "value": value == null ? null : value!.toJson(),
      };
}

class Value {
  Value({
    this.txResult,
  });

  TxResult? txResult;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        txResult: json["TxResult"] == null ? null : TxResult.fromJson(json["TxResult"]),
      );

  Map<String, dynamic> toJson() => {
        "TxResult": txResult == null ? null : txResult!.toJson(),
      };
}

class TxResult {
  TxResult({
    this.height,
    this.tx,
    this.result,
  });

  String? height;
  String? tx;
  TxResultResult? result;

  factory TxResult.fromJson(Map<String, dynamic> json) => TxResult(
        height: json["height"],
        tx: json["tx"],
        result: json["result"] == null ? null : TxResultResult.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "tx": tx,
        "result": result == null ? null : result!.toJson(),
      };
}

class TxResultResult {
  TxResultResult({
    this.data,
    // this.log,
    this.gasUsed,
    // this.events,
  });

  String? data;
  // List<Logs>? log;
  String? gasUsed;
  // List<Event>? events;

  factory TxResultResult.fromJson(Map<String, dynamic> json) {
    try {
      return TxResultResult(
        data: json["data"],
        // log: json["log"] == null
        //     ? null
        //     : List<Logs>.from(json["log"].map((x) => Logs.fromJson(x))),
        gasUsed: json["gas_used"],
        // events: json["events"] == null
        //     ? null
        //     : List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
      );
    } catch (e, trace) {
      print('TxResultResult e - $e\ntrace - $trace');
      return TxResultResult();
    }
  }

  Map<String, dynamic> toJson() => {
        "data": data,
        // "log": log,
        "gas_used": gasUsed,
        // "events":
        //     events == null ? null : List<dynamic>.from(events!.map((x) => x.toJson())),
      };
}

class Event {
  Event({
    this.type,
    this.attributes,
  });

  String? type;
  List<Attribute>? attributes;

  factory Event.fromJson(Map<String, dynamic> json) {
    try {
      return Event(
        type: json["type"],
        attributes: json["attributes"] == null
            ? null
            : List<Attribute>.from(json["attributes"].map((x) => Attribute.fromJson(x))),
      );
    } catch (e,trace) {
      print('Event e - $e\ntrace - $trace');
      return Event();
    }
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "attributes": attributes == null
            ? null
            : List<dynamic>.from(attributes!.map((x) => x.toJson())),
      };
}

class Attribute {
  Attribute({
    this.key,
    this.value,
    this.index,
  });

  String? key;
  String? value;
  bool? index;

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        key: json["key"],
        value: json["value"],
        index: json["index"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "index": index,
      };
}

class Logs {
  List<String>? coinReceivedReceiver;
  List<String>? coinReceivedAmount;
  List<String>? messageSender;
  List<String>? coinbaseAmount;
  List<String>? ethereumTxEthereumTxHash;
  List<String>? ethereumTxTxHash;
  List<String>? txHash;
  List<String>? coinSpentSpender;
  List<String>? transferRecipient;
  List<String>? transferSender;
  List<String>? txFee;
  List<String>? burnAmount;
  List<String>? ethereumTxAmount;
  List<String>? messageModule;
  List<String>? tmEvent;
  List<String>? txHeight;
  List<String>? messageAction;
  List<String>? burnBurner;
  List<String>? coinbaseMinter;
  List<String>? coinSpentAmount;
  List<String>? transferAmount;
  List<String>? ethereumTxRecipient;
  List<String>? messageTxType;

  Logs(
      {this.coinReceivedReceiver,
      this.coinReceivedAmount,
      this.messageSender,
      this.coinbaseAmount,
      this.ethereumTxEthereumTxHash,
      this.ethereumTxTxHash,
      this.txHash,
      this.coinSpentSpender,
      this.transferRecipient,
      this.transferSender,
      this.txFee,
      this.burnAmount,
      this.ethereumTxAmount,
      this.messageModule,
      this.tmEvent,
      this.txHeight,
      this.messageAction,
      this.burnBurner,
      this.coinbaseMinter,
      this.coinSpentAmount,
      this.transferAmount,
      this.ethereumTxRecipient,
      this.messageTxType});

  Logs.fromJson(Map<String, dynamic> json) {
    coinReceivedReceiver = json['coin_received.receiver'].cast<String>();
    coinReceivedAmount = json['coin_received.amount'].cast<String>();
    messageSender = json['message.sender'].cast<String>();
    coinbaseAmount = json['coinbase.amount'].cast<String>();
    ethereumTxEthereumTxHash = json['ethereum_tx.ethereumTxHash'].cast<String>();
    ethereumTxTxHash = json['ethereum_tx.txHash'].cast<String>();
    txHash = json['tx.hash'].cast<String>();
    coinSpentSpender = json['coin_spent.spender'].cast<String>();
    transferRecipient = json['transfer.recipient'].cast<String>();
    transferSender = json['transfer.sender'].cast<String>();
    txFee = json['tx.fee'].cast<String>();
    burnAmount = json['burn.amount'].cast<String>();
    ethereumTxAmount = json['ethereum_tx.amount'].cast<String>();
    messageModule = json['message.module'].cast<String>();
    tmEvent = json['tm.event'].cast<String>();
    txHeight = json['tx.height'].cast<String>();
    messageAction = json['message.action'].cast<String>();
    burnBurner = json['burn.burner'].cast<String>();
    coinbaseMinter = json['coinbase.minter'].cast<String>();
    coinSpentAmount = json['coin_spent.amount'].cast<String>();
    transferAmount = json['transfer.amount'].cast<String>();
    ethereumTxRecipient = json['ethereum_tx.recipient'].cast<String>();
    messageTxType = json['message.txType'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coin_received.receiver'] = coinReceivedReceiver;
    data['coin_received.amount'] = coinReceivedAmount;
    data['message.sender'] = messageSender;
    data['coinbase.amount'] = coinbaseAmount;
    data['ethereum_tx.ethereumTxHash'] = ethereumTxEthereumTxHash;
    data['ethereum_tx.txHash'] = ethereumTxTxHash;
    data['tx.hash'] = txHash;
    data['coin_spent.spender'] = coinSpentSpender;
    data['transfer.recipient'] = transferRecipient;
    data['transfer.sender'] = transferSender;
    data['tx.fee'] = txFee;
    data['burn.amount'] = burnAmount;
    data['ethereum_tx.amount'] = ethereumTxAmount;
    data['message.module'] = messageModule;
    data['tm.event'] = tmEvent;
    data['tx.height'] = txHeight;
    data['message.action'] = messageAction;
    data['burn.burner'] = burnBurner;
    data['coinbase.minter'] = coinbaseMinter;
    data['coin_spent.amount'] = coinSpentAmount;
    data['transfer.amount'] = transferAmount;
    data['ethereum_tx.recipient'] = ethereumTxRecipient;
    data['message.txType'] = messageTxType;
    return data;
  }
}
