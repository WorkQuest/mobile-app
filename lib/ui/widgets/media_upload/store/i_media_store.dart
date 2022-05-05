import 'dart:io';

import 'package:app/base_store/i_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

import '../../../../../http/api_provider.dart';
import '../../../../model/quests_models/media_model.dart';

part 'i_media_store.g.dart';

class IMediaStore<T> extends _IMediaStore<T> with _$IMediaStore<T> {}

abstract class _IMediaStore<T> extends IStore<T> with Store {

  @observable
  StateLoading state = StateLoading.nothing;

  @observable
  ObservableList<ValueNotifier<LoadImageState>> progressImages = ObservableList.of([]);

  @observable
  ObservableList<Media> medias = ObservableList.of([]);

  @action
  setImage(File file) {
    progressImages
        .add(ValueNotifier<LoadImageState>(LoadImageState(file: file)));
  }

  @action
  deleteImage(File file) {
    progressImages.removeWhere((element) => element.value.file == file);
  }

  @action
  deleteMedia(Media media) {
    medias.remove(media);
  }

  @action
  sendImages(ApiProvider apiProvider) async {
    try {
      state = StateLoading.loading;

      await Stream.fromIterable(progressImages).asyncMap((notifier) async {
        final media = await apiProvider.uploadMediaWithProgress(
          media: notifier.value.file,
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
  File file;
  StateImage state;
  double processLoading;

  LoadImageState({
    required this.file,
    this.processLoading = 0.0,
    this.state = StateImage.compression,
  });

  clone({
    File? file,
    StateImage? state,
    double? processLoading,
  }) {
    return LoadImageState(
      file: this.file,
      state: state ?? this.state,
      processLoading: processLoading ?? this.processLoading,
    );
  }
}

enum StateImage { compression, loading, success }
