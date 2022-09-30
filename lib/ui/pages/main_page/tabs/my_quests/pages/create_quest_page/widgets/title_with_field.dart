import 'package:flutter/material.dart';

class TitleWithField extends StatelessWidget {
  final String title;
  final Widget child;

  const TitleWithField(this.title, this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ),
        child,
      ],
    );
  }
}
