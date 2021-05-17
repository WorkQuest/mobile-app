import 'dart:async';

import 'package:app/work_quest_app.dart';
import 'package:flutter/material.dart';

enum ItemType {
  Active,
  Invited,
  Performed,
  Starred,
}

class MyQuestsItem extends StatelessWidget {
  const MyQuestsItem(this.itemType);

  final itemType;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColors.green,
            ),
            child: Row(
              children: [
                Text(
                  itemType.toString().split(".").last,
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                Text(
                  "Runtime",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 10,
                ),
                OtpTimer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OtpTimer extends StatefulWidget {
  @override
  _OtpTimerState createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 60;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int? milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) timer.cancel();
      });
    });
  }

  @override
  void initState() {
    startTimeout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      timerText,
      style: TextStyle(color: Colors.white),
    );
  }
}
