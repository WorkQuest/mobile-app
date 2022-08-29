import 'package:flutter/material.dart';

class SelectedAppBarWidget extends StatelessWidget {
  final Function()? onPressedClose;
  final Function()? onPressedStar;
  final String lengthSelectedChats;

  const SelectedAppBarWidget({
    Key? key,
    required this.onPressedClose,
    required this.onPressedStar,
    required this.lengthSelectedChats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          onPressed: onPressedClose,
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
        Text(
          "$lengthSelectedChats",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: onPressedStar,
              icon: Icon(
                Icons.star,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
