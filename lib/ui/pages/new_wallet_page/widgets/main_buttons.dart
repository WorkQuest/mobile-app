import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MainButtons extends StatelessWidget {
  const MainButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 46,
          width: 100,
          child: OutlinedButton(
            onPressed: () {},
            child: Text('Deposit'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Container(
            height: 46,
            width: 100,
            child: OutlinedButton(
              onPressed: () {},
              child: Text('Withdraw'),
            ),
          ),
        ),
        Container(
          height: 46,
          width: 100,
          child: ElevatedButton(
            onPressed: () {},
            child: Text('Transfer'),
          ),
        ),
      ],
    );
  }
}
