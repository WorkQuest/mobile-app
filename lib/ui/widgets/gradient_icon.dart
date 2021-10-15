import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  GradientIcon(
      this.icon,
      this.size,
      );

  final Widget icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: icon,
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return LinearGradient(
          colors: <Color>[
            Color(0xFF0083C7),
            Color(0xFF00AA5B),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(rect);
      },
    );
  }
}

class GradientIconInstagram extends StatelessWidget {
  GradientIconInstagram(
      this.icon,
      this.size,
      );

  final Widget icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: icon,
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return LinearGradient(
          colors: <Color>[
            Color(0xFFAD00FF),
            Color(0xFFFF9900),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(rect);
      },
    );
  }
}