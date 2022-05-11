import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app/ui/widgets/media_upload/store/i_media_store.dart';
import 'package:app/utils/file_methods.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../constants.dart';

enum TypeMedia { images, video, any }

class MediaUploadWithProgress<T extends IMediaStore> extends StatefulWidget {
  final TypeMedia type;
  final T store;

  const MediaUploadWithProgress({
    required this.store,
    required this.type,
  });

  @override
  MediaUploadState createState() => MediaUploadState();
}

class MediaUploadState extends State<MediaUploadWithProgress> {
  late IMediaStore store;

  @override
  void initState() {
    super.initState();
    store = widget.store;
  }

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      strokeCap: StrokeCap.round,
      radius: Radius.circular(10),
      dashPattern: [6, 6],
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
          child: Observer(builder: (context) {
            if (store.progressImages.isEmpty) {
              return _GalleryView(
                store: store,
                type: widget.type,
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ListMediaView(
                    store: store,
                  ),
                ),
                if (store.state == StateLoading.nothing)
                  IconButton(
                    onPressed: () async {
                      FilePickerResult? result;
                      if (widget.type == TypeMedia.images) {
                        result = await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          type: FileType.image,
                        );
                      }
                      if (widget.type == TypeMedia.video) {
                        result = await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          type: FileType.media,
                        );
                      }
                      if (widget.type == TypeMedia.any) {
                        result = await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            type: FileType.custom,
                            allowedExtensions: [
                              'jpeg',
                              'webp',
                              'mp4',
                              'mov',
                              'jpg',
                              'png'
                            ]);
                      }
                      if (result != null) {
                        result.files.map((file) {
                          store.setImage(File(file.path!));
                        }).toList();
                      }
                    },
                    icon: Icon(
                      Icons.add_circle,
                    ),
                  ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  child: SizedBox(
                    height: store.state == StateLoading.loading ? 60 : 0,
                    width: store.state == StateLoading.loading ? 60 : 0,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class ListMediaView extends StatelessWidget {
  final IMediaStore store;

  const ListMediaView({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 10.0),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          ...store.progressImages
              .where((element) =>
                  element.value.url != null && element.value.url!.isNotEmpty)
              .toList()
              .map(
                (notifier) => _ImageNetworkEntity(
                  store: store,
                  notifier: notifier,
                ),
              )
              .toList(),
          ...store.progressImages
              .where((element) => element.value.file != null)
              .toList()
              .map(
                (e) => _ImageEntity(
                  store: store,
                  notifier: e,
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}

class _GalleryView extends StatelessWidget {
  final IMediaStore store;
  final TypeMedia type;

  const _GalleryView({
    Key? key,
    required this.store,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        FilePickerResult? result;
        if (type == TypeMedia.images) {
          result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
            type: FileType.image,
          );
        }
        if (type == TypeMedia.video) {
          result = await FilePicker.platform.pickFiles(
            allowMultiple: true,
            type: FileType.media,
          );
        }
        if (type == TypeMedia.any) {
          result = await FilePicker.platform.pickFiles(
              allowMultiple: true,
              type: FileType.custom,
              allowedExtensions: ['jpeg', 'webp', 'mp4', 'mov', 'jpg', 'png']);
        }
        if (result != null) {
          result.files.map((file) {
            store.setImage(File(file.path!));
          }).toList();
        }
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
  }
}

class _ImageNetworkEntity extends StatelessWidget {
  final IMediaStore store;
  final ValueNotifier<LoadImageState> notifier;

  const _ImageNetworkEntity({
    Key? key,
    required this.notifier,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0),
      child: Container(
        width: 150,
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                FadeInImage(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  placeholder: MemoryImage(
                    Uint8List.fromList(
                        base64Decode(Constants.base64WhiteHolder)),
                  ),
                  image: NetworkImage(
                    notifier.value.url!,
                  ),
                  fit: BoxFit.cover,
                ),
                _SuccessWidget(),
              ],
            ),
            if (store.state == StateLoading.nothing)
              Positioned(
                top: -15.0,
                right: -15.0,
                child: IconButton(
                  onPressed: () {
                    store.deleteMedia(notifier.value.url!);
                    store.deleteImage(notifier);
                  },
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

class _ImageEntity extends StatelessWidget {
  final IMediaStore store;
  final ValueNotifier<LoadImageState> notifier;

  const _ImageEntity({
    Key? key,
    required this.store,
    required this.notifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.0),
      child: Container(
        width: 150,
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            _ImageWidget(
              notifier: notifier,
              stateLoading: store.state,
            ),
            if (store.state == StateLoading.nothing)
              Positioned(
                top: -15.0,
                right: -15.0,
                child: IconButton(
                  onPressed: () {
                    print('delete image');
                    store.deleteImage(notifier);
                  },
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

class _ImageWidget extends StatefulWidget {
  final ValueNotifier<LoadImageState> notifier;
  final StateLoading? stateLoading;

  const _ImageWidget({
    Key? key,
    required this.notifier,
    required this.stateLoading,
  }) : super(key: key);

  @override
  State<_ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<_ImageWidget> {
  late Future<Uint8List> future;
  File? file;

  @override
  void initState() {
    super.initState();
    file = widget.notifier.value.file;
    future = file!.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    if (file == null || file != widget.notifier.value.file) {
      future = widget.notifier.value.file!.readAsBytes();
      file = widget.notifier.value.file;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: FutureBuilder<Uint8List>(
        future: future,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ValueListenableBuilder<LoadImageState>(
              valueListenable: widget.notifier,
              builder: (_, value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    if (widget.notifier.value.typeFile == TypeFile.video)
                      _VideoThumbnail(
                        file: file!,
                      )
                    else if (widget.notifier.value.typeFile ==
                        TypeFile.documents)
                      SvgPicture.asset(
                        'assets/document.svg',
                        color: Color(0xFFAAB0B9),
                        width: MediaQuery.of(context).size.width * 0.1,
                      )
                    else
                      FadeInImage(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        placeholder: MemoryImage(
                          Uint8List.fromList(
                            base64Decode(Constants.base64WhiteHolder),
                          ),
                        ),
                        image: MemoryImage(
                          snapshot.data!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ImageCenterWidget(state: value.state),
                        SizedBox(
                          height: 4,
                        ),
                        Text(_textState(value),
                            style: TextStyle(
                              shadows: [
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                              fontSize: 14,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ],
                );
              },
            );
          }
          return SizedBox(
            height: 130,
            width: 130,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        },
      ),
    );
  }

  String _textState(LoadImageState value) {
    if (widget.stateLoading != null &&
        widget.stateLoading != StateLoading.nothing) {
      switch (value.state) {
        case StateImage.compression:
          return "Compression...";
        case StateImage.loading:
          return "Loading...  ${value.processLoading * 100}";
        case StateImage.success:
          return "Success";
      }
    } else {
      return '';
    }
  }
}

class _VideoThumbnail extends StatefulWidget {
  final File file;

  const _VideoThumbnail({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  _VideoThumbnailState createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<_VideoThumbnail> {
  Future<String>? _future;

  @override
  void initState() {
    super.initState();
    _future = _getFuture();
  }

  Future<String> _getFuture() async {
    return await VideoThumbnail.thumbnailFile(
            video: widget.file.path,
            thumbnailPath: (await getTemporaryDirectory()).path,
            imageFormat: ImageFormat.PNG,
            quality: 100) ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _future,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.isEmpty) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Center(
                  child: Text(
                    "Error load video.",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              );
            } else {
              return Stack(
                children: [
                  FadeInImage(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    placeholder: MemoryImage(
                      Uint8List.fromList(
                          base64Decode(Constants.base64WhiteHolder)),
                    ),
                    image: FileImage(File(snapshot.data!)),
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.videocam_outlined,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              );
            }
          }
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        });
  }
}

class _ImageCenterWidget extends StatelessWidget {
  final StateImage state;

  const _ImageCenterWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state == StateImage.loading) {
      return const SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator.adaptive(),
      );
    }
    if (state == StateImage.success) {
      return _SuccessWidget();
    }
    return SizedBox();
  }
}

class _SuccessWidget extends StatefulWidget {
  const _SuccessWidget({Key? key}) : super(key: key);

  @override
  _SuccessWidgetState createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<_SuccessWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
        scale: CurvedAnimation(
          parent: _animationController,
          curve: Curves.ease,
        ),
        child: CircleAvatar(
          backgroundColor: AppColor.enabledButton,
          child: Icon(
            Icons.check_circle_outline,
            color: Colors.white,
          ),
        ));
  }
}
