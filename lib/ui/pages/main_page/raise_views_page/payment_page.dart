import 'package:app/ui/pages/main_page/raise_views_page/store/raise_views_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/bank_card_widget.dart';
import 'package:app/ui/widgets/sliver_sticky_tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";

final _divider = const SizedBox(
  height: 5.0,
);

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key,}) : super(key: key);
  static const String routeName = "/paymentPage";

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage>
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
    final raiseViewStore = context.read<RaiseViewStore>();

    return Scaffold(
      appBar: CupertinoNavigationBar(
        automaticallyImplyLeading: true,
        middle: Text("Payment"),
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
                        "Crypto address",
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
                walletTab(raiseViewStore),

                ///Card Transfer
                BankCardTransaction(
                  transaction: "Pay",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget walletTab(RaiseViewStore store) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Observer(
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Crypto address"),
              _divider,
              ExpansionPanelList(
                elevation: 0,
                children: [
                  ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return SizedBox(
                        height: 50.0,
                        child: ListTile(
                          title: Text(
                            'WQT ',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    },
                    body: Column(
                      children: [
                        RadioListTile(
                          title: Text(
                            'Card 1',
                            style: TextStyle(color: Colors.black),
                          ),
                          onChanged: (value) {
                            // setState(() {
                            //   _groupValue = 1;
                            // });
                          },
                          groupValue: 1,
                          value: 1,
                        ),
                      ],
                    ),
                    isExpanded: false,
                    canTapOnHeader: true,
                  ),
                ],
                dividerColor: Colors.grey,
                expansionCallback: (panelIndex, isExpanded) {
                  // setState(() {
                  //   _expanded = !_expanded;
                  // });
                },
              ),
              const SizedBox(
                height: 15.0,
              ),
              Text('Wallet'),
              _divider,
              ExpansionPanelList(
                elevation: 0,
                children: [
                  ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return SizedBox(
                        height: 50.0,
                        child: ListTile(
                          title: Text(
                            'Coin Payments ',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      );
                    },
                    body: Column(
                      children: [
                        RadioListTile(
                          title: Text(
                            'Card 1',
                            style: TextStyle(color: Colors.black),
                          ),
                          onChanged: (value) {
                            // setState(() {
                            //   _groupValue = 1;
                            // });
                          },
                          groupValue: 1,
                          value: 1,
                        ),
                      ],
                    ),
                    isExpanded: false,
                    canTapOnHeader: true,
                  ),
                ],
                dividerColor: Colors.grey,
                expansionCallback: (panelIndex, isExpanded) {
                  // setState(() {
                  //   _expanded = !_expanded;
                  // });
                },
              ),
              Spacer(),
              ElevatedButton(
                onPressed: null,
                // onPressed: withdrawStore.canSubmit
                //     ? () => confirmTransaction(
                //           context,
                //           transaction: "Withdraw",
                //           address: withdrawStore.getAddress(),
                //           amount: withdrawStore.getAmount(),
                //           fee: "0.15",
                //         )
                //     : null,
                child: Text("Pay"),
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      );

  Widget titledTextBox(
    String title,
    Widget textField,
  ) =>
      Column(
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
