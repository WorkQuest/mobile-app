import 'dart:io';

import 'package:app/ui/widgets/success_alert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogUtils {
  static Future<void> showSuccessDialog(BuildContext context, {String text = 'Success'}) async {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SuccessDialog(),
        const SizedBox(
          height: 15,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        )
      ],
    );
    await showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(
          const Duration(seconds: 1),
          () {
            Navigator.pop(context);
          },
        );
        return CupertinoAlertDialog(
          content: content,
        );
      },
    );
  }

  static Future<void> showLoadingDialog(BuildContext context, {String? message}) async {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator.adaptive(),
        const SizedBox(
          height: 15,
          width: 15,
        ),
        Text(
          message ?? '${'uploader.loading'.tr()}...',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        )
      ],
    );
    if (Platform.isIOS) {
      await showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CupertinoAlertDialog(
            content: content,
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 100),
            clipBehavior: Clip.hardEdge,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            content: content,
          );
        },
      );
    }
  }

  static Future<void> showInfoAlertDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) async {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(title),
                content: Text(content),
                actions: [
                  CupertinoDialogAction(
                    child: const Text("OK"),
                    onPressed: Navigator.of(context, rootNavigator: true).pop,
                  )
                ],
              )
            : AlertDialog(
                title: Text(title),
                content: Text(content),
                actions: [
                  CupertinoDialogAction(
                    child: const Text("OK"),
                    onPressed: Navigator.of(context, rootNavigator: true).pop,
                  )
                ],
              );
      },
    );
  }

  static Future<void> showAlertDialog(
    BuildContext context, {
    required Widget title,
    required Widget? content,
    required bool needCancel,
    required String? titleCancel,
    required String? titleOk,
    required Function()? onTabCancel,
    required Function()? onTabOk,
    required Color? colorCancel,
    required Color? colorOk,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        if (Platform.isIOS) {
          return SizedBox(
            child: CupertinoAlertDialog(
              title: title,
              content: Card(
                color: Colors.transparent,
                elevation: 0.0,
                child: content,
              ),
              actions: [
                if (needCancel)
                  CupertinoButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (onTabCancel != null) {
                        onTabCancel.call();
                      }
                    },
                    child: Text(
                      titleCancel ?? 'meta'.tr(gender: 'cancel'),
                      style: TextStyle(color: colorCancel ?? Colors.black),
                    ),
                  ),
                CupertinoButton(
                  onPressed: () async {
                    if (onTabOk != null) {
                      await onTabOk.call();
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    titleOk ?? 'Ok',
                    style: TextStyle(color: colorOk ?? Colors.black),
                  ),
                ),
              ],
            ),
          );
        }
        return AlertDialog(
          scrollable: true,
          title: title,
          content: content,
          actions: [
            if (needCancel)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (onTabCancel != null) {
                    onTabCancel.call();
                  }
                },
                child: Text(
                  titleCancel ?? 'meta'.tr(gender: 'cancel'),
                  style: TextStyle(color: colorCancel ?? Colors.black),
                ),
              ),
            TextButton(
              onPressed: () async {
                if (onTabOk != null) {
                  await onTabOk.call();
                }
                Navigator.pop(context);
              },
              child: Text(
                titleOk ?? 'Ok',
                style: TextStyle(color: colorOk ?? Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
