import 'package:flutter/material.dart';

class TitledField extends StatelessWidget {
  final String title;
  final Widget child;

  const TitledField({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 6,
        ),
        child,
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
