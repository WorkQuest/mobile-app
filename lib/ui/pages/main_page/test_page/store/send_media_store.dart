import 'package:app/base_store/i_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'send_media_store.g.dart';

class SendMediaStore extends _SendMediaStore with _$SendMediaStore {

}

abstract class _SendMediaStore extends IStore<bool> with Store {
  ObservableList<ValueNotifier<>>
}

class LoadImageState {

}

enum StateImage{
  compression,
}
