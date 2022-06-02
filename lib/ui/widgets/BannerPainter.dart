import 'package:flutter/material.dart';

import 'dart:math' as math;

import '../../constants.dart';

const double _kOffset =
    40.0; // distance to bottom of banner, at a 45 degree angle inwards
const double _kHeight = 24.0; // height of banner
const double _kBottomOffset =
    _kOffset + 0.707 * _kHeight; // offset plus sqrt(2)/2 * banner height
const Rect _kRect =
    Rect.fromLTWH(-_kOffset, _kOffset - _kHeight, _kOffset * 2.0, _kHeight);

const Color _kColor = Color(0xA0B71C1C);
const TextStyle _kTextStyle = TextStyle(
  color: AppColor.blue,
  fontSize: _kHeight * 0.85,
  fontWeight: FontWeight.w900,
  height: 1.0,
);

class CustomBannerPainter extends CustomPainter {
  /// Creates a banner painter.
  ///
  /// The [message], [textDirection], [location], and [layoutDirection]
  /// arguments must not be null.
  CustomBannerPainter({
    @required this.message,
    @required this.textDirection,
    required this.location,
    required this.layoutDirection,
    this.color = _kColor,
    this.textStyle = _kTextStyle,
  })  : assert(message != null),
        assert(textDirection != null),
        super(repaint: PaintingBinding.instance!.systemFonts);

  /// The message to show in the banner.
  final String? message;

  /// The directionality of the text.
  ///
  /// This value is used to disambiguate how to render bidirectional text. For
  /// example, if the message is an English phrase followed by a Hebrew phrase,
  /// in a [TextDirection.ltr] context the English phrase will be on the left
  /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
  /// context, the English phrase will be on the right and the Hebrew phrase on
  /// its left.
  ///
  /// See also:
  ///
  ///  * [layoutDirection], which controls the interpretation of values in
  ///    [location].
  final TextDirection? textDirection;

  /// Where to show the banner (e.g., the upper right corner).
  final BannerLocation location;

  /// The directionality of the layout.
  ///
  /// This value is used to interpret the [location] of the banner.
  ///
  /// See also:
  ///
  ///  * [textDirection], which controls the reading direction of the [message].
  final TextDirection layoutDirection;

  /// The color to paint behind the [message].
  ///
  /// Defaults to a dark red.
  final Color color;

  /// The text style to use for the [message].
  ///
  /// Defaults to bold, white text.
  final TextStyle textStyle;

//  static const BoxShadow _shadow = BoxShadow(
//    color: Color(0x7F000000),
//    blurRadius: 6.0,
//  );

  bool _prepared = false;
  TextPainter? _textPainter;
  Paint? _paintBanner;

  void _prepare() {
//    _paintShadow = _shadow.toPaint();
    _paintBanner = Paint()..color = color;
    _textPainter = TextPainter(
      text: TextSpan(style: textStyle, text: message),
      textAlign: TextAlign.center,
      textDirection: textDirection,
    );
    _prepared = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (!_prepared) _prepare();
    canvas
      ..translate(_translationX(size.width)!, _translationY(size.height)!)
      ..rotate(_rotation!)
//      ..drawRect(_kRect, _paintShadow)
      ..drawRect(_kRect, _paintBanner!);
    const double width = _kOffset * 2.0;
    _textPainter!.layout(minWidth: width, maxWidth: width);
    _textPainter!.paint(
        canvas,
        _kRect.topLeft +
            Offset(0.0, (_kRect.height - _textPainter!.height) / 2.0));
  }

  @override
  bool shouldRepaint(CustomBannerPainter oldDelegate) {
    return message != oldDelegate.message ||
        location != oldDelegate.location ||
        color != oldDelegate.color ||
        textStyle != oldDelegate.textStyle;
  }

  @override
  bool hitTest(Offset position) => false;

  double? _translationX(double width) {
    switch (layoutDirection) {
      case TextDirection.rtl:
        switch (location) {
          case BannerLocation.bottomEnd:
            return _kBottomOffset;
          case BannerLocation.topEnd:
            return 0.0;
          case BannerLocation.bottomStart:
            return width - _kBottomOffset;
          case BannerLocation.topStart:
            return width;
        }

      case TextDirection.ltr:
        switch (location) {
          case BannerLocation.bottomEnd:
            return width - _kBottomOffset;
          case BannerLocation.topEnd:
            return width;
          case BannerLocation.bottomStart:
            return _kBottomOffset;
          case BannerLocation.topStart:
            return 0.0;
        }
    }
  }

  double? _translationY(double height) {
    switch (location) {
      case BannerLocation.bottomStart:
      case BannerLocation.bottomEnd:
        return height - _kBottomOffset;
      case BannerLocation.topStart:
      case BannerLocation.topEnd:
        return 0.0;
    }
  }

  double? get _rotation {
    switch (layoutDirection) {
      case TextDirection.rtl:
        switch (location) {
          case BannerLocation.bottomStart:
          case BannerLocation.topEnd:
            return -math.pi / 4.0;
          case BannerLocation.bottomEnd:
          case BannerLocation.topStart:
            return math.pi / 4.0;
        }
      case TextDirection.ltr:
        switch (location) {
          case BannerLocation.bottomStart:
          case BannerLocation.topEnd:
            return math.pi / 4.0;
          case BannerLocation.bottomEnd:
          case BannerLocation.topStart:
            return -math.pi / 4.0;
        }
    }
  }
}
