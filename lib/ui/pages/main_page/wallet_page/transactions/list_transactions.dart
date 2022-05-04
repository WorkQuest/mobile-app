import 'dart:math';

import 'package:app/ui/pages/main_page/wallet_page/transactions/store/transactions_store.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import '../../../../../constants.dart';
import '../../../../../model/web3/transactions_response.dart';
import '../../../../../web3/contractEnums.dart';
import '../../../../../web3/repository/account_repository.dart';
import '../../../../widgets/shimmer.dart';

class ListTransactions extends StatelessWidget {
  final ScrollController scrollController;

  const ListTransactions({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

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
            return SliverFillRemaining(
              child: Center(
                child: Text(
                  'wallet.noTransactions'.tr(),
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
                final increase =
                    store.transactions[index].fromAddressHash!.hex! !=
                        AccountRepository().userAddress;
                return TransactionItem(
                  transaction: store.transactions[index],
                  titleCoin: increase
                      ? _getTitleCoin(
                      store.transactions[index].fromAddressHash!.hex!)
                      : _getTitleCoin(
                      store.transactions[index].toAddressHash!.hex!),
                  opacity: !store.transactions[index].show,
                );
              },
              childCount: store.isMoreLoading
                  ? store.transactions.length + 1
                  : store.transactions.length,
            ),
          );
        }
        return SliverFillRemaining(
          child: Center(
            child: Text(store.errorMessage!),
          ),
        );
      },
    );
  }

  String _getTitleCoin(String? addressContract) {
    if (GetIt.I.get<TransactionsStore>().type == TYPE_COINS.WQT) {
      switch(addressContract) {
        case AddressCoins.wUsd:
          return "WUSD";
        case AddressCoins.wBnb:
          return "wBNB";
        case AddressCoins.wEth:
          return "wETH";
        default:
          return "WQT";
      }
    } else {
      switch (GetIt.I
          .get<TransactionsStore>()
          .type) {
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

class _TransactionItemState extends State<TransactionItem>
    with TickerProviderStateMixin {
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
    bool increase = widget.transaction.fromAddressHash!.hex! !=
        AccountRepository().userAddress;
    Color color = increase ? Colors.green : Colors.red;
    double score;
    if (widget.transaction.tokenTransfers != null &&
        widget.transaction.tokenTransfers!.isEmpty) {
      score = BigInt.parse(widget.transaction.value!).toDouble() * pow(10, -18);
    } else {
      if (widget.transaction.amount != null) {
        score =
            BigInt.parse(widget.transaction.amount!).toDouble() * pow(10, -18);
      } else {
        score = BigInt.parse(widget.transaction.tokenTransfers!.first.amount!)
            .toDouble() *
            pow(10, -18);
      }
    }
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          filterQuality: FilterQuality.low,
          offset: Offset(
              widget.opacity
                  ? (50 - (50 * _animationController.value - 0.001))
                  : 0.0,
              0.0),
          child: AnimatedOpacity(
              opacity: widget.opacity ? _animationController.value : 1.0,
              duration: const Duration(milliseconds: 450),
              child: child!),
        );
      },
      child: ExpandablePanel(
        theme: const ExpandableThemeData(
          hasIcon: false,
          useInkWell: true,
        ),
        header: _HeaderTransactionWidget(
          color: color,
          score: score,
          increase: increase,
          titleCoin: widget.titleCoin,
          transaction: widget.transaction,
        ),
        collapsed: const SizedBox(),
        expanded: _ExpandedTransactionWidget(
          hashTransaction: widget.transaction.hash!,
          address: increase
              ? widget.transaction.fromAddressHash!.hex!
              : widget.transaction.toAddressHash!.hex!,
          increase: increase,
        ),
      ),
    );
  }
}

class _HeaderTransactionWidget extends StatelessWidget {
  final String titleCoin;
  final Tx transaction;
  final bool increase;
  final double score;
  final Color color;

  const _HeaderTransactionWidget({
    Key? key,
    required this.color,
    required this.score,
    required this.increase,
    required this.titleCoin,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    .format(transaction.amount != null
                    ? transaction.insertedAt!.toLocal()
                    : transaction.block!.timestamp!.toLocal())
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
              '${increase ? '+' : '-'}${score.toStringAsFixed(5)} $titleCoin',
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
    );
  }
}

class _ExpandedTransactionWidget extends StatelessWidget {
  final String hashTransaction;
  final String address;
  final bool increase;

  const _ExpandedTransactionWidget({
    Key? key,
    required this.address,
    required this.increase,
    required this.hashTransaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ItemInfoFromTransaction(
            info: hashTransaction,
            title: "Hash tx",
            isSelectable: true,
          ),
          const SizedBox(
            height: 6,
          ),
          _ItemInfoFromTransaction(
            info: address,
            title: increase ? "From" : "To",
            isSelectable: true,
          ),
        ],
      ),
    );
  }
}

class _ItemInfoFromTransaction extends StatelessWidget {
  final bool isSelectable;
  final String title;
  final String info;

  const _ItemInfoFromTransaction({
    Key? key,
    required this.info,
    required this.title,
    this.isSelectable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isSelectable) {
      return SelectableText.rich(
        TextSpan(
          text: "$title: ",
          style: const TextStyle(
              fontSize: 14, color: AppColor.unselectedBottomIcon),
          children: [
            TextSpan(text: info, style: const TextStyle(color: Colors.black)),
          ],
        ),
        style: TextStyle(overflow: TextOverflow.ellipsis),
      );
    } else {
      return RichText(
        text: TextSpan(
          text: "$title: ",
          style: const TextStyle(
              fontSize: 14, color: AppColor.unselectedBottomIcon),
          children: [
            TextSpan(
                text: info,
                style: const TextStyle(fontSize: 14, color: Colors.black)),
          ],
        ),
      );
    }
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
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
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
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.white),
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
                      borderRadius: BorderRadius.circular(6.0),
                      color: Colors.white),
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
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
