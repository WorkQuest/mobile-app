import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WalletPage extends StatefulWidget {
  static const String routeName = "/walletPage";

  const WalletPage();

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final List<Tx> txsList =
      List.generate(10, (index) => Tx(summa: 100, time: DateTime.now()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    return CustomScrollView(
      slivers: [
        CupertinoSliverNavigationBar(
          largeTitle: Text(
            "Wallet",
          ),
          automaticallyImplyLeading: false,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 20),
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
                  child: SvgPicture.asset("assets/copy_icon.svg"),
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
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text("Withdraw"),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        width: 1.0,
                        color: Color(0xFF0083C7).withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Deposit"),
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
            children: txsList.map((e) => txItem(e.time.toString())).toList(),
          ),
        ),
      ],
    );
  }

  Widget txItem(String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
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
                style: TextStyle(color: Color(0xFFAAB0B9)),
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
}

class Tx {
  late DateTime time;
  late double summa;

  Tx({required this.time, required this.summa});
}
