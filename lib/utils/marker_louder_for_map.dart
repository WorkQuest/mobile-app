import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<ui.Image> getImageFromPath(String imagePath) async {
  ByteData byteData = await rootBundle.load(imagePath);
  final Completer<ui.Image> completer = new Completer();
  ui.decodeImageFromList(byteData.buffer.asUint8List(), (ui.Image img) {
    return completer.complete(img);
  });

  return completer.future;
}

Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  Rect oval = Rect.fromLTWH(0, 0, size.width, size.height);
  ui.Image image = await getImageFromPath(imagePath);
  paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

  final ui.Image markerAsImage = await pictureRecorder
      .endRecording()
      .toImage(size.width.toInt(), size.height.toInt());

  final ByteData? byteData =
      await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List uint8List = byteData!.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(uint8List);
}
