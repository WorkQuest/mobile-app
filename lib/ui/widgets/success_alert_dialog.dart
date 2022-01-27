import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future successAlert(
  BuildContext context,
  String message,
) =>
    showDialog(
        context: context,
        builder: (_) {
          return SuccessDialog(
            messageText: message,
          );
        });

const _durationScale = Duration(milliseconds: 1500);
const _durationSize = Duration(milliseconds: 800);

class SuccessDialog extends StatefulWidget {
  final String messageText;

  const SuccessDialog({required this.messageText});

  @override
  State<StatefulWidget> createState() => SuccessDialogState();
}

class SuccessDialogState extends State<SuccessDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? _scaleController;
  AnimationController? _sizeController;

  @override
  void initState() {
    super.initState();
    _scaleController =
        AnimationController(vsync: this, duration: _durationScale);
    _sizeController = AnimationController(vsync: this, duration: _durationSize);
    _scaleController!.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        _sizeController!.forward();
      }
    });

    _scaleController!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Column(
        children: [
          Stack(
            children: [
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: _scaleController!,
                  curve: Curves.fastLinearToSlowEaseIn,
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                ),
              ),
              SizeTransition(
                sizeFactor: CurvedAnimation(
                  parent: _sizeController!,
                  curve: Curves.bounceInOut,
                ),
                axis: Axis.horizontal,
                axisAlignment: -1,
                child: Center(
                  child: SvgPicture.asset(
                    "assets/on_success_alert.svg",
                  ),
                  // Icon(
                  //   Icons.check,
                  //   color: Colors.white,
                  //   size: 75,
                  // ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: Text(
              widget.messageText,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scaleController!.dispose();
    _sizeController!.dispose();
    super.dispose();
  }
}
