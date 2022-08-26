import 'package:app/ui/widgets/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class BottomSheetWidget extends StatelessWidget {
  final List<Widget> children;

  const BottomSheetWidget({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: DismissKeyboard(
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
                const SizedBox(height: 21),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'wallet.chooseCoin'.tr(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16.5),
                    ...children,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
