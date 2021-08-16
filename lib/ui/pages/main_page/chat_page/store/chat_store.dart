import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'chat_store.g.dart';

@injectable
class ChatStore extends _ChatStore with _$ChatStore {
  ChatStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ChatStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;
  _ChatStore(this._apiProvider);

  @observable
  List<ChatModel> chats = [];

  @action
  Future loadChats() async {
    try {
      this.onLoading();
      chats = await _apiProvider.getChats();
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}


