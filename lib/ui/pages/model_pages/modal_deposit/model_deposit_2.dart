import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

enum Currency { WUSD, USDT }

class ModalDeposit2 extends StatelessWidget {
  const ModalDeposit2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 33, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deposit',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Choose the currency'),
            Row(
              children: [
                Radio(
                  value: 'asdasdsd',
                  groupValue: 'asdsd',
                  onChanged: (value) {},
                ),
                Text('WUSD')
              ],
            ),
            Row(
              children: [
                Radio(
                  value: '',
                  groupValue: 'asdsd',
                  onChanged: (value) {},
                ),
                Text('USDT')
              ],
            ),
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
              child: Text('Deposit'),
            ),
          ],
        ),
      ),
    );
  }
}
