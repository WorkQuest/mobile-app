import 'dart:async';
import 'package:app/di/injector.dart';
import 'package:app/ui/pages/main_page/wallet_page/transfer_page/confirm_page/mobx/confirm_transfer_store.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:app/ui/widgets/layout_with_scroll.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import '../../../../../constants.dart';
import '../../../../../observer_consumer.dart';
import 'confirm_page/confirm_transfer_page.dart';
import 'mobx/transfer_store.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

final String coinsPath = "assets/coins";
List<_CoinItem> _coins = [
  _CoinItem("$coinsPath/wusd.svg", 'WUSD', TYPE_COINS.WUSD, true),
  _CoinItem("$coinsPath/wqt.svg", 'WQT', TYPE_COINS.WQT, true),
  _CoinItem("$coinsPath/wbnb.svg", 'wBNB', TYPE_COINS.wBNB, true),
  _CoinItem("$coinsPath/weth.svg", 'wETH', TYPE_COINS.wETH, true),
];

class TransferPage extends StatefulWidget {
  const TransferPage({
    Key? key,
  }) : super(key: key);

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _key = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _ey = GlobalKey<ScaffoldState>();
  _CoinItem? _currentCoin;

  late TransferStore store;

  bool get _selectedCoin => _currentCoin != null;

  @override
  void initState() {
    super.initState();
    store = context.read<TransferStore>();
    _currentCoin = _coins.first;
    store.setTitleSelectedCoin(TYPE_COINS.WUSD);
    store.getFee();
    _amountController.addListener(() {
      store.setAmount(_amountController.text);
    });
    _addressController.addListener(() {
      store.setAddressTo(_addressController.text);
    });
  }

  @override
  void dispose() {
    // _addressController.dispose();
    // _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<TransferStore>();
    return Scaffold(
      key: _ey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "wallet.transfer".tr(),
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
      body: LayoutWithScroll(
        child: Padding(
          padding: _padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
                width: double.infinity,
              ),
              Text(
                'wallet.chooseCoin'.tr(),
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: _chooseCoin,
                child: Container(
                  height: 46,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.5),
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
                height: 15,
              ),
              Text(
                'wallet.recipientsAddress'.tr(),
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(
                height: 5,
              ),
              Form(
                key: _key,
                child: TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: 'wallet.enterAddress'.tr(),
                  ),
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '0x########################################',
                      filter: {"#": RegExp(r'[0-9a-fA-F]')},
                      initialText: _addressController.text,
                    )
                  ],
                  validator: (value) {
                    if (_addressController.text.length != 42) {
                      return "Invalid format address";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'wallet.amount'.tr(),
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  hintText: 'wallet.enterAmount'.tr(),
                  suffixIcon: ObserverListener<TransferStore>(
                    onSuccess: () {
                      _amountController.text = store.amount;
                    },
                    child: CupertinoButton(
                      padding: const EdgeInsets.only(right: 12.5),
                      child: Text(
                        'wallet.max'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.enabledButton,
                        ),
                      ),
                      onPressed: () async {
                        store.getMaxAmount();
                      },
                    ),
                  ),
                ),
                // keyboardType: TextInputType.number,

                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,18}')),
                ],
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Observer(
                    builder: (_) => ElevatedButton(
                      child: Text('wallet.transfer'.tr()),
                      onPressed:
                          store.statusButtonTransfer ? _pushConfirmTransferPage : null,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pushConfirmTransferPage() async {
    if (_key.currentState!.validate()) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
      if (store.fee.isEmpty) {
        await store.getFee();
      }
      if (store.addressTo.toLowerCase() ==
          AccountRepository().userAddress!.toLowerCase()) {
        AlertDialogUtils.showInfoAlertDialog(context,
            title: 'modals.error'.tr(), content: 'errors.provideYourAddress'.tr());
        return;
      }
      if (double.parse(store.amount) == 0.0) {
        AlertDialogUtils.showInfoAlertDialog(context,
            title: 'modals.error'.tr(), content: 'errors.invalidAmount'.tr());
        return;
      }
      final result = await Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => Provider(
            create: (_) => getIt.get<ConfirmTransferStore>(),
            child: ConfirmTransferPage(
              fee: store.fee,
              typeCoin: store.typeCoin!,
              addressTo: store.addressTo,
              amount: store.amount,
            ),
          ),
        ),
      );
      if (result != null && result) {
        setState(() {
          store.setTitleSelectedCoin(null);
          store.setAddressTo('');
          store.setAmount('');
          _amountController.clear();
          _addressController.clear();
          _currentCoin = null;
        });
      }
    }
  }

  void _chooseCoin() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 300,
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
                                    padding: const EdgeInsets.symmetric(vertical: 6.5),
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

  void _selectCoin(_CoinItem coin) {
    setState(() {
      _currentCoin = coin;
    });
    store.setTitleSelectedCoin(coin.typeCoin);
  }
}

class _CoinItem {
  String iconPath;
  String title;
  bool isEnable;
  TYPE_COINS typeCoin;

  _CoinItem(this.iconPath, this.title, this.typeCoin, this.isEnable);
}
