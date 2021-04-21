import 'package:app/app_localizations.dart';
import 'package:flutter/material.dart';

import 'platform_activity_indicator.dart';

const _duration = const Duration(milliseconds: 150);

class ActionButton extends StatelessWidget {
  final String titleLangKey;
  final bool isEnable;
  final bool isLoading;
  final Function() onPressed;

  ActionButton({
    required this.titleLangKey,
    required this.isEnable,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnable ? onPressed : null,
      child: AnimatedContainer(
        height: 42,
        duration: _duration,
        decoration: BoxDecoration(
          color: isEnable ? Color(0xFF0083C7) : Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Center(
          child: isLoading
              ? PlatformActivityIndicator()
              : AnimatedDefaultTextStyle(
                  child: Text(context.translate(titleLangKey)),
                  style: TextStyle(color: isEnable ? Colors.white : Color(0xFFCBCED2)),
                  duration: _duration,
                ),
        ),
      ),
    );
  }
}
