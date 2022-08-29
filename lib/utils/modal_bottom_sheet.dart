import 'package:flutter/material.dart';

class ModalBottomSheet {
  static Future<void> openModalBottomSheet(
    BuildContext context,
    Widget content, {
    double height = 200,
    EdgeInsetsGeometry? padding,
  }) async {
    await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: height,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffE9EDF2),
                  ),
                ),
                const SizedBox(
                  height: 21,
                ),
                content,
              ],
            ),
          ),
        );
      },
    );
  }
}
