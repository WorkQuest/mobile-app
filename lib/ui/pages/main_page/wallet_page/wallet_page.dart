import 'package:app/ui/pages/main_page/wallet_page/confirm_transaction_dialog.dart';
import 'package:app/ui/pages/main_page/wallet_page/deposit_page/deposit_page.dart';
import 'package:app/ui/pages/main_page/wallet_page/store/wallet_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/withdraw_page/withdraw_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "package:provider/provider.dart";

final List<Tx> txsList =
    List.generate(10, (index) => Tx(summa: 100, time: DateTime.now()));
final _divider = const SizedBox(
  height: 15.0,
);

class WalletPage extends StatelessWidget {
  static const String routeName = "/walletPage";

  @override
  Widget build(context) {
    final walletStore = context.read<WalletStore>();
    return Scaffold(
      body: Observer(
        builder: (context) => CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: Text(
                "Wallet",
              ),
              automaticallyImplyLeading: false,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 30,
                  bottom: 20,
                ),
                child: Row(
                  children: [
                    Text(
                      "0xu383d7g...dq9w",
                      style: TextStyle(
                        color: Color(0xFF7C838D),
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: InkWell(
                        onTap: () => Clipboard.setData(
                          new ClipboardData(
                            text: "email",
                          ),
                        ).then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(
                                seconds: 1,
                              ),
                              content: Text(
                                "Wallet address copied to clipboard",
                              ),
                            ),
                          );
                        }),
                        child: SvgPicture.asset("assets/copy_icon.svg"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color(0xFFF7F8FA),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Balance",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "1 600 WUSD",
                        style: TextStyle(
                            color: Color(0xFF0083C7),
                            fontSize: 25,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "\$ 120.34",
                        style: TextStyle(
                          color: Color(0xFFAAB0B9),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 20,
                  bottom: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: OutlinedButton(
                          onPressed: () => bottomForm(
                            context,
                            walletStore,
                          ),
                          child: Text("Transfer"),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 1.0,
                              color: Color(0xFF0083C7).withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(DepositPage.routeName);
                          },
                          child: Text("Deposit"),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 1.0,
                              color: Color(0xFF0083C7).withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(WithdrawPage.routeName);
                          },
                          child: Text("Withdraw"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 6,
                width: MediaQuery.of(context).size.width,
                color: Color(0xFFF7F8FA),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Transaction",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children:
                    txsList.map((e) => txItem(e.time.toString())).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget txItem(String time) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Color(0xFF00AA5B).withOpacity(0.1),
                shape: BoxShape.circle),
            child: SvgPicture.asset("assets/send_tx_arrow_icon.svg"),
          ),
          const SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Send"),
              const SizedBox(
                height: 4,
              ),
              Text(
                "14.01.20  14:34",
                style: TextStyle(
                  color: Color(0xFFAAB0B9),
                ),
              )
            ],
          ),
          Spacer(),
          Text(
            "+1500 WUSD",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF00AA5B),
            ),
          )
        ],
      ),
    );
  }

  ///Transfer Widget
  bottomForm(
    BuildContext context,
    WalletStore store,
  ) =>
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
          ),
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Observer(
              builder: (context) => Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 10.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 5.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                    _divider,
                    Text("Recipient's address"),
                    _divider,
                    TextFormField(
                      onChanged: store.setRecipientAddress,
                      decoration: InputDecoration(
                        hintText: "Enter Address",
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const Text('Amount'),
                    _divider,
                    TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      onChanged: store.setAmount,
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
                    _divider,
                    ElevatedButton(
                      onPressed: store.canSubmit
                          ? () => confirmTransaction(
                                context,
                                transaction: "Transfer",
                                address: store.getAddress(),
                                amount: store.getAmount(),
                                fee: "0.15",
                              )
                          : null,
                      child: const Text("Transfer"),
                    ),
                    _divider,
                  ],
                ),
              ),
            );
          }).then((value) => store.clearValues());
}

class Tx {
  late DateTime time;
  late double summa;

  Tx({required this.time, required this.summa});
}
