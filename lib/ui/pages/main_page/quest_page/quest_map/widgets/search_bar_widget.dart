import 'package:flutter/material.dart';

class SearchBarMapWidget extends StatelessWidget {
  final Function() onTap;
  final String hintText;

  const SearchBarMapWidget({
    Key? key,
    required this.onTap,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 54),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            onTap: onTap,
            readOnly: true,
            decoration: InputDecoration(
              fillColor: Color(0xFFF7F8FA),
              hintText: hintText,
              prefixIcon: Icon(
                Icons.search,
                size: 25.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
