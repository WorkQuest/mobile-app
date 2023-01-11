import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

const _durationSize = Duration(milliseconds: 400);
const _durationOpacity = Duration(milliseconds: 200);

class LoginButton extends StatefulWidget {
  final bool enabled;
  final bool withColumn;
  final String title;
  final Function()? onTap;

  const LoginButton({
    Key? key,
    this.enabled = false,
    this.withColumn = false,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> with TickerProviderStateMixin {
  late AnimationController _buttonController;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(vsync: this, duration: _durationSize);
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.enabled) {
      _buttonController.forward();
    } else {
      _buttonController.reverse();
    }

    final child = AnimatedBuilder(
      animation: _buttonController,
      builder: (context, child) {
        return Container(
          width: 60 +
              MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width * _buttonController.value,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            shape: BoxShape.rectangle,
          ),
          child: ElevatedButton(
            onPressed: widget.onTap,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                if (_buttonController.value > 0.2)
                  AnimatedOpacity(
                    opacity: 0.2 + _buttonController.value * 0.8,
                    duration: _durationOpacity,
                    child: const SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                if (_buttonController.value < 0.8)
                  AnimatedOpacity(
                    opacity: 1 - _buttonController.value,
                    duration: _durationOpacity,
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            widget.onTap != null ? Colors.white : AppColor.disabledText,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (widget.withColumn) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            child,
          ]);
    }
    return child;
  }
}
