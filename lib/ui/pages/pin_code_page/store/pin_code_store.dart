import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/bearer_token.dart';
import 'package:app/utils/storage.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'pin_code_store.g.dart';

@injectable
class PinCodeStore extends _PinCodeStore with _$PinCodeStore {
  PinCodeStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _PinCodeStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _PinCodeStore(this._apiProvider);

  @action
  Future signIn() async {
    try {
      this.onLoading();
      String? token = await Storage.readRefreshToken();
      
      BearerToken bearerToken = await _apiProvider.refreshToken(token!);

      Storage.writeRefreshToken(bearerToken.refresh);
      Storage.writeAccessToken(bearerToken.access);

      
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
