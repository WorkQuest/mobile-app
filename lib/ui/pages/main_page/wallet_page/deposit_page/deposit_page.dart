import 'package:app/ui/pages/main_page/wallet_page/bank_card_widget.dart';
import 'package:app/ui/pages/main_page/wallet_page/deposit_page/store/deposit_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/store/wallet_store.dart';
import 'package:app/ui/widgets/sliver_sticky_tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import "package:provider/provider.dart";

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
  }

  @override
  Widget build(BuildContext context) {
    final depositStore = context.read<DepositStore>();
    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        middle: Text("Deposit"),
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
                        "Wallet address",
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Bank card",
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
                  transaction: "Deposit",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget walletTab() => Padding(
        padding: const EdgeInsets.all(10.0),
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
            Text('Scan QR Code or copy address to receive payments'),
            const SizedBox(
              height: 15.0,
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
                      onPressed: () {},
                      child: Text("Share"),
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
                    onPressed: () =>
                        Clipboard.setData(new ClipboardData(text: "email"))
                            .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(
                            "Wallet address copied to clipboard",
                          ),
                        ),
                      );
                    }),
                    child: Text("Copy"),
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

  Widget titledTextBox(String title, Widget textField) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
          ),
          _divider,
          Flexible(
            fit: FlexFit.loose,
            child: textField,
          ),
        ],
      );
}
