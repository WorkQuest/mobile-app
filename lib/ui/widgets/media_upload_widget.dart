import 'dart:io';
import 'package:app/model/quests_models/create_quest_model/media_model.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:easy_localization/easy_localization.dart';

class MediaUpload extends StatefulWidget {
  final ObservableList<File> mediaFile;
  final ObservableList<Media>? mediaURL;

  const MediaUpload(
    this.mediaURL, {
    required this.mediaFile,
  });

  @override
  _MediaUploadState createState() => _MediaUploadState();
}

class _MediaUploadState extends State<MediaUpload> {

  @override
  void initState() {
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
            builder: (context) => widget.mediaFile.isEmpty &&
                    (widget.mediaURL?.isEmpty ?? true) &&
                    widget.mediaFile.isEmpty
                ? galleryView()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: mediaView(context),
                      ),
                      IconButton(
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            type: FileType.image,
                          );
                          List<File> files =
                          result!.paths.map((path) => File(path!)).toList();
                          widget.mediaFile.addAll(files);
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
          final result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
            type: FileType.image,
          );
          List<File> files =
          result!.paths.map((path) => File(path!)).toList();
          widget.mediaFile.addAll(files);
        },
        child: SizedBox(
          width: double.infinity,
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
          for (var media in widget.mediaFile) dataEntity(media),
          if (widget.mediaURL != null)
            for (var media in widget.mediaURL!) dataURL(media),
        ],
      ),
    );
  }

  Widget dataURL(Media media) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 10.0,
      ),
      child: Container(
        width: 150,
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            // Media
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                media.url,
                fit: BoxFit.cover,
              ),
            ),

            if (widget.mediaURL != null)
              Positioned(
                top: -15.0,
                right: -15.0,
                child: IconButton(
                  onPressed: () => widget.mediaURL!.remove(media),
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

  Widget dataEntity(File media) {
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
                media.readAsBytesSync(),
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              top: -15.0,
              right: -15.0,
              child: IconButton(
                onPressed: () => widget.mediaFile.remove(media),
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
