import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PayPeriodView extends StatelessWidget {
  const PayPeriodView(this.period);

  final String period;

  @override
  Widget build(BuildContext context) {
    final text = period[0].toLowerCase() + period.substring(1);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0xFFD8DFE3),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        "quests.payPeriod.$text".tr(),
        style: TextStyle(
          color: Color(0xFF1D2127),
        ),
      ),
    );
  }
}
