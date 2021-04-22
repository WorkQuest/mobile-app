import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyQuestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text("My quests"),
          ),
        ],
      ),
    );
  }
}
