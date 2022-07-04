import 'package:app/ui/pages/main_page/wallet_page/swap_page/store/swap_store.dart';
import 'package:app/web3/service/address_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:majascan/majascan.dart';
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
      backgroundColor: Colors.white,
      appBar: const DefaultAppBar(
        title: 'Swap',
      ),
      body: ObserverListener<SwapStore>(
        onSuccess: () {
          Navigator.of(context, rootNavigator: true).pop('dialog');
          if (store.isSuccessCourse) {
            final _network = AccountRepository().notifierNetwork.value;
            if (_network == Network.mainnet) {
              AccountRepository().changeNetwork(NetworkName.workNetMainnet);
            } else if (_network == Network.testnet) {
              AccountRepository().changeNetwork(NetworkName.workNetTestnet);
            }
            AlertDialogUtils.showSuccessDialog(context);
          }
        },
        onFailure: () {
          Navigator.of(context, rootNavigator: true).pop('dialog');
          return false;
        },
        child: Observer(
          builder: (_) => DismissKeyboard(
            child: RefreshIndicator(
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
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                child: Padding(
                  padding: _padding,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'swap.choose'.tr(namedArgs: {'object': 'network'}),
                              style: const TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            const Spacer(),
                            if (!store.isConnect && store.errorMessage != null)
                              SizedBox(
                                height: 18,
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: Text(
                                    'meta.retry'.tr(),
                                    style: const TextStyle(color: AppColor.enabledButton),
                                  ),
                                  onPressed: () {
                                    _showLoading(
                                      message: 'swap.connecting'.tr(
                                        namedArgs: {'object': 'network'},
                                      ),
                                    );
                                    store.setNetwork(store.network!);
                                  },
                                ),
                              ),
                          ],
                        ),
                        _divider,
                        SelectedItem(
                          title: _getTitleNetwork(store.network),
                          iconPath: _getIconPathNetwork(store.network),
                          isSelected: store.network != null,
                          onTap: _onPressedSelectNetwork,
                          isCoin: false,
                        ),
                        _spaceDivider,
                        Text(
                          'swap.choose'.tr(namedArgs: {'object': 'token'}),
                          style: const TextStyle(fontSize: 16, color: Colors.black),
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
                              'swap.amountBalance'.tr(namedArgs: {'maxAmount': '${store.maxAmount ?? 0.0}'}),
                              style: const TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            if (store.isConnect)
                              SizedBox(
                                height: 18,
                                child: CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: Text(
                                    'meta.update'.tr(),
                                    style: const TextStyle(
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
                          hint: 'wallet.amount'.tr(),
                          enabled: store.isConnect,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null) {
                              return "errors.fieldEmpty".tr();
                            }
                            try {
                              final val = double.parse(value);
                              if (val < 5.0) {
                                return 'swap.minimum'.tr();
                              }
                              if (val > 100.0) {
                                return 'swap.maximum'.tr();
                              }
                              if (store.maxAmount != null) {
                                if (store.maxAmount! < val) {
                                  return 'errors.higherMaxAmount'.tr();
                                }
                              }
                            } catch (e) {
                              return "errors.incorrectFormat".tr();
                            }
                            return null;
                          },
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,18}')),
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
                                  AddressService.hexToBech32(AccountRepository().userWallet!.address!);
                            },
                          ),
                        ),
                        _spaceDivider,
                        Text(
                          'swap.addressWalletTo'.tr(),
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        _divider,
                        DefaultTextField(
                          enableDispose: false,
                          controller: _addressToController,
                          hint: 'swap.addressTo'.tr(),
                          enabled: store.isConnect,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                  scanAreaScale: 0.7

                                  /// value 0.0 to 1.0
                                  );
                              if (qrResult != null) {
                                _addressToController.text = qrResult;
                              }
                            },
                            child: SvgPicture.asset(
                              'assets/svg/scan_qr.svg',
                              color: AppColor.enabledButton,
                            ),
                          ),
                          validator: (value) {
                            if (value != null) {
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
                            }
                            return null;
                          },
                          inputFormatters: [],
                        ),
                        _spaceDivider,
                        Row(
                          children: [
                            Text('swap.amountOfWQT'.tr()),
                            const SizedBox(
                              width: 2,
                            ),
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
                                width: 18,
                                height: 18,
                                child: SvgPicture.asset(
                                  'assets/svg/wqt_coin_icon.svg',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            const Text('≈'),
                            const SizedBox(
                              width: 2,
                            ),
                            if (store.isLoadingCourse)
                              const SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            if (store.isSuccessCourse) Text(store.convertWQT.toString()),
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
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
        child: DefaultButton(
          title: 'meta.send'.tr(),
          onPressed: _onPressedSend,
        ),
      ),
    );
  }

  _showLoading({bool start = false, String? message}) {
    if (start) {
      Future.delayed(const Duration(milliseconds: 150)).then(
        (value) => AlertDialogUtils.showLoadingDialog(context, message: message),
      );
    } else {
      AlertDialogUtils.showLoadingDialog(context, message: message);
    }
  }

  _onPressedSend() {
    if (_formKey.currentState!.validate()) {
      _showLoading(message: 'swap.buying'.tr());
      final _isBech = _addressToController.text.substring(0, 2).toLowerCase() == 'wq';
      store.createSwap(_isBech ? AddressService.bech32ToHex(_addressToController.text) : _addressToController.text);
    }
  }

  _onPressedSelectNetwork() {
    BottomSheetUtils.showDefaultBottomSheet(
      context,
      child: _ListBottomWidget(
        onTap: (value) {
          store.setNetwork(value);
          _showLoading(
            message: 'swap.connecting'.tr(
              namedArgs: {'object': 'server'},
            ),
          );
        },
        title: 'swap.choose'.tr(namedArgs: {'object': 'network'}),
        items: [
          _ModelItem(iconPath: 'assets/eth_logo.svg', item: SwapNetworks.ETH),
          _ModelItem(iconPath: 'assets/bsc_logo.svg', item: SwapNetworks.BSC),
          _ModelItem(iconPath: 'assets/polygon_logo.svg', item: SwapNetworks.POLYGON),
        ],
      ),
    );
  }

  _onPressedSelectToken() {
    BottomSheetUtils.showDefaultBottomSheet(
      context,
      child: _ListBottomWidget(
        onTap: (value) => store.setToken(value),
        title: 'swap.choose'.tr(namedArgs: {'object': 'token'}),
        items: [
          _ModelItem(item: SwapToken.tusdt, iconPath: 'assets/usdt_coin_icon.svg'),
        ],
      ),
    );
  }

  _getTitleNetwork(SwapNetworks? network) {
    switch (network) {
      case SwapNetworks.ETH:
        return 'Ethereum';
      case SwapNetworks.BSC:
        return 'Binance Smart Chain';
      case SwapNetworks.POLYGON:
        return 'POLYGON';
      default:
        return 'swap.choose'.tr(namedArgs: {'object': 'network'});
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

  _getIconPathNetwork(SwapNetworks? network) {
    switch (network) {
      case SwapNetworks.ETH:
        return 'assets/eth_logo.svg';
      case SwapNetworks.BSC:
        return 'assets/bsc_logo.svg';
      case SwapNetworks.POLYGON:
        return 'assets/polygon_logo.svg';
      default:
        return '';
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
        case SwapNetworks.ETH:
          return 'Ethereum';
        case SwapNetworks.BSC:
          return 'Binance Smart Chain';
        case SwapNetworks.POLYGON:
          return 'Polygon';
      }
    }
    return '';
  }
}
