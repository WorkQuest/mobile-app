import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class TimerWidget extends StatelessWidget {
  final Function() startTimer;
  final bool isActiveTimer;
  final int seconds;

  const TimerWidget({
    Key? key,
    required this.isActiveTimer,
    required this.startTimer,
    required this.seconds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(
            'Send again',
            style: TextStyle(
              fontSize: 14,
              color: isActiveTimer
                  ? AppColor.disabledText
                  : AppColor.enabledButton,
            ),
          ),
          onPressed: isActiveTimer ? null : startTimer,
        ),
        const SizedBox(
          width: 10,
        ),
        if (isActiveTimer)
          Text(
            convertSecondToLine(seconds),
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
      ],
    );
  }

  String convertSecondToLine(int seconds) {
    int min = seconds ~/ 60;
    int sec = seconds - (min * 60);
    return '${min < 10 ? '0$min' : '$min'}:${sec < 10 ? '0$sec' : '$sec'}';
  }
}
