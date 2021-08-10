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
    int clusterSize, ui.Image elipse) async {
  final PictureRecorder pictureRecorder = PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
  final width = 120.0;
  final height = 150.27;
  Rect oval = Rect.fromLTWH(0, 0, width, height);
  paintImage(canvas: canvas, image: elipse, rect: oval, fit: BoxFit.fitHeight);

  textPainter.text = TextSpan(
    text: clusterSize.toString(),
    style: TextStyle(
      fontSize: clusterSize >= 1000 ? 40 : 50,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  textPainter.layout();
  textPainter.paint(
    canvas,
    Offset(
      (width / 2) - textPainter.width / 2,
      30,
    ),
  );
  final image = await pictureRecorder.endRecording().toImage(
        width.round(),
        height.round(),
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
