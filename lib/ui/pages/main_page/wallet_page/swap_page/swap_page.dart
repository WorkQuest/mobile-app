import 'package:app/ui/pages/main_page/wallet_page/swap_page/store/swap_store.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
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
          if (store.isConnect && store.successData!) {
            Navigator.of(context, rootNavigator: true).pop();
            final _network = AccountRepository().notifierNetwork.value;
            if (_network == Network.mainnet) {
              AccountRepository().changeNetwork(NetworkName.workNetMainnet);
            } else if (_network == Network.testnet) {
              AccountRepository().changeNetwork(NetworkName.workNetTestnet);
            }
            store.setNetwork(null);
            _amountController.clear();
            AlertDialogUtils.showSuccessDialog(context);
          }
        },
        onFailure: () {
          if (store.isConnect) {
            Navigator.of(context, rootNavigator: true).pop('dialog');
          }
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
                  store.setNetwork(store.network!, isForce: true);
                }
                return Future.delayed(const Duration(seconds: 1));
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
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
                            if (store.isLoading) const CircularProgressIndicator.adaptive(),
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
                                    store.setNetwork(store.network!, isForce: true);
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
                          iconPath: 'assets/tusdt_coin_icon.svg',
                          isSelected: true,
                          onTap: _onPressedSelectToken,
                        ),
                        _spaceDivider,
                        Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'swap.amountBalance'.tr(namedArgs: {'maxAmount': '${store.maxAmount ?? ''}'}),
                                  style: const TextStyle(fontSize: 16, color: Colors.black),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 4,
                            ),
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
                              return "errors.fieldEmpty".tr();
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
                              _amountController.text = (store.maxAmount ?? 0.0).toString();
                            },
                          ),
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
                                  'assets/wqt_coin_icon.svg',
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
                            if (store.isSuccessCourse) Text(store.convertWQT!.toStringAsFixed(6)),
                          ],
                        ),
                        Text(
                          'swap.includesWorkNetNetwork'.tr(),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
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
        child: Observer(
          builder: (_) => DefaultButton(
            title: 'Swap',
            onPressed: store.statusSend ? _onPressedSend : null,
          ),
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

  _onPressedSend() async {
    if (_formKey.currentState!.validate()) {
      try {
        _showLoading();
        final _addressTo = Web3Utils.getAddressContractForSwap(store.network!);
        final _needApprove = await store.needApprove();
        if (_needApprove) {
          final _gasApprove = await store.getEstimateGasApprove();
          Navigator.of(context, rootNavigator: true).pop();
          AlertDialogUtils.showAlertTxConfirm(
            context,
            fee: _gasApprove,
            amount: _amountController.text,
            typeTx: 'Approve',
            tokenSymbolFee: _getTitleCoinFee(),
            addressTo: _addressTo,
            tokenSymbol: 'USDT',
            onTabOk: () async {
              print('onTabOk');
              try {
                _showLoading(message: 'Approving...');
                await store.approve();
                Navigator.of(context, rootNavigator: true).pop();
                _onPressedSend();
              } on FormatException catch (e) {
                Navigator.of(context, rootNavigator: true).pop();
                AlertDialogUtils.showInfoAlertDialog(context, title: 'meta.error'.tr(), content: e.message);
              } catch (e) {
                Navigator.of(context, rootNavigator: true).pop();
                AlertDialogUtils.showInfoAlertDialog(context, title: 'meta.error'.tr(), content: e.toString());
              }
            },
          );
          return;
        }
        final _gasSwap = await store.getEstimateGasSwap();
        Navigator.of(context, rootNavigator: true).pop();
        AlertDialogUtils.showAlertTxConfirm(
          context,
          fee: _gasSwap,
          amount: _amountController.text.isEmpty ? '0.0' : _amountController.text,
          typeTx: 'Swap',
          tokenSymbolFee: _getTitleCoinFee(),
          addressTo: _addressTo,
          tokenSymbol: 'USDT',
          onTabOk: () {
            _showLoading(message: 'Swaping...');
            store.createSwap();
          },
        );
      } on FormatException catch (e) {
        print('_onPressedSend | $e');
        Navigator.of(context, rootNavigator: true).pop();
        AlertDialogUtils.showInfoAlertDialog(context, title: 'meta.warning'.tr(), content: e.message);
      } catch (e, trace) {
        print('_onPressedSend | $e\n$trace');
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  String _getTitleCoinFee() {
    final _network =
    Web3Utils.getSwapNetworksFromNetworkName(AccountRepository().networkName.value ?? NetworkName.workNetMainnet);
    switch (_network) {
      case SwapNetworks.ETH:
        return 'ETH';
      case SwapNetworks.BSC:
        return 'BNB';
      case SwapNetworks.POLYGON:
        return 'MATIC';
      default:
        return 'WQT';
    }
  }

  _onPressedSelectNetwork() {
    BottomSheetUtils.showDefaultBottomSheet(
      context,
      child: _ListBottomWidget(
        onTap: (value) {
          store.setNetwork(value, isForce: true);
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
          _ModelItem(
              item: SwapToken.usdt, iconPath: 'assets/tusdt_coin_icon.svg'),
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
    final _isTestnet = AccountRepository().notifierNetwork.value == Network.testnet;
    if (_isTestnet) {
      return 'T${token.name}'.toUpperCase();
    }
    return token.name.toUpperCase();
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
    print('value: $value');
    print('value: ${value.runtimeType}');
    if (value is SwapToken) {
      final _isTestnet = AccountRepository().notifierNetwork.value == Network.testnet;
      if (_isTestnet) {
        return 'T${value.name}'.toUpperCase();
      }
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
