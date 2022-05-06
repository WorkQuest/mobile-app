import 'dart:io';

import 'package:app/base_store/i_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

import '../../../../../http/api_provider.dart';
import '../../../../model/quests_models/media_model.dart';
import '../../../../utils/file_methods.dart';

part 'i_media_store.g.dart';

class IMediaStore<T> extends _IMediaStore<T> with _$IMediaStore<T> {}

abstract class _IMediaStore<T> extends IStore<T> with Store {
  @observable
  StateLoading state = StateLoading.nothing;

  @observable
  ObservableList<ValueNotifier<LoadImageState>> progressImages =
      ObservableList.of([]);

  @observable
  ObservableList<Media> medias = ObservableList.of([]);

  @action
  setImages(List<Media> medias) {
    for (Media media in medias) {
      progressImages.add(
        ValueNotifier<LoadImageState>(
          LoadImageState(
            url: media.url,
            state: StateImage.success,
            processLoading: 1,
            typeFile: FileUtils.getTypeFileFromTypeMedia(media.type),
          ),
        ),
      );
    }
  }

  @action
  setImage(File file) {
    progressImages.add(
      ValueNotifier<LoadImageState>(
        LoadImageState(
          file: file,
          typeFile: FileUtils.getTypeFile(file.path),
        ),
      ),
    );
  }

  @action
  deleteImage(ValueNotifier<LoadImageState> value) {
    progressImages.remove(value);
  }

  @action
  deleteMedia(String url) {
    medias.removeWhere((element) => element.url == url);
  }

  @action
  sendImages(ApiProvider apiProvider) async {
    try {
      state = StateLoading.loading;

      await Stream.fromIterable(progressImages).asyncMap((notifier) async {
        final media = await apiProvider.uploadMediaWithProgress(
          media: notifier.value.file!,
          notifier: notifier,
        );
        medias.add(media);
      }).toList();
      state = StateLoading.success;
    } catch (e) {
      onError(e.toString());
    }
  }
}

enum StateLoading {
  nothing,
  loading,
  success,
}

class LoadImageState {
  File? file;
  String? url;
  StateImage state;
  TypeFile typeFile;
  double processLoading;

  LoadImageState({
    this.file,
    this.url,
    this.processLoading = 0.0,
    required this.typeFile,
    this.state = StateImage.compression,
  });

  clone({
    File? file,
    StateImage? state,
    double? processLoading,
  }) {
    return LoadImageState(
      file: this.file,
      typeFile: this.typeFile,
      state: state ?? this.state,
      processLoading: processLoading ?? this.processLoading,
    );
  }
}

enum StateImage { compression, loading, success }
