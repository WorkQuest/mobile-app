import 'package:app/web3/contractEnums.dart';
import 'package:intl/intl.dart';

class TransactionResponse {
  TransactionResponse({
    this.count,
    this.txs,
  });

  int? count;
  List<Tx>? txs;

  factory TransactionResponse.fromJson(Map<String, dynamic> json) => TransactionResponse(
        count: json["count"],
        txs: json["txs"] == null
            ? null
            : List<Tx>.from(json["txs"].map((x) => Tx.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "txs": txs == null
            ? null
            : List<dynamic>.from(txs!.map((x) => x.toJson())),
      };
}

class Tx {
  Tx({
    this.id,
    this.blockNumber,
    this.timestamp,
    this.fromAddress,
    this.toAddress,
    this.gasUsed,
    this.gasPrice,
    this.gasLimit,
    this.value,
    this.status,
    this.contractAddress,
    this.tokenId,
    this.logs,
    this.input,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  int? blockNumber;
  DateTime? timestamp;
  String? fromAddress;
  String? toAddress;
  String? gasUsed;
  String? gasPrice;
  dynamic gasLimit;
  String? value;
  int? status;
  dynamic contractAddress;
  dynamic tokenId;
  List<Logs>? logs;
  String? input;
  DateTime? createdAt;
  DateTime? updatedAt;
  TYPE_COINS? coin;

  String getDate() {
    return DateFormat("HH:mm").format(createdAt!.toLocal());
  }

  factory Tx.fromJson(Map<String, dynamic> json) => Tx(
        id: json["id"],
        blockNumber: json["blockNumber"],
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
        fromAddress: json["fromAddress"],
        toAddress: json["toAddress"],
        gasUsed: json["gasUsed"],
        gasPrice: json["gasPrice"],
        gasLimit: json["gasLimit"],
        value: json["value"],
        status: json["status"],
        contractAddress: json["contractAddress"],
        tokenId: json["tokenId"],
        logs: json["logs"] == null
            ? null
            : List<Logs>.from(json["logs"].map((x) => Logs.fromJson(x))),
        input: json["input"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "blockNumber": blockNumber,
        "timestamp": timestamp == null ? null : timestamp!.toIso8601String(),
        "fromAddress": fromAddress,
        "toAddress": toAddress,
        "gasUsed": gasUsed,
        "gasPrice": gasPrice,
        "gasLimit": gasLimit,
        "value": value,
        "status": status,
        "contractAddress": contractAddress,
        "tokenId": tokenId,
        "logs": logs == null ? null : List<dynamic>.from(logs!.map((x) => x)),
        "input": input,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "updatedAt": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}

class Logs {
  String? data;
  List<String>? topics;
  String? address;
  bool? removed;
  String? logIndex;
  String? blockHash;
  String? blockNumber;
  String? transactionHash;
  String? transactionIndex;

  Logs(
      {this.data,
        this.topics,
        this.address,
        this.removed,
        this.logIndex,
        this.blockHash,
        this.blockNumber,
        this.transactionHash,
        this.transactionIndex});

  Logs.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    topics = json['topics'].cast<String>();
    address = json['address'];
    removed = json['removed'];
    logIndex = json['logIndex'];
    blockHash = json['blockHash'];
    blockNumber = json['blockNumber'];
    transactionHash = json['transactionHash'];
    transactionIndex = json['transactionIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['topics'] = this.topics;
    data['address'] = this.address;
    data['removed'] = this.removed;
    data['logIndex'] = this.logIndex;
    data['blockHash'] = this.blockHash;
    data['blockNumber'] = this.blockNumber;
    data['transactionHash'] = this.transactionHash;
    data['transactionIndex'] = this.transactionIndex;
    return data;
  }
}
