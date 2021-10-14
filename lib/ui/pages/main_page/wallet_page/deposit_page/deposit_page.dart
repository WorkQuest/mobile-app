import 'package:app/ui/pages/main_page/wallet_page/bank_card_widget.dart';
import 'package:app/ui/widgets/sliver_sticky_tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
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
                walletTab(),

                ///Card Transfer
                BankCardTransaction(
                  transaction: "wallet.deposit".tr(),
                ),
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
              child: Image.asset(
                "assets/qr_code_placeholder.jpg",
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
              child: Text("0xu383d7g...dq9w"),
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
                      onPressed: () => Share.share(
                          "http://en.m.wikipedia.org"),
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
                        text: "0xu383d7g...dq9w",
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
