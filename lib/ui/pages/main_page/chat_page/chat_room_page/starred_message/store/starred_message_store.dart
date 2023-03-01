import 'dart:async';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/chat_model/star.dart';
import 'package:app/model/media_model.dart';
import 'package:app/utils/thumbnails.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/http/chat_extension.dart';

part 'starred_message_store.g.dart';

@injectable
class StarredMessageStore extends _StarredMessageStore with _$StarredMessageStore {
  StarredMessageStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _StarredMessageStore extends IStore<StarredMessageStoreState> with Store {
  _StarredMessageStore(this._apiProvider);

  final ApiProvider _apiProvider;

  @observable
  ObservableList<MessageModel> messages = ObservableList.of([]);

  @observable
  ObservableMap<Media, String> mediaPaths = ObservableMap.of({});

  @action
  getMessages({bool isForce = false}) async {
    try {
      onLoading();
      if (isForce) {
        messages.clear();
        mediaPaths.clear();
      }
      final response = await _apiProvider.getStarredMessage(offset: messages.length);
      messages.addAll(response);
      mediaPaths.addAll(await Thumbnail().getThumbnail(messages));
      onSuccess(StarredMessageStoreState.getMessages);
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  removeStar(MessageModel message) async {
    try {
      onLoading();
      final index = messages.indexWhere((element) => element == message);
      if (message.star != null) {
        await _apiProvider.removeStarFromMsg(messageId: message.id);
        messages[index].star = null;
      } else {
        await _apiProvider.setMessageStar(chatId: message.chatId!, messageId: message.id);
        messages[index].star = Star();
      }
      onSuccess(StarredMessageStoreState.removeStar);
    } catch (e) {
      onError(e.toString());
    }
  }
}

enum StarredMessageStoreState { getMessages, removeStar }
