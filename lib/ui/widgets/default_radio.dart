import 'package:flutter/material.dart';

import '../../constants.dart';

const _unselectedColor = Color(0xffE9EDF2);

class DefaultRadio extends StatelessWidget {
  final bool status;

  const DefaultRadio({
    Key? key,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 25,
      height: 25,
      padding: EdgeInsets.all(status ? 6.5 : 12.5),
      decoration: BoxDecoration(
        border: Border.all(
          color: status ? AppColor.enabledButton : _unselectedColor,
        ),
        shape: BoxShape.circle,
      ),
      duration: const Duration(
        milliseconds: 250,
      ),
      child: Container(
        width: 12.5,
        height: 12.5,
        decoration: const BoxDecoration(
          color: AppColor.enabledButton,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
