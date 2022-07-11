import 'package:flutter/material.dart';

class DropdownCard extends StatefulWidget {
  final DropdownButton child;

  const DropdownCard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _DropdownCardState createState() => _DropdownCardState();
}

class _DropdownCardState extends State<DropdownCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButtonHideUnderline(
          child: widget.child,
        ),
      ),
    );
  }
}
