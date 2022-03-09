import 'dart:math';
import 'package:app/model/web3/transactions_response.dart';
import 'package:app/ui/pages/main_page/wallet_page/store/wallet_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/transactions/store/transactions_store.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import '../../../../../constants.dart';

class ListTransactions extends StatelessWidget {
  const ListTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I.get<TransactionsStore>();
    return Observer(
      builder: (_) {
        if (store.isLoading) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }
        if (store.isSuccess) {
          if (store.transactions.isEmpty) {
            return const SliverFillRemaining(
              child: Center(
                child: Text(
                  'No transactions',
                  // style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            );
          }
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (store.isMoreLoading && index == store.transactions.length) {
                  return SizedBox(
                    height: 30,
                    child: Center(child: CircularProgressIndicator.adaptive()),
                  );
                }
                if (store.type == TYPE_COINS.WUSD &&
                    store.transactions[index].value == "0") {
                  return Container();
                }
                return _infoElement(store.transactions[index]);
              },
              childCount: store.isMoreLoading
                  ? store.transactions.length + 1
                  : store.transactions.length,
            ),
          );
        }
        return  SliverFillRemaining(
          child: Center(
            child: Text(store.errorMessage!),
          ),
        );
      },
    );
  }

  Widget _infoElement(Tx transaction) {
    bool increase = transaction.fromAddressHash!.hex != AccountRepository().userAddress;
    Color color = increase ? Colors.green : Colors.red;
    double score;
    if (transaction.tokenTransfers != null && transaction.tokenTransfers!.isEmpty) {
      score = BigInt.parse(transaction.value!).toDouble() * pow(10, -18);
    } else {
      if (transaction.amount != null) {
        score = BigInt.parse(transaction.amount!).toDouble() *
            pow(10, -18);
      } else {
        score = BigInt.parse(transaction.tokenTransfers!.first.amount!).toDouble() *
            pow(10, -18);
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 34,
            width: 34,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Transform.rotate(
              angle: increase ? 0 : pi / 1,
              child: SvgPicture.asset(
                "assets/send_tx_arrow_icon.svg",
                color: color,
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                increase ? 'wallet.receive'.tr() : 'wallet.send'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                DateFormat('dd.MM.yy HH:mm')
                    .format(transaction.amount != null ? transaction.insertedAt!.toLocal() : transaction.block!.timestamp!.toLocal())
                    .toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColor.unselectedBottomIcon,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20,),
          Expanded(
            child: Text(
              '${increase ? '+' : '-'}${score.toStringAsFixed(5)} ${_getTitleCoin()}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              //\overflow: TextOverflow.clip,
              textAlign: TextAlign.end,
            ),
          )
        ],
      ),
    );
  }

  String _getTitleCoin() {
    switch (GetIt.I.get<WalletStore>().type) {
      case TYPE_COINS.WQT:
        return "WQT";
      case TYPE_COINS.WUSD:
        return "WUSD";
      case TYPE_COINS.wBNB:
        return "wBNB";
      case TYPE_COINS.wETH:
        return "wETH";
      default:
        return "WUSD";
    }
  }
}

class ItemTransaction {
  final DateTime date;
  final String title;
  final int count;

  const ItemTransaction(
    this.date,
    this.title,
    this.count,
  );
}
