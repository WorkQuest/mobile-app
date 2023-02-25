import 'dart:math';
import 'package:app/model/web3/transactions_response.dart';
import 'package:app/ui/pages/main_page/wallet_page/store/wallet_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/transactions/store/transactions_store.dart';
import 'package:app/ui/widgets/shimmer.dart';
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
          return SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return const _ShimmerTransactionItem();
              },
              childCount: 8,
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
                  return Column(
                    children: const [
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator.adaptive(),
                    ],
                  );
                }
                return TransactionItem(
                  transaction: store.transactions[index],
                  titleCoin: _getTitleCoin(),
                  opacity: !store.transactions[index].show,
                );
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

class TransactionItem extends StatefulWidget {
  final Tx transaction;
  final String titleCoin;
  final bool opacity;

  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.titleCoin,
    this.opacity = false,
  }) : super(key: key);

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350), value: 0.15);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.opacity) {
      _animationController.forward();
    }
    widget.transaction.show = true;
    bool increase =
        widget.transaction.fromAddressHash!.hex! != AccountRepository().userAddress;
    Color color = increase ? Colors.green : Colors.red;
    double score;
    if (widget.transaction.tokenTransfers != null &&
        widget.transaction.tokenTransfers!.isEmpty) {
      score = BigInt.parse(widget.transaction.value!).toDouble() * pow(10, -18);
    } else {
      if (widget.transaction.amount != null) {
        score = BigInt.parse(widget.transaction.amount!).toDouble() * pow(10, -18);
      } else {
        score =
            BigInt.parse(widget.transaction.tokenTransfers!.first.amount!).toDouble() *
                pow(10, -18);
      }
    }
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          filterQuality: FilterQuality.low,
          offset: Offset(
              widget.opacity ? (50 - (50 * _animationController.value - 0.001)) : 0.0,
              0.0),
          child: AnimatedOpacity(
              opacity: widget.opacity ? _animationController.value : 1.0,
              duration: const Duration(milliseconds: 450),
              child: child!),
        );
      },
      child: Padding(
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
                  'assets/send_tx_arrow_icon.svg',
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
                      .format(widget.transaction.amount != null
                      ? widget.transaction.insertedAt!.toLocal()
                      : widget.transaction.block!.timestamp!.toLocal())
                      .toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColor.unselectedBottomIcon,
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            const Spacer(),
            Flexible(
              child: Text(
                '${increase ? '+' : '-'}${score.toStringAsFixed(5)} ${widget.titleCoin}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
                overflow: TextOverflow.clip,
                textAlign: TextAlign.end,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ShimmerTransactionItem extends StatelessWidget {
  const _ShimmerTransactionItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Shimmer.stand(
            child: Container(
              height: 34,
              width: 34,
              padding: const EdgeInsets.all(10.0),
              decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.stand(
                child: Container(
                  height: 20,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0), color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Shimmer.stand(
                child: Container(
                  height: 14,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0), color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          const Spacer(),
          Flexible(
            child: Shimmer.stand(
              child: Container(
                height: 20,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0), color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
