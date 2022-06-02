import 'dart:async';

import 'package:app/constants.dart';
import 'package:app/ui/pages/main_page/wallet_page/swap_page/store/swap_store.dart';
import 'package:app/ui/widgets/default_app_bar.dart';
import 'package:app/ui/widgets/default_textfield.dart';
import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:app/ui/widgets/layout_with_scroll.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../../../../../../utils/alert_dialog.dart';
import '../../../../widgets/default_button.dart';

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
    // _showLoading();
    _amountController = TextEditingController();
    _amountController.addListener(
        () => store.setAmount(double.tryParse(_amountController.text) ?? 0.0));

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
      body: Observer(
        builder: (_) => LayoutWithScroll(
          child: DismissKeyboard(
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
                                style: TextStyle(color: AppColor.enabledButton),
                              ),
                              onPressed: () async {
                                await store.setNetwork(store.network!);
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                            ),
                          ),
                      ],
                    ),
                    _divider,
                    _SelectedItem(
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
                    _SelectedItem(
                      title: _getTitleToken(store.token),
                      iconPath: "assets/usdt_coin_icon.svg",
                      isSelected: true,
                      onTap: _onPressedSelectToken,
                    ),
                    _spaceDivider,
                    const Text(
                      'Amount',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    _divider,
                    DefaultTextField(
                      enableDispose: false,
                      controller: _amountController,
                      hint: 'Amount',
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
                        } catch (e) {
                          return "errors.incorrectFormat".tr();
                        }
                        return null;
                      },
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: _padding,
        child: DefaultButton(
          title: 'Send',
          onPressed: () {},
        ),
      ),
    );
  }

  _showLoading() {
    Future.delayed(const Duration(milliseconds: 50))
        .then((value) => AlertDialogUtils.showLoadingDialog(context));
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
        return "assets/weth_coin_icon.svg";
      case SwapNetworks.binance:
        return "assets/wbnb_coin_icon.svg";
      case SwapNetworks.matic:
        return "assets/wqt_coin_icon.svg";
    }
  }

  _onPressedSelectNetwork() {
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
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: _ListBottomWidget(
              onTap: (value) {
                store.setNetwork(value);
                // _showLoading();
              },
              title: 'Choose network',
              items: [
                _ModelItem(
                  iconPath: "assets/weth_coin_icon.svg",
                  item: SwapNetworks.ethereum,
                ),
                _ModelItem(
                  iconPath: "assets/wbnb_coin_icon.svg",
                  item: SwapNetworks.binance,
                ),
                _ModelItem(
                  iconPath: "assets/wqt_coin_icon.svg",
                  item: SwapNetworks.matic,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _onPressedSelectToken() {
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: _ListBottomWidget(
              onTap: (value) => store.setToken(value),
              title: 'Choose token',
              items: [
                _ModelItem(
                  item: SwapToken.tusdt,
                  iconPath: 'assets/svg/usdt_coin_icon.svg',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SelectedItem extends StatelessWidget {
  final Function()? onTap;
  final bool isSelected;
  final String? iconPath;
  final String? title;

  const _SelectedItem({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : AppColor.disabledButton,
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: AppColor.disabledButton,
          ),
        ),
        child: Row(
          children: [
            if (isSelected)
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
                    iconPath!,
                  ),
                ),
              ),
            Text(
              isSelected ? title! : 'wallet.enterCoin'.tr(),
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.black : AppColor.disabledText,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 5.5),
              child: SvgPicture.asset(
                "assets/choose_coin_icon.svg",
              ),
            )
          ],
        ),
      ),
    );
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
                                      onTap.call(item.item);
                                      Navigator.pop(context);
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
