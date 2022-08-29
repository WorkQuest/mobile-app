
import 'package:flutter/material.dart';

class CardOptionsWidget extends StatelessWidget {
  final List<Widget> children;

  const CardOptionsWidget({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFF7F8FA),
      borderRadius: BorderRadius.circular(6.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}