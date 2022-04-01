import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/raise_views_page/store/raise_views_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/bank_card_widget.dart';
import 'package:app/ui/widgets/sliver_sticky_tab_bar.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

import '../../../../constants.dart';
import '../../../../web3/contractEnums.dart';
import '../../../widgets/dismiss_keyboard.dart';

final _divider = const SizedBox(
  height: 5.0,
);
final String coinsPath = "assets/coins";

List<_CoinItem> _coins = [
  _CoinItem("$coinsPath/wusd.svg", 'WUSD', TYPE_COINS.WUSD, true),
  _CoinItem("$coinsPath/wqt.svg", 'WQT', TYPE_COINS.WQT, true),
];

List<_WalletItem> _wallets = [
  _WalletItem("assets/coinpaymebts.svg", "Сoinpaymebts", TYPE_WALLET.Coinpaymebts),
];

class PaymentPage extends StatefulWidget {
  const PaymentPage(this.questId, {Key? key}) : super(key: key);

  final String? questId;

  static const String routeName = "/paymentPage";

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 2,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "modals.payment".tr(),
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        centerTitle: true,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColor.enabledButton,
          ),
        ),
      ),
      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(top: 10.0),
            sliver: SliverPersistentHeader(
              pinned: true,
              delegate: StickyTabBarDelegate(
                child: TabBar(
                  unselectedLabelColor: Color(0xFF8D96A1),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.white,
                  ),
                  labelColor: Colors.black,
                  controller: this._tabController,
                  tabs: <Widget>[
                    Tab(
                      child: Text(
                        "Crypto address",
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "wallet.bankCard".tr(),
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: this._tabController,
              children: [
                ///Wallet Transfer
                _WalletViewTab(
                  store: context.read<RaiseViewStore>(),
                  questId: widget.questId,
                ),

                ///Card Transfer
                BankCardTransaction(
                  transaction: "Pay",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget titledTextBox(
    String title,
    Widget textField,
  ) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
          ),
          _divider,
          Flexible(
            fit: FlexFit.loose,
            child: textField,
          ),
        ],
      );
}

class _WalletViewTab extends StatefulWidget {
  final RaiseViewStore store;
  final String? questId;

  const _WalletViewTab({
    Key? key,
    required this.store,
    required this.questId,
  }) : super(key: key);

  @override
  _WalletViewTabState createState() => _WalletViewTabState();
}

class _WalletViewTabState extends State<_WalletViewTab> {
  _CoinItem? _currentCoin;

  _WalletItem? _currentWallet;

  bool get _selectedCoin => _currentCoin != null;

  bool get _selectedWallet => _currentWallet != null;

  @override
  void initState() {
    super.initState();
    print('_WalletViewTabState');
    _currentCoin = _coins[0];
    _currentWallet = _wallets[0];
    widget.store.setTitleSelectedCoin(TYPE_COINS.WUSD);
    widget.store.setTitleSelectedWallet(TYPE_WALLET.Coinpaymebts);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Observer(
        builder: (context) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Choose currency"),
            _divider,
            GestureDetector(
              onTap: _chooseCoin,
              child: Container(
                height: 46,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 12.5,
                ),
                decoration: BoxDecoration(
                  color: _selectedCoin ? Colors.white : AppColor.disabledButton,
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                    color: AppColor.disabledButton,
                  ),
                ),
                child: Row(
                  children: [
                    if (_selectedCoin)
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
                          width: 32,
                          height: 32,
                          child: SvgPicture.asset(
                            _currentCoin!.iconPath,
                          ),
                        ),
                      ),
                    Text(
                      _selectedCoin ? _currentCoin!.title : 'wallet.enterCoin'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedCoin ? Colors.black : AppColor.disabledText,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_drop_down_outlined,
                      size: 25.0,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Text(
              'wallet.wallet'.tr(),
            ),
            _divider,
            GestureDetector(
              onTap: _chooseWallet,
              child: Container(
                height: 46,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 12.5,
                ),
                decoration: BoxDecoration(
                  color: _selectedWallet ? Colors.white : AppColor.disabledButton,
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                    color: AppColor.disabledButton,
                  ),
                ),
                child: Row(
                  children: [
                    if (_selectedWallet)
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
                          width: 32,
                          height: 32,
                          child: SvgPicture.asset(
                            _currentWallet!.iconPath,
                          ),
                        ),
                      ),
                    Text(
                      _selectedWallet ? _currentWallet!.title : 'wallet.enterCoin'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        color: _selectedWallet ? Colors.black : AppColor.disabledText,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_drop_down_outlined,
                      size: 25.0,
                    )
                  ],
                ),
              ),
            ),
            Spacer(),
            ObserverListener<RaiseViewStore>(
              onSuccess: () async {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.pop(context);
                Navigator.pop(context);
                await AlertDialogUtils.showSuccessDialog(context);
              },
              onFailure: () {
                Navigator.of(context, rootNavigator: true).pop();
                return false;
              },
              child: ElevatedButton(
                onPressed: widget.store.canSubmit
                    ? () async {
                        AlertDialogUtils.showLoadingDialog(context);
                        if (widget.questId == null || widget.questId!.isEmpty) {
                          await widget.store.raiseProfile();
                        } else {
                          await widget.store.raiseQuest(widget.questId!);
                        }
                      }
                    : null,
                child: Text("Pay"),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  void _chooseCoin() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: SingleChildScrollView(
              child: DismissKeyboard(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color(0xffE9EDF2),
                      ),
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'wallet.chooseCoin'.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 16.5,
                        ),
                        ..._coins
                            .map(
                              (coin) => Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6.5,
                                    ),
                                    child: GestureDetector(
                                      onTap: coin.isEnable
                                          ? () {
                                              _selectCoin(coin);
                                              Navigator.pop(context);
                                            }
                                          : null,
                                      child: Container(
                                        height: 32,
                                        width: double.infinity,
                                        color: Colors.transparent,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
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
                                                width: 32,
                                                height: 32,
                                                child: SvgPicture.asset(
                                                  coin.iconPath,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              coin.title,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: coin.isEnable
                                                    ? Colors.black
                                                    : AppColor.disabledText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: AppColor.disabledButton,
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _chooseWallet() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: SingleChildScrollView(
              child: DismissKeyboard(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color(0xffE9EDF2),
                      ),
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'wallet.chooseCoin'.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 16.5,
                        ),
                        ..._wallets
                            .map(
                              (wallet) => Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6.5,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        _selectWallet(wallet);
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: 32,
                                        width: double.infinity,
                                        color: Colors.transparent,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
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
                                                width: 32,
                                                height: 32,
                                                child: SvgPicture.asset(
                                                  wallet.iconPath,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              wallet.title,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: AppColor.disabledButton,
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectCoin(_CoinItem coin) {
    setState(() {
      _currentCoin = coin;
    });
    widget.store.setTitleSelectedCoin(coin.typeCoin);
  }

  void _selectWallet(_WalletItem wallet) {
    setState(() {
      _currentWallet = wallet;
    });
    widget.store.setTitleSelectedWallet(wallet.typeWallet);
  }
}

class _CoinItem {
  String iconPath;
  String title;
  bool isEnable;
  TYPE_COINS typeCoin;

  _CoinItem(this.iconPath, this.title, this.typeCoin, this.isEnable);
}

class _WalletItem {
  String iconPath;
  String title;
  TYPE_WALLET typeWallet;

  _WalletItem(this.iconPath, this.title, this.typeWallet);
}
