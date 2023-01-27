import 'package:app/constants.dart';
import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:app/ui/widgets/default_app_bar.dart';
import 'package:app/ui/widgets/default_radio.dart';
import 'package:app/ui/widgets/layout_with_scroll.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/storage.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/http/web_socket.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0);

const _networks = Network.values;

class NetworkPage extends StatefulWidget {
  static const routeName = '/networkPage';
  const NetworkPage({Key? key}) : super(key: key);

  @override
  _NetworkPageState createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  late final Network network;

  @override
  void initState() {
    network = AccountRepository().notifierNetwork.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(
        title: 'wallet.network'.tr(),
      ),
      body: Observer(
        builder: (_) => LayoutWithScroll(
          child: Padding(
            padding: _padding,
            child: Column(
              children: _networks.map((network) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () => _onPressedChange(network),
                      child: ColoredBox(
                        color: Colors.transparent,
                        child: SizedBox(
                          height: 36,
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              DefaultRadio(
                                status: this.network == network,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                _getName(network.name),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColor.subtitleText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  String _getName(String name) {
    return '${name.substring(0, 1).toUpperCase()}${name.substring(1)}';
  }

  _onPressedChange(Network newNetwork) {
    if (this.network != newNetwork) {
      _showAlertConfirmChangeNetwork(newNetwork);
    }
  }

  _showAlertConfirmChangeNetwork(Network network) {
    AlertDialogUtils.showAlertDialog(
      context,
      title: Text('modals.warning'.tr()),
      content: Text('wallet.changeNetworkInfo'.tr()),
      needCancel: true,
      titleCancel: null,
      titleOk: 'meta.confirm'.tr(),
      onTabCancel: null,
      onTabOk: () => _pushToLogin(network),
      colorCancel: AppColor.enabledButton,
      colorOk: Colors.red,
    );
  }

  _pushToLogin(Network network) async {
    WebSocket().closeWebSocket();
    final _networkName =
        Web3Utils.getNetworkNameSwap(AccountRepository().networkName.value!);
    AccountRepository().clearData();
    AccountRepository().notifierNetwork.value = network;
    AccountRepository().networkName.value = _networkName;
    Storage.write(StorageKeys.networkName.name, _networkName.name);
    await Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      SignInPage.routeName,
      (route) => false,
    );
  }
}
