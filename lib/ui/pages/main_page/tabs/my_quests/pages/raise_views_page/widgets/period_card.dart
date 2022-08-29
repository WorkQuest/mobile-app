import 'package:flutter/material.dart';

class PeriodCard extends StatelessWidget {
  final String period;
  final int value;
  final int groupValue;
  final Function(int?)? onChanged;

  const PeriodCard({
    Key? key,
    required this.period,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(6.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: RadioListTile(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        contentPadding: EdgeInsets.zero,
        title: Text(
          period,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
