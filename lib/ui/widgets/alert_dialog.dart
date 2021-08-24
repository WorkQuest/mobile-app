import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter/material.dart';

Future dialog(
  BuildContext context, {
  required String title,
  required String message,
  bool barrierDismissible = true,
}) =>
    Platform.isIOS
        ? showCupertinoDialog(
            barrierDismissible: barrierDismissible,
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              content: Text(message),
              actions: [
                CupertinoDialogAction(
                  child: Text('Confirm'),
                ),
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ],
            ),
          )
        : showDialog(
            barrierDismissible: barrierDismissible,
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(title),
              content: Container(),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: Text('Confirm'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ],
            ),
          );
