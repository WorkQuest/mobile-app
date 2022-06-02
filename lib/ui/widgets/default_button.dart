import 'package:app/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _enabledTextColor = Colors.white;

class DefaultButton extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  final Color? colorEnabled;
  final Color? colorDisabled;
  final Widget? child;

  const DefaultButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.colorEnabled,
    this.colorDisabled,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: colorEnabled ?? AppColor.enabledButton,
      disabledColor: colorDisabled ?? AppColor.disabledButton,
      pressedOpacity: 0.2,
      padding: EdgeInsets.zero,
      child: child ?? Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: onPressed != null ? _enabledTextColor : AppColor.disabledText,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
