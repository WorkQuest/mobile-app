import 'package:app/http/api_provider.dart';
import 'package:app/model/profile_response/portfolio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/ui/widgets/media_upload/store/i_media_store.dart';

part 'create_portfolio_store.g.dart';

@injectable
class CreatePortfolioStore extends _CreatePortfolioStore with _$CreatePortfolioStore {
  CreatePortfolioStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _CreatePortfolioStore extends IMediaStore<PortfolioModel> with Store {
  final ApiProvider _apiProvider;

  _CreatePortfolioStore(this._apiProvider);

  @observable
  String title = '';

  @observable
  String description = '';

  @computed
  bool get canSubmit =>
      title.isNotEmpty && description.isNotEmpty && progressImages.isNotEmpty;

  @action
  setTitle(String value) => title = value;

  @action
  setDescription(String value) => description = value;

  @action
  createPortfolio() async {
    try {
      this.onLoading();
      await sendImages(_apiProvider);
      final result = await _apiProvider.addPortfolio(
        title: title,
        description: description,
        media: medias.map((media) => media.id).toList(),
      );
      result.medias = medias.map((media) {
        final url = media.url.split('?').first;
        print('url: $url');
        media.url = url;
        return media;
      }).toList();
      this.onSuccess(result);
    } catch (e, trace) {
      print('createPortfolio | $e\n$trace');
      this.onError(e.toString());
    }
  }

  @action
  editPortfolio({
    required String portfolioId,
  }) async {
    try {
      this.onLoading();
      await sendImages(_apiProvider);
      final result = await _apiProvider.editPortfolio(
        portfolioId: portfolioId,
        title: title,
        description: description,
        media: medias.map((media) => media.id).toList(),
      );
      result.medias = medias.map((media) {
        final url = media.url.split('?').first;
        media.url = url;
        return media;
      }).toList();
      this.onSuccess(result);
    } catch (e, trace) {
      print('editPortfolio | $e\n$trace');
      this.onError(e.toString());
    }
  }
}
