import 'package:app/http/api_provider.dart';
import 'package:app/http/chat_extension.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/ui/widgets/media_upload/store/i_media_store.dart';

part 'create_private_store.g.dart';

@injectable
class CreatePrivateStore extends _CreatePrivateStore with _$CreatePrivateStore {
  CreatePrivateStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _CreatePrivateStore extends IMediaStore<bool> with Store {
  _CreatePrivateStore(this._apiProvider);

  final ApiProvider _apiProvider;

  @observable
  String message = "";

  @observable
  String chatId = "";

  @action
  void setMessage(String text) => message = text;

  @action
  Future<void> sendMessage(String userId) async {
    try {
      this.onLoading();
      await sendImages(_apiProvider);
      final response = await _apiProvider.sendMessageToUser(
        userId: userId,
        text: message,
        medias: medias.map((media) => media.id).toList(),
      );
      chatId = response["chatId"];
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
