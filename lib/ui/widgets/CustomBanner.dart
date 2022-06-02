import 'package:app/constants.dart';
import 'package:app/ui/widgets/BannerPainter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomBanner extends StatelessWidget {
  final Widget? child;
  final BannerLocation location;
  final TextStyle textStyle;
  final String? text;
  final Color color;
  final bool visible;

  const CustomBanner({
    Key? key,
    required this.child,
    this.text = '',
    this.location = BannerLocation.topEnd,
    this.textStyle = const TextStyle(
      color: AppColor.enabledText,
      fontWeight: FontWeight.bold,
    ),
    this.color = AppColor.blue,
    this.visible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Banner(
        color: text!.isEmpty ? Colors.transparent : color,
        message: text,
        location: location,
        textStyle: textStyle,
        child: child,
      ),
    );
    // return child;
  }
}

const Color _kColor = Color(0xFFFC001E);
const double _kHeight = 32.0;
const TextStyle _kTextStyle = TextStyle(
  color: Color(0xFFFFFFFF),
  fontSize: _kHeight * 0.85,
  fontWeight: FontWeight.w900,
  height: 1.0,
);

class Banner extends StatelessWidget {
  /// Creates a banner.
  ///
  /// The [message] and [location] arguments must not be null.
  const Banner({
    Key? key,
    this.child,
    @required this.message,
    this.textDirection,
    @required this.location,
    this.layoutDirection,
    this.color = _kColor,
    this.textStyle = _kTextStyle,
  })  : assert(message != null),
        assert(location != null),
        assert(textStyle != null),
        super(key: key);

  /// The widget to show behind the banner.
  ///
  /// {@macro flutter.widgets.child}
  final Widget? child;

  /// The message to show in the banner.
  final String? message;

  /// The directionality of the text.
  ///
  /// This is used to disambiguate how to render bidirectional text. For
  /// example, if the message is an English phrase followed by a Hebrew phrase,
  /// in a [TextDirection.ltr] context the English phrase will be on the left
  /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
  /// context, the English phrase will be on the right and the Hebrew phrase on
  /// its left.
  ///
  /// Defaults to the ambient [Directionality], if any.
  ///
  /// See also:
  ///
  ///  * [layoutDirection], which controls the interpretation of the [location].
  final TextDirection? textDirection;

  /// Where to show the banner (e.g., the upper right corner).
  final BannerLocation? location;

  /// The directionality of the layout.
  ///
  /// This is used to resolve the [location] values.
  ///
  /// Defaults to the ambient [Directionality], if any.
  ///
  /// See also:
  ///
  ///  * [textDirection], which controls the reading direction of the [message].
  final TextDirection? layoutDirection;

  /// The color of the banner.
  final Color color;

  /// The style of the text shown on the banner.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
//    assert((textDirection != null && layoutDirection != null) || debugCheckHasDirectionality(context));
    return CustomPaint(
      foregroundPainter: CustomBannerPainter(
        message: message,
        textDirection: textDirection ?? Directionality.of(context),
        location: location!,
        layoutDirection: layoutDirection ?? Directionality.of(context),
        color: color,
        textStyle: textStyle!,
      ),
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('message', message, showName: false));
    properties.add(EnumProperty<TextDirection>('textDirection', textDirection,
        defaultValue: null));
    properties.add(EnumProperty<BannerLocation>('location', location));
    properties.add(EnumProperty<TextDirection>(
        'layoutDirection', layoutDirection,
        defaultValue: null));
    properties.add(ColorProperty('color', color, showName: false));
    textStyle?.debugFillProperties(properties, prefix: 'text ');
  }
}
