import 'package:flutter/material.dart';

class LevelCard extends StatelessWidget {
  final int value;
  final int groupValue;
  final Function(int?)? onChanged;
  final Color color;
  final String price;
  final String level;
  final String description;

  const LevelCard({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.color,
    required this.price,
    required this.level,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(6.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          RadioListTile(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: color,
                  ),
                  child: Text(
                    level,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Spacer(),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(description),
          ),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}
