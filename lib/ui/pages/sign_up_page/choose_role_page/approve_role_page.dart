import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ApproveRolePage extends StatefulWidget {
  const ApproveRolePage();

  static const String routeName = '/approveRolePage';

  @override
  _ApproveRolePageState createState() => _ApproveRolePageState();
}

class _ApproveRolePageState extends State<ApproveRolePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Observer(
      builder: (ctx) {
        return Column(
          children: [
            Text("Your role is}"),
          ],
        );
      },
    );
  }
}
