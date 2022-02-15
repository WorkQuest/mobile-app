import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerLoader {
  late ui.Image _cluster;
  late Size _markerSize;
  late Size _clusterSize;

  List<BitmapDescriptor> icons = [];

  MarkerLoader(BuildContext context) {
    loadIcons(context);
  }

  loadIcons(BuildContext context) async {
    const sizeCluster = Size(38, 47.51);
    const sizeMarker = Size(26, 34.27);
    String svgString =
        await DefaultAssetBundle.of(context).loadString("assets/marker.svg");
    this._cluster = await getImageFromPath("assets/Ellipse.png");
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    _clusterSize = new Size(sizeCluster.width * devicePixelRatio,
        sizeCluster.height * devicePixelRatio);
    _markerSize = new Size(sizeMarker.width * devicePixelRatio,
        sizeMarker.height * devicePixelRatio);
    icons.add(await svgToBitMap(svgString, _markerSize, Color(0xFF22CC14)));
    icons.add(await svgToBitMap(svgString, _markerSize, Color(0xFF22CC14)));
    icons.add(await svgToBitMap(svgString, _markerSize, Color(0xFFE8D20D)));
    icons.add(await svgToBitMap(svgString, _markerSize, Color(0xFFDF3333)));
  }

  Future<BitmapDescriptor> getCluster(int clusterSize) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final TextPainter textPainter =
        TextPainter(textDirection: TextDirection.ltr);
    Rect oval = Rect.fromLTWH(0, 0, _clusterSize.width, _clusterSize.height);
    paintImage(
        canvas: canvas, image: _cluster, rect: oval, fit: BoxFit.fitHeight);

    double fontSize = Platform.isIOS
        ? (clusterSize >= 1000 ? 20 : 30)
        : (clusterSize >= 1000 ? 35 : 40);

    double offset = Platform.isIOS
        ? (clusterSize >= 1000 ? 30 : 20)
        : (clusterSize >= 1000 ? 40 : 35);

    textPainter.text = TextSpan(
      text: clusterSize.toString(),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (_clusterSize.width / 2) - textPainter.width / 2,
        offset,
      ),
    );
    final image = await pictureRecorder.endRecording().toImage(
          _clusterSize.width.round(),
          _clusterSize.height.round(),
        );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  static Future<ui.Image> getImageFromPath(String imagePath) async {
    ByteData byteData = await rootBundle.load(imagePath);
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(byteData.buffer.asUint8List(), (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
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

  static Future<Marker> Function(Cluster<dynamic>) get markerBuilder =>
          (cluster) async {
        return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          onTap: () {
            print('---- $cluster');
            cluster.items.forEach((p) => print(p));
          },
          icon: await _getMarkerBitmap(cluster.isMultiple ? 125 : 75,
              text: cluster.isMultiple ? cluster.count.toString() : null),
        );
      };

  static Future<BitmapDescriptor> _getMarkerBitmap(int size, {String? text}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = Colors.orange;
    final Paint paint2 = Paint()..color = Colors.white;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

    if (text != null) {
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
    }

    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
}
