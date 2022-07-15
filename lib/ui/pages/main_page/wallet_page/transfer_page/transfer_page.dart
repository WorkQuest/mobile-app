import 'dart:async';
import 'package:app/di/injector.dart';
import 'package:app/ui/pages/main_page/wallet_page/transfer_page/confirm_page/mobx/confirm_transfer_store.dart';
import 'package:app/ui/widgets/default_button.dart';
import 'package:app/ui/widgets/default_textfield.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:app/ui/widgets/layout_with_scroll.dart';
import 'package:app/ui/widgets/selected_item.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/bottom_sheet.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:app/web3/service/address_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:majascan/majascan.dart';
import 'package:provider/provider.dart';
import '../../../../../constants.dart';
import '../../../../../observer_consumer.dart';
import 'confirm_page/confirm_transfer_page.dart';
import 'mobx/transfer_store.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

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
  final _formKey = GlobalKey<FormState>();

  late final List<CoinItem> _coins = [];

  late TransferStore store;

  _initCoins() {
    final _dataTokens = AccountRepository().getConfigNetwork().dataCoins;
    _coins
      ..clear()
      ..addAll(_dataTokens
          .map((coin) => CoinItem(
                coin.iconPath,
                coin.symbolToken.name,
                coin.symbolToken,
                true,
              ))
          .toList());
  }

  @override
  void initState() {
    store = context.read<TransferStore>();
    _amountController.addListener(() {
      store.setAmount(_amountController.text);
    });
    _addressController.addListener(() {
      store.setAddressTo(_addressController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    store.setAmount('');
    store.setAddressTo('');
    store.setFee('');
    store.setCoin(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initCoins();
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutWithScroll(
        child: Observer(
          builder: (_) => Padding(
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
                SelectedItem(
                  title: store.currentCoin?.title,
                  iconPath: store.currentCoin?.iconPath,
                  isSelected: store.currentCoin != null,
                  onTap: _chooseCoin,
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
                  child: DefaultTextField(
                    controller: _addressController,
                    hint: 'wallet.enterAddress'.tr(),
                    suffixIcon: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        String? qrResult = await MajaScan.startScan(
                            title: "QRcode scanner",
                            barColor: Colors.black,
                            titleColor: Colors.white,
                            qRCornerColor: Colors.blue,
                            qRScannerColor: Colors.white,
                            flashlightEnable: true,
                            scanAreaScale: 0.7);
                        if (qrResult != null) {
                          _addressController.text = qrResult;
                          store.setAddressTo(qrResult);
                        }
                      },
                      child: SvgPicture.asset(
                        'assets/scan_qr.svg',
                        color: AppColor.enabledButton,
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return 'errors.fieldEmpty'.tr();
                        }
                        try {
                          final _isBech = value.substring(0, 2).toLowerCase() == 'wq';
                          if (_isBech) {
                            if (value.length != 41) {
                              return "errors.incorrectFormat".tr();
                            }
                            if (!RegExpFields.addressBech32RegExp.hasMatch(value)) {
                              return "errors.incorrectFormat".tr();
                            }
                          } else {
                            if (value.length != 42) {
                              return "errors.incorrectFormat".tr();
                            }
                            if (!RegExpFields.addressRegExp.hasMatch(value)) {
                              return "errors.incorrectFormat".tr();
                            }
                          }
                        } catch (e) {
                          return 'errors.incorrectFormat'.tr();
                        }
                      }
                      return null;
                    },
                    inputFormatters: [],
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
                Form(
                  key: _formKey,
                  child: DefaultTextField(
                    controller: _amountController,
                    hint: 'wallet.enterAmount'.tr(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null) {
                        return null;
                      }
                      if (value.isEmpty) {
                        return 'errors.fieldEmpty'.tr();
                      }
                      try {
                        final _value = double.parse(value);
                        if (store.maxAmount != null) {
                          if (_value > store.maxAmount!) {
                            return 'Max: ${store.maxAmount}';
                          }
                        }
                      } catch (e) {
                        return 'errors.incorrectFormat'.tr();
                      }
                      return null;
                    },
                    suffixIcon: ObserverListener<TransferStore>(
                      onFailure: () {
                        return false;
                      },
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
                          if (_key.currentState!.validate()) {
                            if (store.currentCoin != null) {
                              store.getMaxAmount();
                            } else {
                              final title = 'meta.error'.tr();
                              final content = 'crediting.chooseCoin'.tr();
                              AlertDialogUtils.showInfoAlertDialog(context, title: title, content: content);
                            }
                          }
                        },
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,18}')),
                    ],
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Observer(
                  builder: (_) => Text(
                    _getTitleTrxFee(),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10 + MediaQuery.of(context).padding.bottom, left: 16.0, right: 16.0),
        child: SizedBox(
          width: double.infinity,
          child: Observer(
            builder: (_) => DefaultButton(
              title: 'wallet.withdraw'.tr(),
              onPressed: store.statusButtonTransfer ? _pushConfirmTransferPage : null,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pushConfirmTransferPage() async {
    if (_key.currentState!.validate() && _formKey.currentState!.validate()) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
      await store.getFee();
      final _isBech = store.addressTo.substring(0, 2).toLowerCase() == 'wq';
      if (_isBech) {
        if (store.addressTo.toLowerCase() ==
            AddressService.hexToBech32(AccountRepository().userWallet!.address!.toLowerCase())) {
          AlertDialogUtils.showInfoAlertDialog(context,
              title: 'meta.error'.tr(), content: 'errors.provideYourAddress'.tr());
          return;
        }
      } else {
        if (store.addressTo.toLowerCase() == AccountRepository().userWallet!.address!.toLowerCase()) {
          AlertDialogUtils.showInfoAlertDialog(context,
              title: 'meta.error'.tr(), content: 'errors.provideYourAddress'.tr());
          return;
        }
      }
      if (double.parse(store.amount) == 0.0) {
        AlertDialogUtils.showInfoAlertDialog(context, title: 'meta.error'.tr(), content: 'errors.invalidAmount'.tr());
        return;
      }
      final result = await Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => Provider(
            create: (_) => getIt.get<ConfirmTransferStore>(),
            child: ConfirmTransferPage(
              fee: store.fee,
              typeCoin: store.currentCoin!.typeCoin,
              addressTo: store.addressTo,
              amount: store.amount,
            ),
          ),
        ),
      );
      if (result != null && result) {
        setState(() {
          store.setCoin(null);
          store.setAddressTo('');
          store.setAmount('');
          _amountController.clear();
          _addressController.clear();
        });
      }
    }
  }

  _getTitleTrxFee() {
    final _value = store.amount.isNotEmpty ? (double.tryParse(store.fee) ?? 0.0) : 0.0;
    return '${'wallet.table.trxFee'.tr()}: ${_value.toStringAsFixed(7)} '
        '${Web3Utils.getNativeToken()}';
  }

  void _chooseCoin() {
    BottomSheetUtils.showDefaultBottomSheet(
      context,
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
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'wallet.chooseCoin'.tr(),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            height: 16.5,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: DismissKeyboard(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._coins
                            .map(
                              (coin) => Column(
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: coin.isEnable
                                          ? () {
                                              _selectCoin(coin);
                                              Navigator.pop(context);
                                            }
                                          : null,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 6.5,
                                        ),
                                        child: InkWell(
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
                                                    color: coin.isEnable ? Colors.black : AppColor.disabledText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
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
        ],
      ),
    );
  }

  void _selectCoin(CoinItem coin) {
    store.setAmount('');
    _amountController.clear();
    store.setCoin(coin);
  }
}

class CoinItem {
  String iconPath;
  String title;
  TokenSymbols typeCoin;
  bool isEnable;

  CoinItem(this.iconPath, this.title, this.typeCoin, this.isEnable);
}
