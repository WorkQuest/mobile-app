import 'package:flutter/material.dart';

class AnimationWorkersQuestsItems extends StatefulWidget {
  final Widget child;
  final int index;
  final bool enabled;

  const AnimationWorkersQuestsItems({
    Key? key,
    required this.child,
    this.enabled = false,
    this.index = 0,
  }) : super(key: key);

  @override
  _AnimationWorkersQuestsItemsState createState() =>
      _AnimationWorkersQuestsItemsState();
}

class _AnimationWorkersQuestsItemsState
    extends State<AnimationWorkersQuestsItems> with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 550));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enabled) {
      _animationController.forward();
    }
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(25 - (25 * _animationController.value), 0),
          child: Opacity(
            opacity: 0.1 + 0.9 * _animationController.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
