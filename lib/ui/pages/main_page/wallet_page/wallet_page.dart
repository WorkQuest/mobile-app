import 'package:app/ui/pages/main_page/wallet_page/transfer_page.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WalletPage extends StatefulWidget {
  static const String routeName = "/walletPage";

  const WalletPage();

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with TickerProviderStateMixin {
  AnimationController? controller;
  final List<Tx> txsList =
      List.generate(10, (index) => Tx(summa: 100, time: DateTime.now()));
  final _divider = const SizedBox(
    height: 15.0,
  );

  bool cardAvailable = false;
  final List<String> cards = ["MasterCard", " Visa"];

  @override
  initState() {
    super.initState();
    controller = BottomSheet.createAnimationController(this);
    controller!.duration = Duration(seconds: 1);
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                  child: SizedBox(
                    height: 46,
                    child: OutlinedButton(
                      onPressed: () {
                        bottomForm();
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
                    child: OutlinedButton(
                      onPressed: () {
                        bottomForm();
                      },
                      child: Text("Withdraw"),
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
                        Navigator.pushNamed(context, TransferPage.routeName);
                      },
                      child: Text("Transfer"),
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

  bottomForm() => showModalBottomSheet(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0)),
          ),
          context: context,
          transitionAnimationController: controller,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 10.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
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
                  Text("Amount"),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "0 WDX",
                          ),
                        ),
                      ),
                      Text("   =   "),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.0),
                            ),
                          ),
                          height: 50.0,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("   \$ 0")),
                        ),
                      )
                    ],
                  ),
                  _divider,
                  cardAvailable ? chooseCard() : addCard(),
                  _divider,
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Submit"),
                  ),
                  _divider,
                  //chooseCard()
                ],
              ),
            );
          }).whenComplete(() {
        controller = BottomSheet.createAnimationController(this);
      });

  /// ADD Card Widget

  Widget addCard() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Card Number",
          ),
          _divider,
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              LengthLimitingTextInputFormatter(16),
              new CardNumberInputFormatter(),
            ],
            decoration: InputDecoration(
              hintText: "0000  0000  0000  0000",
            ),
          ),
          _divider,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: titledTextBox(
                  "Date",
                  TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(4),
                      new CardDateInputFormatter(),
                    ],
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "02/24",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: titledTextBox(
                  "CVV",
                  TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(3),
                    ],
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "242",
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(value: true, onChanged: null),
              Text("Save card for next payment"),
            ],
          ),
        ],
      );

  ///CHoose Card Widget

  Widget chooseCard() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Choose Card"),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: null,
              onChanged: (String? value) {},
              items: cards.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              icon: Icon(
                Icons.arrow_drop_down,
                size: 30,
                color: Colors.blueAccent,
              ),
              hint: Text(
                '0000  0000  0000  0000',
                maxLines: 1,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
          _divider,
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                setState(() {
                  cardAvailable = true;
                });
              },
              child: Text(
                "Add another card",
                maxLines: 1,
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline),
              ),
            ),
          ),
          _divider,
        ],
      );

  Widget titledTextBox(String title, Widget textField) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
          ),
          const SizedBox(
            height: 5.0,
          ),
          Flexible(fit: FlexFit.loose, child: textField),
        ],
      );

//
// @override
// void dispose() {
//   controller!.dispose();
//   super.dispose();
// }
}

class Tx {
  late DateTime time;
  late double summa;

  Tx({required this.time, required this.summa});
}
