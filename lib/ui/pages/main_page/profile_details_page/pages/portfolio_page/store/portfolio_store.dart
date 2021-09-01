import 'package:app/http/api_provider.dart';
import 'package:app/model/profile_response/portfolio.dart';
import 'package:drishya_picker/drishya_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';

part 'portfolio_store.g.dart';

@singleton
class PortfolioStore extends _PortfolioStore with _$PortfolioStore {
  PortfolioStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _PortfolioStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _PortfolioStore(this._apiProvider);

  @observable
  int pageNumber = 0;

  @observable
  String title = '';

  @observable
  String description = '';

  @observable
  ObservableList<PortfolioModel> portfolioList = ObservableList();

  @observable
  ObservableList<DrishyaEntity> media = ObservableList();

  @action
  void changePageNumber(int value) => pageNumber = value;

  void setTitle(String value) => title = value;

  void setDescription(String value) => description = value;

  @action
  Future<void> createPortfolio() async {
    try {
      this.onLoading();
      await _apiProvider.addPortfolio(
        title: title,
        description: description,
        media: await _apiProvider.uploadMedia(
          medias: media,
        ),
      );
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  Future<void> editPortfolio() async {
    try {
      this.onLoading();
      await _apiProvider.editPortfolio(
        portfolioId: '',
        title: title,
        description: description,
        media: await _apiProvider.uploadMedia(
          medias: media,
        ),
      );
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  Future<void> deletePortfolio({
    required String portfolioId,
  }) async {
    try {
      this.onLoading();
      await _apiProvider.deletePortfolio(
        portfolioId: "",
      );
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  Future<void> getPortfolio({
    required String userId,
  }) async {
    try {
      this.onLoading();
      portfolioList.addAll(
        await _apiProvider.getPortfolio(
          userId: userId,
        ),
      );
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
