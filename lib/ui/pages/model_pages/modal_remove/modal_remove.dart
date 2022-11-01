import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ModalRemove extends StatelessWidget {
  const ModalRemove({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 33, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Removal collateral',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Collateral Token Quantity(unchangable amount)',
            ),
            SizedBox(
              height: 10,
            ),
            Text('USDT'),
            TextField(
              decoration: InputDecoration(
                labelText: '0',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('You need to revert WUSD (unchangable  amount)'),
            TextField(
              decoration: InputDecoration(
                labelText: '0',
              ),
            ),
            SizedBox(
              height: 26,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Remove'),
            ),
          ],
        ),
      ),
    );
  }
}
