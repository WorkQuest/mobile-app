import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ModalGenerate1 extends StatelessWidget {
  const ModalGenerate1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 33, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Generate',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Collateral asset price rise, and now you can generate additional WUSD. Please note that if the price of collateral assets decreases, the risk of collateral being liquidated increases.',
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
