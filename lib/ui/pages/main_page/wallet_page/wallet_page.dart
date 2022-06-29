import 'dart:io';
import 'package:app/di/injector.dart';
import 'package:app/ui/pages/main_page/wallet_page/deposit_page/deposit_page.dart';
import 'package:app/ui/pages/main_page/wallet_page/network_page.dart';
import 'package:app/ui/pages/main_page/wallet_page/store/wallet_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/swap_page/swap_page.dart';
import 'package:app/ui/pages/main_page/wallet_page/transactions/store/transactions_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/transfer_page/mobx/transfer_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/transfer_page/transfer_page.dart';
import 'package:app/ui/pages/main_page/wallet_page/withdraw_page/withdraw_page.dart';
import 'package:app/ui/widgets/shimmer.dart';
import 'package:app/utils/snack_bar.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import '../../../../constants.dart';
import "package:provider/provider.dart";
import 'transactions/list_transactions.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);
  static const String routeName = "/WalletPage";

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _mainLayout());
  }

  Widget _mainLayout() {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        if (scrollEnd.metrics.atEdge) if (scrollEnd.metrics.pixels == scrollEnd.metrics.maxScrollExtent) {
          if (!GetIt.I.get<TransactionsStore>().isMoreLoading) {
            GetIt.I.get<TransactionsStore>().getTransactionsMore();
          }
        }
        setState(() {});
        return true;
      },
      child: Platform.isAndroid
          ? RefreshIndicator(
              displacement: 30,
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: _onRefresh,
              child: layout())
          : layout(),
    );
  }

  Widget layout() {
    final address = AccountRepository().userAddress;
    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("wallet.wallet".tr()),
              PopupMenuButton<String>(
                elevation: 10,
                icon: Icon(Icons.more_vert),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
                onSelected: (value) async {
                  switch (value) {
                    case "wallet.changeNetwork":
                      await Navigator.of(context, rootNavigator: true).pushNamed(NetworkPage.routeName);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {
                    "wallet.changeNetwork",
                  }.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice.tr(),
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          ),
        ),
        if (Platform.isIOS)
          CupertinoSliverRefreshControl(
            onRefresh: _onRefresh,
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: _padding,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${address.substring(0, 9)}...'
                      '${address.substring(address.length - 3, address.length)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColor.subtitleText,
                      ),
                    ),
                    const Spacer(),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      pressedOpacity: 0.2,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: address));
                        SnackBarUtils.success(
                          context,
                          title: 'wallet'.tr(gender: 'copy'),
                          duration: const Duration(milliseconds: 500),
                        );
                      },
                      child: Container(
                        height: 34,
                        width: 34,
                        padding: const EdgeInsets.all(7.0),
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(6.0), color: AppColor.disabledButton),
                        child: SvgPicture.asset(
                          "assets/copy_icon.svg",
                          color: AppColor.enabledButton,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                _BannerBuyingWQT(
                  button: outlinedButton(
                    title: 'wallet.buyWQT'.tr(),
                    route: SwapPage.routeName,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  width: double.infinity,
                  child: _InfoCardBalance(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: outlinedButton(route: WithdrawPage.routeName, title: "wallet.withdraw".tr()),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: outlinedButton(route: DepositPage.routeName, title: "wallet.deposit".tr()),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        child: Text('wallet'.tr(gender: 'transfer')),
                        onPressed: () async {
                          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                            builder: (_) => Provider(
                              create: (context) => getIt.get<TransferStore>(),
                              child: TransferPage(),
                            ),
                          ));
                        },
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: _padding,
          sliver: SliverAppBar(
            floating: true,
            pinned: true,
            snap: true,
            expandedHeight: 50.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(bottom: 12.0),
              title: Text(
                'wallet.table.trx'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            centerTitle: false,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
          ),
        ),
        SliverPadding(
          padding: _padding,
          sliver: ListTransactions(
            scrollController: _scrollController,
          ),
        ),
      ],
    );
  }

  Widget outlinedButton({
    required String title,
    required String route,
    Color? color,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      pressedOpacity: 0.2,
      onPressed: () {
        ///Route to withdraw page
        Navigator.of(context, rootNavigator: true).pushNamed(route);
      },
      child: Container(
        height: 43,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: Colors.blue.withOpacity(0.1),
          ),
          color: color,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: AppColor.enabledButton,
          ),
        ),
      ),
    );
  }

  Future _onRefresh() async {
    GetIt.I.get<TransactionsStore>().getTransactions(isForce: true);
    return GetIt.I.get<WalletStore>().getCoins();
  }
}

class _BannerBuyingWQT extends StatelessWidget {
  final Widget button;

