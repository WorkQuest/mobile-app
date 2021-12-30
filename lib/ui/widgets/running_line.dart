import 'package:flutter/material.dart';

class RunningLine extends StatefulWidget {
  final List<Widget> children;

  const RunningLine({Key? key, required this.children}) : super(key: key);

  @override
  _RunningLineState createState() => _RunningLineState();
}

class _RunningLineState extends State<RunningLine> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    controller.addListener(() {
      if (controller.offset == controller.position.maxScrollExtent)
        controller.jumpTo(0);
      else if (controller.offset == controller.position.minScrollExtent)
        Future.microtask(lestGo);
    });
    Future.microtask(lestGo);
    super.initState();
  }

  void lestGo() => controller.animateTo(controller.position.maxScrollExtent,
      duration: Duration(seconds: 6), curve: Curves.linear);

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      children: [
        ...widget.children,
      ],
    );
  }
}
