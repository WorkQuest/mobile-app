import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ModalDeposit1 extends StatelessWidget {
  const ModalDeposit1({Key? key}) : super(key: key);

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
            Text(
              'Attention! Collateral asset price is falling, and now is a high risk of liquidation. Please note that you can deposit more collateral assets and decrease the risk of collateral liquidation',
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 26, 16, 0),
              child: ElevatedButton(
                onPressed: () {},
                child: Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
