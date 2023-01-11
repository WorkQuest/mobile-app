import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';

final TextStyle valueTextStyle = TextStyle(
  fontSize: 15.0,
  color: Color(0xFF7C838D),
);
final TextStyle titleTextStyle = TextStyle(
  fontSize: 17.0,
);

Future confirmTransaction(
  BuildContext context, {
  required String transaction,
  required String address,
  required String amount,
  required String fee,
}) =>
    Platform.isIOS
        ? showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text(
                transaction,
                style: TextStyle(fontSize: 18.0),
              ),
              content: content(
                transaction: transaction,
                amount: amount,
                address: address,
                fee: fee,
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text('meta.confirm'.tr()),
                ),
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context),
                  child: Text('meta.cancel'.tr()),
                ),
              ],
            ),
          )
        : showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(transaction),
              content: content(
                transaction: transaction,
                amount: amount,
                address: address,
                fee: fee,
              ),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: Text('meta.confirm'.tr()),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('meta.cancel'.tr()),
                ),
              ],
            ),
          );

Widget content({
  required String transaction,
  required String address,
  required String amount,
  required String fee,
}) =>
    Container(
      width: 300,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Recipient's address",
            style: titleTextStyle,
          ),
          Text(
            "$address",
            style: valueTextStyle,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            "modals.amount".tr(),
            style: titleTextStyle,
          ),
          Text(
            "$amount WUSD",
            style: valueTextStyle,
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            "Transaction fee",
            style: titleTextStyle,
          ),
          Text(
            "\$ $fee",
            style: valueTextStyle,
          ),
        ],
      ),
    );
