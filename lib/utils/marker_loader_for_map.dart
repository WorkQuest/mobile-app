import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerLoader {
  late Size _markerSize;
  List<BitmapDescriptor> icons = [];

  MarkerLoader(BuildContext context) {
    loadQuestIcons(context);
  }

  Future<void> loadQuestIcons(BuildContext context) async {
    const sizeMarker = Size(26, 34.27);
    String svgString =
        await DefaultAssetBundle.of(context).loadString("assets/marker.svg");
    //this._cluster = await getImageFromPath("assets/Ellipse.png");
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    _markerSize = new Size(sizeMarker.width * devicePixelRatio,
        sizeMarker.height * devicePixelRatio);
    icons.add(await svgToBitMap(svgString, _markerSize, Color(0xFF22CC14)));
    icons.add(await svgToBitMap(svgString, _markerSize, Color(0xFF22CC14)));
    icons.add(await svgToBitMap(svgString, _markerSize, Color(0xFFE8D20D)));
    icons.add(await svgToBitMap(svgString, _markerSize, Color(0xFFDF3333)));
  }

  static Future<BitmapDescriptor> svgToBitMap(
      String svgString, Size size, Color color) async {
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, "key");

    ui.Picture picture = svgDrawableRoot.toPicture(
        size: size, colorFilter: ColorFilter.mode(color, BlendMode.srcIn));

    ui.Image image =
        await picture.toImage(size.width.round(), size.height.round());
    ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) return BitmapDescriptor.defaultMarker;
    return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> getClusterMarkerBitmap(String text) async {
    int size = 80;
    // double fontSize = Platform.isIOS
    //     ? (clusterSize >= 1000 ? 20 : 30)
    //     : (clusterSize >= 1000 ? 35 : 40);
    //
    // double offset = Platform.isIOS
    //     ? (clusterSize >= 1000 ? 30 : 20)
    //     : (clusterSize >= 1000 ? 40 : 35);

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Colors.blueAccent;
    final Paint paint2 = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: text,
      style: TextStyle(
          fontSize: size / 3,
          color: Colors.white,
          fontWeight: FontWeight.normal),
    );
    painter.layout();
    painter.paint(
      canvas,
      Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
    );
    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data =
        await img.toByteData(format: ui.ImageByteFormat.png) as ByteData;
    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> getMarkerImageFromUrl(
    String url, {
    required int targetWidth,
  }) async {
    final File markerImageFile = await DefaultCacheManager().getSingleFile(url);
    return convertImageFileToBitmapDescriptor(markerImageFile);
  }

  static Future<BitmapDescriptor> convertImageFileToBitmapDescriptor(
    File imageFile, {
    int size = 80,
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Colors.blueAccent;
    final Uint8List imageUint8List = await imageFile.readAsBytes();
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();

    final center = Offset(40, 40);


    // The circle should be paint before or it will be hidden by the path
    canvas.drawCircle(center, 40, paint1);
    //make canvas clip path to prevent image drawing over the circle
    final Path clipPath = Path()
      ..addOval(Rect.fromCircle(radius: 30, center: center));
    canvas.clipPath(clipPath);

    //paintImage
    paintImage(
      canvas: canvas,
      rect: Rect.fromCircle(center:center, radius: 40),
      image: imageFI.image,
    );

    //convert canvas as PNG bytes
    final _image = await pictureRecorder
        .endRecording()
        .toImage(size, size);

    //convert canvas as PNG bytes
    final data = await _image.toByteData(format: ui.ImageByteFormat.png);

    //convert PNG bytes as BitmapDescriptor
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }
}
