import 'dart:async';

import 'package:app/model/quests_models/media_model.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

part 'image_view_store.g.dart';

@injectable
class ImageViewStore extends _ImageViewStore with _$ImageViewStore {
  ImageViewStore() : super();
}

abstract class _ImageViewStore extends IStore<bool> with Store {
  _ImageViewStore();

  @observable
  List<Media> documents = [];

  @observable
  Map<Media, String> media = {};

  @action
  void setMedia(List<Media> medias) {
    medias.forEach((element) {
      if (element.type == TypeMedia.Doc || element.type == TypeMedia.Pdf)
        documents.add(element);
      else
        media[element] = "";
    });
  }

  @action
  Future<void> getThumbnail() async {
    this.onLoading();
    print("///////////////////////////////");
    media.keys.toList().forEach((element) async {
      print("TypeMedia: ${element.type}");
      if (element.type == TypeMedia.Video) {
        media[element] = await VideoThumbnail.thumbnailFile(
              video: element.url,
              thumbnailPath: (await getTemporaryDirectory()).path,
              imageFormat: ImageFormat.PNG,
              quality: 10,
            ) ??
            "";
        print("TAG");
        print(media[element]);
      }
    });

    this.onSuccess(true);
  }
}
