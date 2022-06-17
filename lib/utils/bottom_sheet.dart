import 'package:flutter/material.dart';

class BottomSheetUtils {
  static void showDefaultBottomSheet(
    BuildContext context, {
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: child,
          ),
        );
      },
    );
  }
}
