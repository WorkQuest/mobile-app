import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<ui.Image> getImageFromPath(String imagePath) async {
  ByteData byteData = await rootBundle.load(imagePath);
  final Completer<ui.Image> completer = new Completer();
  ui.decodeImageFromList(byteData.buffer.asUint8List(), (ui.Image img) {
    return completer.complete(img);
  });

  return completer.future;
}

Future<BitmapDescriptor> getClusterMarker(
  int clusterSize,
  Color clusterColor,
  Color textColor,
  int width,
) async {
  final PictureRecorder pictureRecorder = PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color = clusterColor;
  final TextPainter textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  final double radius = width / 2;

  canvas.drawCircle(
    Offset(radius, radius),
    radius,
    paint,
  );

  textPainter.text = TextSpan(
    text: clusterSize.toString(),
    style: TextStyle(
      fontSize: radius - 5,
      fontWeight: FontWeight.bold,
      color: textColor,
    ),
  );

  textPainter.layout();
  textPainter.paint(
    canvas,
    Offset(
      radius - textPainter.width / 2,
      radius - textPainter.height / 2,
    ),
  );

  final image = await pictureRecorder.endRecording().toImage(
    radius.toInt() * 2,
    radius.toInt() * 2,
  );

  final data = await image.toByteData(format: ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
}

Future<BitmapDescriptor> svgToBitMap(
    BuildContext context, String assetName, Size size, Color color) async {
  String svgString = await DefaultAssetBundle.of(context).loadString(assetName);

  DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, "key");

  MediaQueryData queryData = MediaQuery.of(context);
  double devicePixelRatio = queryData.devicePixelRatio;
  double width = size.width * devicePixelRatio;
  double height = size.height * devicePixelRatio;

  ui.Picture picture = svgDrawableRoot.toPicture(
      size: Size(width, height),
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn));

  ui.Image image = await picture.toImage(width.round(), height.round());
  ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  if (bytes == null) return BitmapDescriptor.defaultMarker;
  return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
}
