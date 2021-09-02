import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';

Future dialog(
  BuildContext context, {
  required String title,
  required String message,
  required Function() confirmAction,
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
                  child: Text('meta.confirm'.tr()),
                  onPressed: confirmAction,
                ),
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context),
                  child: Text('meta.cancel'.tr()),
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
                  onPressed: confirmAction,
                  child: Text('meta.confirm'.tr()),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('meta.cancel'.tr()),
                ),
              ],
            ),
          );
