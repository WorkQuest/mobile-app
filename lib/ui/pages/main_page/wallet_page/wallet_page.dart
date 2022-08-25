import 'dart:io';
import 'package:app/ui/pages/main_page/wallet_page/deposit_page/deposit_page.dart';
import 'package:app/ui/pages/main_page/wallet_page/store/wallet_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/swap_page/swap_page.dart';
import 'package:app/ui/pages/main_page/wallet_page/transactions/store/transactions_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/withdraw_page/withdraw_page.dart';
import 'package:app/ui/widgets/button_to_explorer.dart';
import 'package:app/ui/widgets/copy_address_wallet_widget.dart';
import 'package:app/ui/widgets/dropdown_adaptive_widget.dart';
import 'package:app/ui/widgets/shimmer.dart';
import 'package:app/ui/widgets/switch_format_address_widget.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import '../../../../constants.dart';
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
        if (scrollEnd.metrics.pixels >= scrollEnd.metrics.maxScrollExtent) {
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
    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("wallet.wallet".tr()),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: ValueListenableBuilder<NetworkName?>(
                  valueListenable: WalletRepository().networkName,
                  builder: (_, value, child) {
                    final _networkName = Web3Utils.getNetworkNameForSwitch(value!);
                    return SwitchNetworkWidget<SwitchNetworkNames>(
                      value: _networkName,
                      onChanged: _onChangedSwitchNetwork,
                      items: SwitchNetworkNames.values,
                      colorText: Colors.black,
                      haveIcon: true,
                    );
                  },
                ),
              )
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
                CopyAddressWalletWidget(
                  format: WalletRepository().isOtherNetwork
                      ? FormatAddress.HEX
                      : FormatAddress.BECH32,
                ),
                const SizedBox(
                  height: 20,
                ),
                Observer(
                  builder: (_) => _BannerBuyingWQT(
                    isEnabled: _isShowBanner,
                    button: outlinedButton(
                      title: 'wallet.buyWQT'.tr(),
                      route: SwapPage.routeName,
                      color: Colors.white,
                    ),
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
                      child: outlinedButton(
                          route: WithdrawPage.routeName, title: "wallet.withdraw".tr()),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: outlinedButton(
                          route: DepositPage.routeName, title: "wallet.deposit".tr()),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        child: Text('wallet'.tr(gender: 'swap')),
                        onPressed: () async {
                          Navigator.of(context, rootNavigator: true)
                              .pushNamed(SwapPage.routeName);
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
            centerTitle: false,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(bottom: 18.0),
              title: Text(
                'wallet.table.trx'.tr(),
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              ),
            ),
            actions: const [
              ButtonToExplorer(),
            ],
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

  _onChangedSwitchNetwork(dynamic value) {
    final _newNetwork = Web3Utils.getNetworkNameFromSwitchNetworkName(
        value as SwitchNetworkNames, WalletRepository().notifierNetwork.value);
    WalletRepository().changeNetwork(_newNetwork);
    return value;
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
    return GetIt.I.get<WalletStore>().getCoins();
  }

  bool get _isShowBanner {
    if (GetIt.I.get<WalletStore>().coins.isEmpty) {
      return false;
    }
    final _networkName = WalletRepository().networkName.value!;
    if (_networkName == NetworkName.workNetTestnet ||
        _networkName == NetworkName.workNetMainnet) {
      try {
        final _wqt = GetIt.I
            .get<WalletStore>()
            .coins
            .firstWhere((element) => element.symbol == TokenSymbols.WQT);
        if (double.parse(_wqt.amount!) == 0.0) {
          return true;
        }
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}

class _BannerBuyingWQT extends StatelessWidget {
  final Widget button;
  final bool isEnabled;

  const _BannerBuyingWQT({
    Key? key,
    required this.button,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: isEnabled
          ? Container(
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
            )
          : SizedBox(
              width: double.infinity,
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
  late final WalletStore store;


  @override
  void initState() {
    store = GetIt.I.get<WalletStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      AppColor.enabledButton,
                                      AppColor.blue,
                                    ],
                                  ),
                                ),
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: SvgPicture.asset(
                                    Web3Utils.getPathIcon(balance.symbol),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (store.isLoading)
                                    const _ShimmerWidget(
                                      width: double.infinity,
                                      height: 30,
                                    )
                                  else
                                    Text(
                                      '${num.parse(balance.amount!).toStringAsFixed(6)} ${balance.symbol.name}',
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
                                  else if (balance.pricePerDollar != null)
                                    Text(
                                      '\$ ${balance.pricePerDollar}',
                                      // _getCourseDollar(balance.symbol.name, balance.amount!),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColor.unselectedBottomIcon,
                                      ),
                                    )
                                  else
                                    const SizedBox(
                                      height: 17,
                                    )
                                ],
                              ),
                            ],
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
                    bool isCurrency = balance.symbol == store.currentToken;
                    return GestureDetector(
                      onTap: () => _controller.nextPage(),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: isCurrency
                              ? null
                              : Border.all(
                                  color: AppColor.enabledButton.withOpacity(0.1)),
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
        GetIt.I.get<TransactionsStore>().setType(TokenSymbols.WQT);
        break;
      case 1:
        GetIt.I.get<TransactionsStore>().setType(TokenSymbols.WUSD);
        break;
      case 2:
        GetIt.I.get<TransactionsStore>().setType(TokenSymbols.wBNB);
        break;
      case 3:
        GetIt.I.get<TransactionsStore>().setType(TokenSymbols.wETH);
        break;
      case 4:
        GetIt.I.get<TransactionsStore>().setType(TokenSymbols.USDT);
        break;
    }
    GetIt.I.get<TransactionsStore>().getTransactions();
    store.setCurrentToken(store.coins[index].symbol);
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
