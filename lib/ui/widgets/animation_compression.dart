import 'package:flutter/material.dart';

const _durationScale = Duration(milliseconds: 400);
const _durationSize = Duration(milliseconds: 200);

class AnimationCompression extends StatefulWidget {
  final Widget first;
  final Widget second;
  final bool enabled;

  const AnimationCompression({
    Key? key,
    required this.first,
    required this.second,
    this.enabled = false,
  }) : super(key: key);

  @override
  _AnimationCompressionState createState() => _AnimationCompressionState();
}

class _AnimationCompressionState extends State<AnimationCompression>
    with TickerProviderStateMixin {
  late AnimationController _firstController;
  late AnimationController _secondController;

  late Animation _firstAnimation;
  late Animation _secondAnimation;

  @override
  void initState() {
    super.initState();
    _firstController = AnimationController(vsync: this, duration: _durationScale);
    _secondController = AnimationController(vsync: this, duration: _durationSize);

    _firstAnimation = Tween(begin: 0.0, end: 1).animate(
      CurvedAnimation(parent: _firstController, curve: Curves.decelerate),
    );
    _secondAnimation = Tween(begin: 0.0, end: 1).animate(
      CurvedAnimation(parent: _secondController, curve: Curves.easeInOutExpo),
    );
  }

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enabled) {
      _firstController.forward().then((value) => _secondController.forward());
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _secondController,
          builder: (context, child) {
            return SizedBox(
              height: 30.0 * _secondAnimation.value,
              width: 30.0 * _secondAnimation.value,
              child: child,
            );
          },
          child: widget.second,
        ),
        AnimatedBuilder(
          animation: _firstController,
          builder: (context, child) {
            return Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width - MediaQuery.of(context).size.width * _firstAnimation.value,
              child: child,
            );
          },
          child: widget.first,
        ),
      ],
    );
  }
}
