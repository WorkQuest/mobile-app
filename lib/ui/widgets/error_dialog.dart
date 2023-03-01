import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

Future errorAlert(
  BuildContext context,
  String message,
) =>
    showDialog(
        context: context,
        builder: (_) {
          return FunkyOverlay(
            messageText: message,
          );
        });

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
      ),
      reverseDuration: Duration(
        milliseconds: 600,
      ),
    );
    scaleAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.elasticInOut,
    );

    controller.forward();

    controller.addListener(
      () {
        setState(() {});

        if (controller.isCompleted) {
          Timer(
            Duration(seconds: 2),
            () async {
              await controller.reverse().then(
                    (value) => controller.stop(
                      canceled: true,
                    ),
                  );
              Navigator.pop(context);
              dispose();
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            height: 200.0,
            width: double.infinity,
            margin: EdgeInsets.symmetric(
              horizontal: 50.0,
            ),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "modals.error".tr(),
                  ),
                  const SizedBox(
                    height: 20.0,
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

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
