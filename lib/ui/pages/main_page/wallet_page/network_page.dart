import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../../web3/repository/account_repository.dart';
import '../../../widgets/default_app_bar.dart';
import '../../../widgets/layout_with_scroll.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0);

const _networks = ConfigNameNetwork.values;

class NetworkPage extends StatefulWidget {
  static const String routeName = "/networkPage";

  const NetworkPage({Key? key}) : super(key: key);

  @override
  _NetworkPageState createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  late ConfigNameNetwork _currentNetwork;

  @override
  void initState() {
    _currentNetwork = AccountRepository().configName!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(
        title: 'wallet.network'.tr(),
      ),
      body: LayoutWithScroll(
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
                            AnimatedContainer(
                              width: 25,
                              height: 25,
                              padding: EdgeInsets.all(
                                _currentNetwork == network ? 6.5 : 12.5,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: _currentNetwork == network
                                      ? AppColor.enabledButton
                                      : Color(0xffE9EDF2),
                                ),
                                shape: BoxShape.circle,
                              ),
                              duration: const Duration(
                                milliseconds: 250,
                              ),
                              child: Container(
                                width: 12.5,
                                height: 12.5,
                                decoration: const BoxDecoration(
                                  color: AppColor.enabledButton,
                                  shape: BoxShape.circle,
                                ),
                              ),
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
    );
  }

  String _getName(String name) {
    return '${name.substring(0, 1).toUpperCase()}${name.substring(1)}';
  }

  _onPressedChange(ConfigNameNetwork network) {
    setState(() {
      _currentNetwork = network;
    });
    AccountRepository().changeNetwork(_currentNetwork);
  }
}
