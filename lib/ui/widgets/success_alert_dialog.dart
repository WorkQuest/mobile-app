import 'package:flutter/material.dart';

const _durationScale = Duration(milliseconds: 1500);
const _durationSize = Duration(milliseconds: 800);

class SuccessDialog extends StatefulWidget {
  const SuccessDialog();

  @override
  State<StatefulWidget> createState() => SuccessDialogState();
}

class SuccessDialogState extends State<SuccessDialog>
    with TickerProviderStateMixin {
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
      width: 80,
      height: 80,
      child: Stack(
        children: [
          ScaleTransition(
            scale: CurvedAnimation(
              parent: _scaleController!,
              curve: Curves.fastLinearToSlowEaseIn,
            ),
            child: Container(
              width: 80,
              height: 80,
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
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 50,
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
