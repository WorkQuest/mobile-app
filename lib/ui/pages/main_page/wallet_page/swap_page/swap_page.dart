import 'package:app/ui/pages/main_page/wallet_page/swap_page/store/swap_store.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../../../../../constants.dart';
import '../../../../../observer_consumer.dart';
import '../../../../../utils/alert_dialog.dart';
import '../../../../../utils/bottom_sheet.dart';
import '../../../../../web3/repository/account_repository.dart';
import '../../../../widgets/default_app_bar.dart';
import '../../../../widgets/default_button.dart';
import '../../../../widgets/default_textfield.dart';
import '../../../../widgets/dismiss_keyboard.dart';
import '../../../../widgets/selected_item.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0);
const _divider = SizedBox(
  height: 5,
);
const _spaceDivider = SizedBox(
  height: 15,
);
const _minimumError =
    'To avoid unnecessary fees and network slippage, the minimum amount for this pair is \$5 '
    'USDT/USDC';
const _maximumError =
    'To avoid unnecessary fees and network slippage, the maximum amount for this pair is \$100 '
    'USDT/USDC.';

class SwapPage extends StatefulWidget {
  static const String routeName = "/swapPage";

  const SwapPage({Key? key}) : super(key: key);

  @override
  _SwapPageState createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {
  final _formKey = GlobalKey<FormState>();
  late SwapStore store;
  late TextEditingController _amountController;
  late TextEditingController _addressToController;

  @override
  void initState() {
    store = context.read<SwapStore>();
    store.setNetwork(SwapNetworks.ethereum);
    _showLoading(start: true, message: 'Connecting to server...');
    _amountController = TextEditingController();
    _amountController.addListener(() {
      store.setAmount(double.tryParse(_amountController.text) ?? 0.0);
      if (store.isConnect) {
        store.getCourseWQT();
      }
    });

    _addressToController = TextEditingController();
    _addressToController.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'Buying WQT',
      ),
      body: ObserverListener<SwapStore>(
        onSuccess: () {
          Navigator.of(context, rootNavigator: true).pop();
          if (store.successData!) {
            AlertDialogUtils.showSuccessDialog(context);
          }
        },
        onFailure: () {
          Navigator.of(context, rootNavigator: true).pop();
          return false;
        },
        child: Observer(
          builder: (_) => RefreshIndicator(
            onRefresh: () {
              if (store.isConnect) {
                store.getCourseWQT(isForce: true);
                store.getMaxBalance();
              } else {
                store.setNetwork(store.network!);
              }
              return Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Padding(
                padding: _padding,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Choose network',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          const Spacer(),
                          if (!store.isConnect && store.errorMessage != null)
                            SizedBox(
                              height: 18,
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: const Text(
                                  'Retry',
                                  style:
                                      TextStyle(color: AppColor.enabledButton),
                                ),
                                onPressed: () {
                                  _showLoading(
                                      message: 'Connecting to network...');
                                  store.setNetwork(store.network!);
                                },
                              ),
                            ),
                        ],
                      ),
                      _divider,
                      SelectedItem(
                        title: _getTitleNetwork(store.network!),
                        iconPath: _getIconPathNetwork(store.network!),
                        isSelected: true,
                        onTap: _onPressedSelectNetwork,
                      ),
                      _spaceDivider,
                      const Text(
                        'Choose token',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      _divider,
                      SelectedItem(
                        title: _getTitleToken(store.token),
                        iconPath: 'assets/usdt_coin_icon.svg',
                        isSelected: true,
                        onTap: _onPressedSelectToken,
                      ),
                      _spaceDivider,
                      Row(
                        children: [
                          Text(
                            'Amount (Balance: ${store.maxAmount ?? 0.0})',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          if (store.isConnect)
                            SizedBox(
                              height: 18,
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: const Text(
                                  'Update',
                                  style: TextStyle(
                                    color: AppColor.enabledButton,
                                  ),
                                ),
                                onPressed: () {
                                  store.getMaxBalance();
                                },
                              ),
                            )
                        ],
                      ),
                      _divider,
                      DefaultTextField(
                        enableDispose: false,
                        controller: _amountController,
                        hint: 'Amount',
                        enabled: store.isConnect,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null) {
                            return "errors.fieldEmpty".tr();
                          }
                          try {
                            final val = double.parse(value);
                            if (val < 5.0) {
                              return _minimumError;
                            }
                            if (val > 100.0) {
                              return _maximumError;
                            }
                            if (store.maxAmount != null) {
                              if (store.maxAmount! < val) {
                                return 'Higher max amount';
                              }
                            }
                          } catch (e) {
                            return "errors.incorrectFormat".tr();
                          }
                          return null;
                        },
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,18}')),
                        ],
                        suffixIcon: CupertinoButton(
                          padding: const EdgeInsets.only(right: 12.5),
                          child: Text(
                            'wallet.max'.tr(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColor.enabledButton,
                            ),
                          ),
                          onPressed: () {
                            if (!store.isConnect) {
                              return;
                            }
                            _amountController.text = store.maxAmount.toString();
                            _addressToController.text =
                                AccountRepository().userWallet!.address!;
                          },
                        ),
                      ),
                      _spaceDivider,
                      const Text(
                        'Address wallet to',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      _divider,
                      DefaultTextField(
                        enableDispose: false,
                        controller: _addressToController,
                        hint: 'Address to',
                        enabled: store.isConnect,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: '0x########################################',
                            filter: {"#": RegExpFields.addressRegExp},
                            initialText: _addressToController.text,
                          )
                        ],
                        validator: (value) {
                          if (_addressToController.text.length != 42) {
                            return "errors.incorrectFormat".tr();
                          }
                          return null;
                        },
                      ),
                      _spaceDivider,
                      Row(
                        children: [
                          const Text('Amount of WQT ≈ '),
                          const SizedBox(
                            width: 2,
                          ),
                          if (store.isLoadingCourse)
                            const SizedBox(
                              height: 10,
                              width: 10,
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          if (store.isSuccessCourse)
                            Text(store.convertWQT.toString()),
                        ],
                      ),
                      const SizedBox(
                        height: 250,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0 + MediaQuery.of(context).padding.bottom),
        child: DefaultButton(
          title: 'Send',
          onPressed: _onPressedSend,
        ),
      ),
    );
  }

  _showLoading({bool start = false, String? message}) {
    if (start) {
      Future.delayed(const Duration(milliseconds: 150)).then(
        (value) =>
            AlertDialogUtils.showLoadingDialog(context, message: message),
      );
    } else {
      AlertDialogUtils.showLoadingDialog(context, message: message);
    }
  }

  _onPressedSend() {
    if (_formKey.currentState!.validate()) {
      _showLoading(message: 'Buying WQT');
      store.createSwap(_addressToController.text);
    }
  }

  _onPressedSelectNetwork() {
    BottomSheetUtils.showDefaultBottomSheet(
      context,
      child: _ListBottomWidget(
        onTap: (value) {
          store.setNetwork(value);
          _showLoading(message: 'Connecting to server...');
        },
        title: 'Choose network',
        items: [
          _ModelItem(
              iconPath: 'assets/weth_coin_icon.svg',
              item: SwapNetworks.ethereum),
          _ModelItem(
              iconPath: 'assets/wbnb_coin_icon.svg',
              item: SwapNetworks.binance),
          _ModelItem(
              iconPath: 'assets/wqt_coin_icon.svg', item: SwapNetworks.matic),
        ],
      ),
    );
  }

  _onPressedSelectToken() {
    BottomSheetUtils.showDefaultBottomSheet(
      context,
      child: _ListBottomWidget(
        onTap: (value) => store.setToken(value),
        title: 'Choose token',
        items: [
          _ModelItem(
              item: SwapToken.tusdt, iconPath: 'assets/usdt_coin_icon.svg'),
        ],
      ),
    );
  }

  _getTitleNetwork(SwapNetworks network) {
    switch (network) {
      case SwapNetworks.ethereum:
        return 'Ethereum Main Network';
      case SwapNetworks.binance:
        return 'Binance Smart Chain';
      case SwapNetworks.matic:
        return 'Matic Network';
    }
  }

  _getTitleToken(SwapToken token) {
    switch (token) {
      case SwapToken.tusdt:
        return 'TUSDT';
      case SwapToken.usdc:
        return 'USDC';
    }
  }

  _getIconPathNetwork(SwapNetworks network) {
    switch (network) {
      case SwapNetworks.ethereum:
        return 'assets/weth_coin_icon.svg';
      case SwapNetworks.binance:
        return 'assets/wbnb_coin_icon.svg';
      case SwapNetworks.matic:
        return 'assets/wqt_coin_icon.svg';
    }
  }
}

class _ModelItem {
  final String iconPath;
  final dynamic item;

  _ModelItem({
    required this.iconPath,
    required this.item,
  });
}

class _ListBottomWidget extends StatelessWidget {
  final String title;
  final List<_ModelItem> items;
  final Function(dynamic) onTap;

  const _ListBottomWidget({
    Key? key,
    required this.title,
    required this.items,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
            title,
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
                      ...items
                          .map(
                            (item) => Column(
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      Navigator.pop(context);
                                      onTap.call(item.item);
                                    },
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
                                                    item.iconPath,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                _getName(item.item),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
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
    );
  }

  String _getName(dynamic value) {
    if (value is SwapToken) {
      return value.name.toUpperCase();
    } else if (value is SwapNetworks) {
      switch (value) {
        case SwapNetworks.ethereum:
          return 'Ethereum Main Network';
        case SwapNetworks.binance:
          return 'Binance Smart Chain';
        case SwapNetworks.matic:
          return 'Matic Network';
      }
    }
    return '';
  }
}