  const _BannerBuyingWQT({
    Key? key,
    required this.button,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.enabledButton,
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'wallet.buyTitleWQT'.tr(),
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'wallet.buyDescriptionWQT'.tr(),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: button,
          ),
        ],
      ),
    );
  }
}

class _InfoCardBalance extends StatefulWidget {
  const _InfoCardBalance({Key? key}) : super(key: key);

  @override
  State<_InfoCardBalance> createState() => _InfoCardBalanceState();
}

class _InfoCardBalanceState extends State<_InfoCardBalance> {
  final CarouselController _controller = CarouselController();

  int _currencyIndex = 0;

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I.get<WalletStore>();
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: AppColor.disabledButton,
      ),
      child: Observer(
        builder: (_) {
          if (store.coins.isNotEmpty) {
            return Column(
              children: [
                CarouselSlider(
                  carouselController: _controller,
                  items: store.coins.map((balance) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'wallet'.tr(gender: 'balance'),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          if (store.isLoading)
                            const _ShimmerWidget(
                              width: double.infinity,
                              height: 30,
                            )
                          else
                            Text(
                              // '${num.parse(balance.amount).toInt()} ${balance.title}',
                              '${num.parse(balance.amount!)} ${balance.symbol.name}',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: AppColor.enabledButton,
                              ),
                            ),
                          const SizedBox(
                            height: 5,
                          ),
                          if (store.isLoading)
                            const _ShimmerWidget(
                              width: 140,
                              height: 15,
                            )
                          else
                            Text(
                              _getCourseDollar(balance.symbol.name, balance.amount!),
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColor.unselectedBottomIcon,
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 120.0,
                    viewportFraction: 1.0,
                    disableCenter: true,
                    onPageChanged: _onPageChanged,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: store.coins.map((balance) {
                    if (_currencyIndex >= store.coins.length) {
                      _currencyIndex = 0;
                    }
                    bool isCurrency = balance == store.coins[_currencyIndex];

                    return GestureDetector(
                      onTap: () => _controller.nextPage(),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: isCurrency ? null : Border.all(color: AppColor.enabledButton.withOpacity(0.1)),
                          color: isCurrency ? AppColor.enabledButton : Colors.transparent,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          }
          if (store.isLoading) {
            return const _ShimmerInfoCard();
          }
          if (store.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'errors.failedToGetBalance'.tr(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'errors.swipeUpdate'.tr(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text(
              'You don\'t have any coins',
            ),
          );
        },
      ),
    );
  }

  _onPageChanged(int index, dynamic _) {
    switch (index) {
      case 0:
        GetIt.I.get<WalletStore>().setType(TokenSymbols.WQT);
        GetIt.I.get<TransactionsStore>().setType(TokenSymbols.WQT);
        break;
      case 1:
        GetIt.I.get<WalletStore>().setType(TokenSymbols.WUSD);
        GetIt.I.get<TransactionsStore>().setType(TokenSymbols.WUSD);
        break;
      case 2:
        GetIt.I.get<WalletStore>().setType(TokenSymbols.wBNB);
        GetIt.I.get<TransactionsStore>().setType(TokenSymbols.wBNB);
        break;
      case 3:
        GetIt.I.get<WalletStore>().setType(TokenSymbols.wETH);
        GetIt.I.get<TransactionsStore>().setType(TokenSymbols.wETH);
        break;
      case 4:
        GetIt.I.get<WalletStore>().setType(TokenSymbols.USDT);
        GetIt.I.get<TransactionsStore>().setType(TokenSymbols.USDT);
        break;
    }
    GetIt.I.get<TransactionsStore>().getTransactions(isForce: true);
    setState(() {
      _currencyIndex = index;
    });
  }

  String _getCourseDollar(String title, String amount) {
    switch (title) {
      case 'WQT':
        return '\$ ${(num.parse(amount).toDouble() * 0.03431).toStringAsFixed(4)}';
      case 'wBNB':
        return '\$ ${(num.parse(amount).toDouble() * 0.1375).toStringAsFixed(4)}';
      default:
        return '\$ ${num.parse(amount).toDouble().toStringAsFixed(4)}';
    }
  }
}

class _ShimmerInfoCard extends StatelessWidget {
  const _ShimmerInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'wallet.balance'.tr(),
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: double.infinity,
            height: 30,
            child: Shimmer.fromColors(
              baseColor: const Color(0xfff1f0f0),
              highlightColor: Colors.white,
              child: Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 140,
            height: 15,
            child: Shimmer.fromColors(
              baseColor: const Color(0xfff1f0f0),
              highlightColor: Colors.white,
              child: Container(
                width: 100,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;

  const _ShimmerWidget({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
        baseColor: const Color(0xfff1f0f0),
        highlightColor: Colors.white,
        child: Container(
          width: 100,
          height: 15,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
