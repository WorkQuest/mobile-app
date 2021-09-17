import 'package:dotted_border/dotted_border.dart';
import 'package:drishya_picker/drishya_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

class MediaUpload extends StatefulWidget {
  final ObservableList<DrishyaEntity> media;

  MediaUpload({required this.media});

  @override
  _MediaUploadState createState() => _MediaUploadState();
}

class _MediaUploadState extends State<MediaUpload> {
  late final GalleryController gallController;

  @override
  void initState() {
    gallController = GalleryController(
      gallerySetting: const GallerySetting(
        maximum: 20,
        albumSubtitle: 'All',
        requestType: RequestType.common,
      ),
      panelSetting: PanelSetting(
          //topMargin: 100.0,
          headerMaxHeight: 100.0),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      strokeCap: StrokeCap.round,
      radius: Radius.circular(10),
      dashPattern: [
        6,
        6,
      ],
      color: Colors.grey,
      strokeWidth: 1.0,
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(shape: BoxShape.circle),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Center(
            child: Observer(
          builder: (context) => widget.media.isEmpty
              ? galleryView()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(child: mediaView(context)),
                    IconButton(
                      onPressed: () async {
                        final picked = await gallController.pick(
                          context,
                        );
                        widget.media.addAll(picked);
                      },
                      icon: Icon(
                        Icons.add_circle,
                      ),
                    ),
                  ],
                ),
        )),
      ),
    );
  }

  Widget galleryView() => InkWell(
        onTap: () async {
          final picked = await gallController.pick(
            context,
          );
          widget.media.addAll(picked);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Upload images \n or videos',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Icon(
              Icons.add_to_photos_outlined,
              color: Colors.blueAccent,
            ),
          ],
        ),
      );

  ///Displays Chosen Media Files
  Widget mediaView(
    BuildContext context,
  ) {
    return Observer(
      builder: (context) => ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        itemCount: widget.media.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(
          width: 10.0,
        ),
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Media
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.memory(
                    widget.media[index].thumbBytes,
                    fit: BoxFit.cover,
                  ),
                ),

                Center(
                  child: IconButton(
                    onPressed: () => widget.media.removeAt(index),
                    icon: Icon(Icons.cancel_outlined),
                    color: Colors.redAccent,
                  ),
                ),
                // For video duration
                if (widget.media[index].entity.type == AssetType.video)
                  Positioned(
                    right: 4.0,
                    bottom: 4.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.7),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 2.0),
                        child: Text(
                          widget.media[index].entity.duration.formattedDuration,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

extension on int {
  String get formattedDuration {
    final duration = Duration(seconds: this);
    final min = duration.inMinutes.remainder(60).toString();
    final sec = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$min:$sec';
  }
}
