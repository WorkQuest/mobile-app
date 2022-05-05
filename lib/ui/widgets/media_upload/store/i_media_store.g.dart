// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'i_media_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$IMediaStore<T> on _IMediaStore<T>, Store {
  final _$stateAtom = Atom(name: '_IMediaStore.state');

  @override
  StateLoading get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(StateLoading value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  final _$progressImagesAtom = Atom(name: '_IMediaStore.progressImages');

  @override
  ObservableList<ValueNotifier<LoadImageState>> get progressImages {
    _$progressImagesAtom.reportRead();
    return super.progressImages;
  }

  @override
  set progressImages(ObservableList<ValueNotifier<LoadImageState>> value) {
    _$progressImagesAtom.reportWrite(value, super.progressImages, () {
      super.progressImages = value;
    });
  }

  final _$mediasAtom = Atom(name: '_IMediaStore.medias');

  @override
  ObservableList<Media> get medias {
    _$mediasAtom.reportRead();
    return super.medias;
  }

  @override
  set medias(ObservableList<Media> value) {
    _$mediasAtom.reportWrite(value, super.medias, () {
      super.medias = value;
    });
  }

  final _$sendImagesAsyncAction = AsyncAction('_IMediaStore.sendImages');

  @override
  Future sendImages(ApiProvider apiProvider) {
    return _$sendImagesAsyncAction.run(() => super.sendImages(apiProvider));
  }

  final _$_IMediaStoreActionController = ActionController(name: '_IMediaStore');

  @override
  dynamic setImage(File file) {
    final _$actionInfo = _$_IMediaStoreActionController.startAction(
        name: '_IMediaStore.setImage');
    try {
      return super.setImage(file);
    } finally {
      _$_IMediaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic deleteImage(File file) {
    final _$actionInfo = _$_IMediaStoreActionController.startAction(
        name: '_IMediaStore.deleteImage');
    try {
      return super.deleteImage(file);
    } finally {
      _$_IMediaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic deleteMedia(Media media) {
    final _$actionInfo = _$_IMediaStoreActionController.startAction(
        name: '_IMediaStore.deleteMedia');
    try {
      return super.deleteMedia(media);
    } finally {
      _$_IMediaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state},
progressImages: ${progressImages},
medias: ${medias}
    ''';
  }
}
