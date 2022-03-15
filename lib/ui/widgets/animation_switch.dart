import 'package:flutter/material.dart';

const _duration = Duration(seconds: 1);

class AnimationSwitchWidget extends StatefulWidget {
  final Widget first;
  final Widget second;
  final bool enabled;

  const AnimationSwitchWidget({
    Key? key,
    required this.first,
    required this.second,
    this.enabled = false,
  }) : super(key: key);

  @override
  _AnimationSwitchWidgetState createState() => _AnimationSwitchWidgetState();
}

class _AnimationSwitchWidgetState extends State<AnimationSwitchWidget>
    with TickerProviderStateMixin {
  late AnimationController _firstController;
  late AnimationController _secondController;

  late Animation _translateFirst;
  late Animation _translateSecond;

  @override
  void initState() {
    super.initState();
    _firstController = AnimationController(vsync: this, duration: _duration);
    _secondController = AnimationController(vsync: this, duration: _duration);

    _translateFirst = Tween(begin: 0.0, end: -350.0).animate(
      CurvedAnimation(parent: _firstController, curve: Curves.ease),
    );

    _translateSecond = Tween(begin: 350.0, end: 0.0).animate(
      CurvedAnimation(parent: _firstController, curve: Curves.ease),
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
      _firstController.forward();
      _secondController.forward();
    }
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _firstController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_translateFirst.value - 0.001, 0.0),
              child: child!,
            );
          },
          child: widget.first,
        ),
        AnimatedBuilder(
          animation: _secondController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_translateSecond.value - 0.001, 0.0),
              child: child!,
            );
          },
          child: widget.second,
        )
      ],
    );
  }
}
