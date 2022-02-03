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
        Future.microtask(startAnimate);
    });
    Future.microtask(startAnimate);
    super.initState();
  }

  void startAnimate() {
    if (controller.position.maxScrollExtent != 0) {
      controller.animateTo(controller.position.maxScrollExtent,
          duration: Duration(seconds: 4), curve: Curves.linear);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      //shrinkWrap: true,
      controller: controller,
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      children: [
        ...widget.children,
      ],
    );
  }
}
