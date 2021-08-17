import 'package:app/ui/pages/main_page/wallet_page/bank_card_widget.dart';
import 'package:app/ui/pages/main_page/wallet_page/withdraw_page/store/withdraw_page_store.dart';
import 'package:app/ui/widgets/sliver_sticky_tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";

import '../confirm_transaction_dialog.dart';

final _divider = const SizedBox(
  height: 5.0,
);

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({Key? key}) : super(key: key);
  static const String routeName = "/withdrawPage";

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage>
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
    final withdrawStore = context.read<WithdrawPageStore>();
    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        middle: Text("Withdraw"),
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
            child: TabBarView(
              controller: this._tabController,
              children: [
                ///Wallet Transfer
                walletTab(withdrawStore),
                ///Card Transfer
                BankCardTransaction(
                  transaction: " Withdraw",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget walletTab(WithdrawPageStore withdrawStore) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Observer(
          builder:(context)=> Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Recipient's address"),
              _divider,
              TextFormField(
                onChanged: withdrawStore.setRecipientAddress,
                decoration: InputDecoration(
                  hintText: "Enter Address",
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Text('Amount'),
              _divider,
              TextFormField(
                onChanged: withdrawStore.setAmount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "0 WDX",
                  suffixIcon: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Max",
                      style: TextStyle(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: withdrawStore.canSubmit
                    ? () => confirmTransaction(
                  context,
                  transaction: "Withdraw",
                  address: withdrawStore.getAddress(),
                  amount: withdrawStore.getAmount(),
                  fee: "0.15",
                )
                    : null,
                child: Text("Withdraw"),
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      );

}
