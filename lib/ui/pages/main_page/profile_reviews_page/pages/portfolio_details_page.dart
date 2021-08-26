import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../../observer_consumer.dart';

class PortfolioDetails extends StatelessWidget {
  const PortfolioDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ObserverListener(
      onSuccess: () {},
      child: Observer(
        builder: (_) => Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: CupertinoNavigationBar(
            middle: Text("2FA"),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Container(),
            ),
          ),
        ),
      ),
    );
  }
}
