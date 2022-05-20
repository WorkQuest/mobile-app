// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_view_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ImageViewStore on _ImageViewStore, Store {
  final _$documentsAtom = Atom(name: '_ImageViewStore.documents');

  @override
  List<Media> get documents {
    _$documentsAtom.reportRead();
    return super.documents;
  }

  @override
  set documents(List<Media> value) {
    _$documentsAtom.reportWrite(value, super.documents, () {
      super.documents = value;
    });
  }

  final _$mediaAtom = Atom(name: '_ImageViewStore.media');

  @override
  Map<Media, String> get media {
    _$mediaAtom.reportRead();
    return super.media;
  }

  @override
  set media(Map<Media, String> value) {
    _$mediaAtom.reportWrite(value, super.media, () {
      super.media = value;
    });
  }

  final _$getThumbnailAsyncAction = AsyncAction('_ImageViewStore.getThumbnail');

  @override
  Future<void> getThumbnail() {
    return _$getThumbnailAsyncAction.run(() => super.getThumbnail());
  }

  final _$_ImageViewStoreActionController =
      ActionController(name: '_ImageViewStore');

  @override
  void setMedia(List<Media> medias) {
    final _$actionInfo = _$_ImageViewStoreActionController.startAction(
        name: '_ImageViewStore.setMedia');
    try {
      return super.setMedia(medias);
    } finally {
      _$_ImageViewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
documents: ${documents},
media: ${media}
    ''';
  }
}
