import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/account_repository.dart';

import '../../constants.dart';

class TransactionsResponse {
  TransactionsResponse({
    this.count,
    this.txs,
  });

  int? count;
  List<Tx>? txs;

  factory TransactionsResponse.fromJson(Map<String, dynamic> json) =>
      TransactionsResponse(
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
    this.hash,
    this.input,
    this.blockHash,
    this.fromAddressHash,
    this.toAddressHash,
    this.createdContractAddressHash,
    this.oldBlockHash,
    this.cumulativeGasUsed,
    this.error,
    this.gas,
    this.gasPrice,
    this.gasUsed,
    this.index,
    this.nonce,
    this.r,
    this.s,
    this.status,
    this.v,
    this.value,
    this.amount,
    this.insertedAt,
    this.updatedAt,
    this.blockNumber,
    this.createdContractCodeIndexedAt,
    this.earliestProcessingStart,
    this.revertReason,
    this.maxPriorityFeePerGas,
    this.maxFeePerGas,
    this.type,
    this.coin,
  });

  String? hash;
  String? input;
  String? blockHash;
  AddressHash? fromAddressHash;
  AddressHash? toAddressHash;
  dynamic createdContractAddressHash;
  dynamic oldBlockHash;
  String? cumulativeGasUsed;
  dynamic error;
  String? gas;
  String? gasPrice;
  String? gasUsed;
  int? index;
  int? nonce;
  String? r;
  String? s;
  int? status;
  String? v;
  String? value;
  String? amount;
  DateTime? insertedAt;
  DateTime? updatedAt;
  int? blockNumber;
  dynamic createdContractCodeIndexedAt;
  dynamic earliestProcessingStart;
  dynamic revertReason;
  dynamic maxPriorityFeePerGas;
  dynamic maxFeePerGas;
  int? type;
  TYPE_COINS? coin;

  factory Tx.fromJson(Map<String, dynamic> json) => Tx(
        hash: json["hash"],
        input: json["input"],
        blockHash: json["block_hash"],
        fromAddressHash: json["from_address_hash"] == null
            ? null
            : AddressHash.fromJson(json["from_address_hash"]),
        toAddressHash: json["to_address_hash"] == null
            ? null
            : AddressHash.fromJson(json["to_address_hash"]),
        createdContractAddressHash: json["created_contract_address_hash"],
        oldBlockHash: json["old_block_hash"],
        cumulativeGasUsed: json["cumulative_gas_used"],
        error: json["error"],
        gas: json["gas"],
        gasPrice: json["gas_price"],
        gasUsed: json["gas_used"],
        index: json["index"],
        nonce: json["nonce"],
        r: json["r"],
        s: json["s"],
        status: json["status"],
        v: json["v"],
        value: json["value"],
        amount: json["amount"],
        insertedAt: json["inserted_at"] == null
            ? null
            : DateTime.parse(json["inserted_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        blockNumber: json["block_number"],
        createdContractCodeIndexedAt: json["created_contract_code_indexed_at"],
        earliestProcessingStart: json["earliest_processing_start"],
        revertReason: json["revert_reason"],
        maxPriorityFeePerGas: json["max_priority_fee_per_gas"],
        maxFeePerGas: json["max_fee_per_gas"],
        type: json["type"],
        coin: getCoin(
            json["to_address_hash"]["hex"], json["from_address_hash"]["hex"]),
      );

  Map<String, dynamic> toJson() => {
        "hash": hash,
        "input": input,
        "block_hash": blockHash,
        "from_address_hash":
            fromAddressHash == null ? null : fromAddressHash!.toJson(),
        "to_address_hash":
            toAddressHash == null ? null : toAddressHash!.toJson(),
        "created_contract_address_hash": createdContractAddressHash,
        "old_block_hash": oldBlockHash,
        "cumulative_gas_used": cumulativeGasUsed,
        "error": error,
        "gas": gas,
        "gas_price": gasPrice,
        "gas_used": gasUsed,
        "index": index,
        "nonce": nonce,
        "r": r,
        "s": s,
        "status": status,
        "v": v,
        "value": value,
        "amount": amount,
        "inserted_at":
            insertedAt == null ? null : insertedAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "block_number": blockNumber,
        "created_contract_code_indexed_at": createdContractCodeIndexedAt,
        "earliest_processing_start": earliestProcessingStart,
        "revert_reason": revertReason,
        "max_priority_fee_per_gas": maxPriorityFeePerGas,
        "max_fee_per_gas": maxFeePerGas,
        "type": type,
      };

  static TYPE_COINS getCoin(String toAddressHex, String fromAddressHex) {
    if (toAddressHex == AccountRepository().userAddress) {
      switch (fromAddressHex) {
        case AddressCoins.wqt:
          return TYPE_COINS.WQT;
        case AddressCoins.wEth:
          return TYPE_COINS.wETH;
        case AddressCoins.wBnb:
          return TYPE_COINS.wBNB;
        default:
          return TYPE_COINS.WUSD;
      }
    } else {
      switch (toAddressHex) {
        case AddressCoins.wqt:
          return TYPE_COINS.WQT;
        case AddressCoins.wEth:
          return TYPE_COINS.wETH;
        case AddressCoins.wBnb:
          return TYPE_COINS.wBNB;
        default:
          return TYPE_COINS.WUSD;
      }
    }
  }
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
