import 'package:app/constants.dart';
import 'package:app/ui/pages/main_page/wallet_page/deposit_page/deposit_bank_card.dart';
import 'package:app/ui/widgets/default_button.dart';
import 'package:app/ui/widgets/sliver_sticky_tab_bar.dart';
import 'package:app/ui/widgets/switch_format_address_widget.dart';
import 'package:app/utils/snack_bar.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:app/web3/service/address_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';

final _divider = const SizedBox(
  height: 5.0,
);

class DepositPage extends StatefulWidget {
  const DepositPage({Key? key}) : super(key: key);
  static const String routeName = "/depositPage";

  @override
  _DepositPageState createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 2,
    );
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        middle: Text("wallet.deposit".tr()),
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
                        "wallet.cryptoWallet".tr(),
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
            //hasScrollBody: true,
            child: TabBarView(
              controller: this._tabController,
              children: [
                ///Wallet Transfer
                const _WalletAddress(),
                const DepositBankCard(),

                ///Card Transfer
                // BankCardTransaction(
                //   transaction: "wallet.deposit".tr(),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget walletTab() => Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: QrImage(
                data: AccountRepository().userAddress,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            _divider,
            Text(
              "wallet.scanQr".tr(),
              style: TextStyle(
                color: Color(0xFF7C838D),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              width: double.maxFinite,
              height: 45.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  6.0,
                ),
                border: Border.all(
                  width: 2.0,
                  color: Colors.black45.withOpacity(0.1),
                ),
              ),
              child: Text(
                '${AccountRepository().userAddress.substring(0, 9)}...'
                '${AccountRepository().userAddress.substring(AccountRepository().userAddress.length - 3, AccountRepository().userAddress.length)}',
              ),
            ),
            Spacer(),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 43.0,
                    child: OutlinedButton(
                      onPressed: () =>
                          Share.share(AccountRepository().userAddress),
                      child: Text(
                        "sharing.title".tr(),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          width: 2.0,
                          color: Color(0xFF0083C7).withOpacity(0.1),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Clipboard.setData(
                      new ClipboardData(
                        text: AccountRepository().userAddress,
                      ),
                    ).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(
                            "wallet.copy".tr(),
                          ),
                        ),
                      );
                    }),
                    child: Text(
                      "modals.copy".tr(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      );
}

class _WalletAddress extends StatefulWidget {
  const _WalletAddress({Key? key}) : super(key: key);

  @override
  _WalletAddressState createState() => _WalletAddressState();
}

class _WalletAddressState extends State<_WalletAddress> {
  late FormatAddress _format;

  @override
  void initState() {
    _format = AccountRepository().isOtherNetwork
        ? FormatAddress.HEX
        : FormatAddress.BECH32;
    super.initState();
  }

  String get address {
    return _format == FormatAddress.BECH32
        ? AddressService.hexToBech32(AccountRepository().userWallet!.address!)
        : AccountRepository().userWallet!.address!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            QrImage(
              data: address,
              version: QrVersions.auto,
              size: 206,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'wallet.scanQr'.tr(),
              style: const TextStyle(
                fontSize: 16,
                color: AppColor.subtitleText,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (!AccountRepository().isOtherNetwork)
              SwitchFormatAddressWidget(
                format: _format,
                onChanged: (FormatAddress value) {
                  setState(() {
                    _format = value;
                  });
                },
              ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(vertical: 12.5, horizontal: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: AppColor.disabledButton,
                ),
              ),
              child: Text(
                '${address.substring(0, 7)}...${address.substring(address.length - 7, address.length)}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          right: 16.0,
          left: 16.0,
          bottom: MediaQuery.of(context).padding.bottom + 10,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                pressedOpacity: 0.2,
                onPressed: _sharePressed,
                child: Container(
                  height: 43,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    'sharing.title'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColor.enabledButton,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: DefaultButton(
                title: 'modals.copy'.tr(),
                onPressed: () => _copyPressed(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _sharePressed() {
    Share.share(address);
  }

  void _copyPressed(BuildContext context) {
    Clipboard.setData(ClipboardData(text: address));
    SnackBarUtils.success(
      context,
      title: 'wallet.copy'.tr(),
      duration: const Duration(milliseconds: 500),
    );
  }
}
