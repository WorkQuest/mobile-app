import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ModalGenerate2 extends StatelessWidget {
  const ModalGenerate2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 33, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Generate',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'GenerateYour collateral is over-secured. You can get generate extra WUSD.',
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Collateral Token Quantity (unchangeable amount)',
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
            Text(
                'MAX amount available to generate (unchangable amount): 0 WUSD'),
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
              child: Text('Generate'),
            ),
          ],
        ),
      ),
    );
  }
}
