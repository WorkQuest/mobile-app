import 'dart:math';

import 'package:app/constants.dart';
import 'package:app/model/web3/transactions_response.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/wallet_page/store/wallet_store.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/wallet_page/widgets/list_transactions/store/transactions_store.dart';
import 'package:app/ui/widgets/shimmer.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

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
          final _isOtherNetwork = WalletRepository().isOtherNetwork;
          if (!_isOtherNetwork) {
            if (store.transactions.isEmpty) {
              if (GetIt.I.get<WalletStore>().isLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
              }
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
                  if (store.isMoreLoading &&
                      index == store.transactions.length) {
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
                    coin: store.transactions[index].coin!,
                    opacity: !store.transactions[index].show,
                  );
                },
                childCount: store.isMoreLoading
                    ? store.transactions.length + 1
                    : store.transactions.length,
              ),
            );
          } else {
            return SliverToBoxAdapter(
              child: SizedBox(
                width: double.infinity,
                height: 250,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/empty_list_icon.svg',
                        width: 60.27,
                        height: 55.25,
                      ),
                      const SizedBox(height: 25.38),
                      Text(
                        'errors.emptyListTrx'.tr(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColor.disabledText),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        }
        if (store.errorMessage != null) {
          return SliverFillRemaining(
            child: Center(
              child: Text(store.errorMessage!),
            ),
          );
        }
        return const SliverFillRemaining(
          child: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      },
    );
  }
}

class TransactionItem extends StatefulWidget {
  final TokenSymbols coin;
  final Tx transaction;
  final bool opacity;

  const TransactionItem({
    Key? key,
    required this.transaction,
    required this.coin,
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
        WalletRepository().userAddress;
    Color color = increase ? Colors.green : Colors.red;
    double score = _getScore(widget.transaction);
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
            child: child!,
          ),
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
          titleCoin: widget.coin.name,
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

  double _getScore(Tx tx) {
    if (tx.tokenTransfers != null && tx.tokenTransfers!.isEmpty) {
      return BigInt.parse(tx.value!).toDouble() * pow(10, -18);
    }
    if (tx.amount != null) {
      return BigInt.parse(tx.amount!).toDouble() * pow(10, -18);
    }
    if (widget.coin == TokenSymbols.USDT) {
      return BigInt.parse(tx.tokenTransfers!.first.amount!).toDouble() *
          pow(10, -6);
    }
    return BigInt.parse(tx.tokenTransfers!.first.amount!).toDouble() *
        pow(10, -18);
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
            title: "wallet.hashTx".tr(),
            isEnabled: true,
          ),
          const SizedBox(
            height: 6,
          ),
          _ItemInfoFromTransaction(
            info: address,
            title: increase
                ? "settings.education.from".tr()
                : "settings.education.to".tr(),
          ),
        ],
      ),
    );
  }
}

class _ItemInfoFromTransaction extends StatelessWidget {
  final String title;
  final String info;
  final bool isEnabled;

  const _ItemInfoFromTransaction({
    Key? key,
    required this.info,
    required this.title,
    this.isEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        text: "$title: ",
        style:
            const TextStyle(fontSize: 14, color: AppColor.unselectedBottomIcon),
        children: [
          TextSpan(
            text: info,
            style: TextStyle(
              color: isEnabled ? AppColor.enabledButton : Colors.black,
              decoration: isEnabled ? TextDecoration.underline : null,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = isEnabled ? _onTapTxHash : null,
          ),
        ],
      ),
      style: const TextStyle(overflow: TextOverflow.ellipsis),
    );
  }

  _onTapTxHash() {
    final _isMainnet =
        WalletRepository().notifierNetwork.value == Network.mainnet;
    if (_isMainnet) {
      launchUrl(Uri.parse('https://explorer.workquest.co/tx/$info'));
    } else {
      launchUrl(Uri.parse(
          'https://${Constants.isTestnet ? 'testnet' : 'dev'}-explorer.workquest.co/tx/$info'));
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