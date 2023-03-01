import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';

final _divider = const SizedBox(
  height: 5.0,
);

class BankCardTransaction extends StatefulWidget {
  const BankCardTransaction({required this.transaction});

  final String transaction;

  @override
  _BankCardTransactionState createState() => _BankCardTransactionState();
}

class _BankCardTransactionState extends State<BankCardTransaction> {
  bool _expanded = true;
  int _groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Row(
              children: [
                Text(
                  "modals.chooseCard".tr(),
                ),
                Spacer(),
                TextButton(
                  onPressed: () => bottomForm(
                    context,
                  ),
                  child: Text(
                    "wallet.addCard".tr(),
                  ),
                ),
              ],
            ),
            ExpansionPanelList(
              elevation: 0,
              children: [
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) {
                    return SizedBox(
                      height: 50.0,
                      child: ListTile(
                        title: Text(
                          "modals.chooseCard".tr(),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                  body: Column(
                    children: [
                      RadioListTile(
                        title: Text(
                          'Card 1',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _groupValue = 1;
                          });
                        },
                        groupValue: _groupValue,
                        value: 1,
                      ),
                      RadioListTile(
                        title: Text(
                          'Card 2',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _groupValue = 2;
                          });
                        },
                        groupValue: _groupValue,
                        value: 2,
                      ),
                      RadioListTile(
                        toggleable: true,
                        title: Text(
                          'Card 3',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _groupValue = 3;
                          });
                        },
                        groupValue: _groupValue,
                        value: 3,
                      ),
                    ],
                  ),
                  isExpanded: _expanded,
                  canTapOnHeader: true,
                ),
              ],
              dividerColor: Colors.grey,
              expansionCallback: (panelIndex, isExpanded) {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
            Text(
              "referral.tableHead.amount".tr(),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "0 WDX",
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                ),
                Text("   =   "),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFFF7F8FA),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                    ),
                    height: 50.0,
                    child: Text(r"   $ 0"),
                  ),
                )
              ],
            ),
            _divider,
            titledTextBox(
              "wallet.table.trx".tr(),
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFF7F8FA),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                ),
                height: 50.0,
                child: Text(r"   $ 0"),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            titledTextBox(
              "wallet.time".tr(),
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFF7F8FA),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                ),
                height: 50.0,
                child: Text("   5 mins"),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            //Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: Text(widget.transaction),
            ),
          ],
        ),
      ),
    );
  }

  bottomForm(
    BuildContext context,
  ) =>
      showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SafeArea(
            child: Padding(
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
                  Text(
                    "wallet.bankCard".tr(),
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
                  titledTextBox(
                    "modals.cardHolder".tr(),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "labels.firstName".tr() + " ",
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: titledTextBox(
                          "modals.date".tr(),
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]'),
                              ),
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
                          "modals.cvv".tr(),
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9]'),
                              ),
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
                  _divider,
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "modals.addCard".tr(),
                    ),
                  ),
                  _divider,
                ],
              ),
            ),
          );
        },
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
