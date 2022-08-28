import 'package:flutter/material.dart';

class WarningFields extends StatelessWidget {
  final bool warningEnabled;
  final String errorMessage;
  final Widget child;

  const WarningFields({
    Key? key,
    required this.child,
    required this.warningEnabled,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        if (warningEnabled)
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
      ],
    );
  }
}