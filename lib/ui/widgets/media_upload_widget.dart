import 'package:app/model/quests_models/create_quest_model/media_model.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:drishya_picker/drishya_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:easy_localization/easy_localization.dart';

class MediaUpload extends StatefulWidget {
  final ObservableList<DrishyaEntity> mediaDrishya;
  final ObservableList<Media> mediaURL;

  MediaUpload({required this.mediaDrishya, required List<Media> mediaURL})
      : this.mediaURL = ObservableList.of(mediaURL);

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
        requestType: RequestType.image,
      ),
      panelSetting: PanelSetting(
        //topMargin: 100.0,
        headerMaxHeight: 100.0,
      ),
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
            builder: (context) => widget.mediaDrishya.isEmpty &&
                    widget.mediaURL.isEmpty &&
                    widget.mediaDrishya.isEmpty
                ? galleryView()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: mediaView(context),
                      ),
                      IconButton(
                        onPressed: () async {
                          final picked = await gallController.pick(
                            context,
                          );
                          widget.mediaDrishya.addAll(picked);
                        },
                        icon: Icon(
                          Icons.add_circle,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget galleryView() => InkWell(
        onTap: () async {
          final picked = await gallController.pick(
            context,
          );
          widget.mediaDrishya.addAll(picked);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "uploader.uploadImage".tr(),
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
      builder: (context) => ListView(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          for (var media in widget.mediaDrishya) dataEntity(media),
          for (var media in widget.mediaURL) dataURL(media),
        ],
      ),
    );
  }

  Widget dataURL(Media media) {
    return Container(
      width: 150,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          // Media
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(media.url,fit: BoxFit.cover,),
          ),

          Positioned(
            top: -15.0,
            right: -15.0,
            child: IconButton(
              onPressed: () => widget.mediaURL.remove(media),
              icon: Icon(Icons.cancel),
              iconSize: 25.0,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget dataEntity(DrishyaEntity media) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0),
      child: Container(
        width: 150,
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            // Media
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.memory(
                media.thumbBytes,
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              top: -15.0,
              right: -15.0,
              child: IconButton(
                onPressed: () => widget.mediaDrishya.remove(media),
                icon: Icon(Icons.cancel),
                iconSize: 25.0,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
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
