import 'package:app/constants.dart';

class TransactionsResponse {
  TransactionsResponse({
    this.count,
    this.transactions,
  });

  int? count;
  List<Tx>? transactions;

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) =>
      TransactionsResponse(
        count: json["count"],
        transactions: json["transactions"] == null
            ? null
            : List<Tx>.from(json["transactions"].map((x) => Tx.fromJson(x))),
      );

  factory TransactionsResponse.fromJsonToken(Map<String, dynamic> json) =>
      TransactionsResponse(
        count: json["count"],
        transactions: json["txs"] == null
            ? null
            : List<Tx>.from(json["txs"].map((x) => Tx.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "transactions": transactions == null
            ? null
            : List<dynamic>.from(transactions!.map((x) => x.toJson())),
      };
}

class Tx {
  Tx({
    this.hash,
    this.fromAddressHash,
    this.toAddressHash,
    this.tokenContractAddressHash,
    this.gas,
    this.error,
    this.value,
    this.amount,
    this.gasUsed,
    this.gasPrice,
    this.blockNumber,
    this.insertedAt,
    this.block,
    this.tokenTransfers,
    this.coin,
  });

  String? hash;
  AddressHash? fromAddressHash;
  AddressHash? toAddressHash;
  AddressHash? tokenContractAddressHash;
  String? gas;
  dynamic error;
  String? value;
  String? amount;
  String? gasUsed;
  String? gasPrice;
  int? blockNumber;
  DateTime? insertedAt;
  Block? block;
  List<TokenTransfer>? tokenTransfers;
  TokenSymbols? coin;
  bool show = false;

  factory Tx.fromJson(Map<String, dynamic> json) => Tx(
        hash: json["hash"] ?? json["transaction_hash"],
        fromAddressHash: json["from_address_hash"] == null
            ? null
            : AddressHash.fromJson(json["from_address_hash"]),
        toAddressHash: json["to_address_hash"] == null
            ? null
            : AddressHash.fromJson(json["to_address_hash"]),
        tokenContractAddressHash: json["token_contract_address_hash"] == null
            ? null
            : AddressHash.fromJson(json["token_contract_address_hash"]),
        gas: json["gas"],
        error: json["error"],
        value: json["value"],
        amount: json["amount"],
        gasUsed: json["gas_used"],
        gasPrice: json["gas_price"],
        blockNumber: json["block_number"],
        insertedAt: json["inserted_at"] == null
            ? null
            : DateTime.parse(json["inserted_at"]),
        block: json["block"] == null ? null : Block.fromJson(json["block"]),
        tokenTransfers: json["tokenTransfers"] == null
            ? null
            : List<TokenTransfer>.from(
                json["tokenTransfers"].map((x) => TokenTransfer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "hash": hash,
        "from_address_hash": fromAddressHash,
        "to_address_hash": toAddressHash,
        "token_contract_address_hash": tokenContractAddressHash,
        "gas": gas,
        "error": error,
        "value": value,
        "amount": amount,
        "gas_used": gasUsed,
        "gas_price": gasPrice,
        "block_number": blockNumber,
        "inserted_at": insertedAt,
        "block": block,
        "tokenTransfers": tokenTransfers,
      };
}

class Block {
  Block({
    this.timestamp,
  });

  DateTime? timestamp;

  factory Block.fromJson(Map<String, dynamic> json) => Block(
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp,
      };
}

class AddressHash {
  AddressHash({
    this.hex,
    this.bech32,
  });

  String? hex;
  String? bech32;

  factory AddressHash.fromJson(Map<String, dynamic> json) => AddressHash(
        hex: json["hex"],
        bech32: json["bech32"],
      );

  Map<String, dynamic> toJson() => {
        "hex": hex,
        "bech32": bech32,
      };
}

class TokenTransfer {
  TokenTransfer({
    this.amount,
  });

  String? amount;

  factory TokenTransfer.fromJson(Map<String, dynamic> json) => TokenTransfer(
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
      };
}
