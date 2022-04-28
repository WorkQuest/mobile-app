import 'dart:io';

import 'package:app/base_store/i_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../../../../http/api_provider.dart';

part 'send_media_store.g.dart';

@injectable
class SendMediaStore extends _SendMediaStore with _$SendMediaStore {
  SendMediaStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _SendMediaStore extends IStore<bool> with Store {
  final ApiProvider apiProvider;

  _SendMediaStore(this.apiProvider);

  @observable
  ObservableList<ValueNotifier<LoadImageState>> progressImages =
      ObservableList.of([]);

  @action
  setImage(File file) {
    progressImages
        .add(ValueNotifier<LoadImageState>(LoadImageState(file: file)));
  }

  @action
  sendImages() async {
    try {
      await Stream.fromIterable(progressImages).asyncMap((file) async {
        final result = await apiProvider.uploadMedia(media: file);
      }).toList();
    } catch (e) {}
  }
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
}

enum StateImage { compression, loading, success }
