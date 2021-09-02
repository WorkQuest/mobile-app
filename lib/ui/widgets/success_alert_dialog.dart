import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future successAlert(BuildContext context, String message) => showDialog(
      context: context,
      builder: (_) => FunkyOverlay(
        messageText: message,
      ),
    );

class FunkyOverlay extends StatefulWidget {
  final String messageText;

  const FunkyOverlay({required this.messageText});

  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 600,
        ));
    scaleAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.elasticInOut,
    );

    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 60.0,
                    width: 60.0,
                    child:
                       SvgPicture.asset(
                        "assets/on_success_alert.svg",
                      ),


                  ),
                  const SizedBox(
                    height: 20.0 ,
                  ),
                  Text(widget.messageText),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
