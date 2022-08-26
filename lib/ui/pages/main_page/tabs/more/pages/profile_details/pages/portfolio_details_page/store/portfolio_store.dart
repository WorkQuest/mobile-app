import 'package:app/http/api_provider.dart';
import 'package:app/model/profile_response/portfolio.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/profile_response/review.dart';
import 'package:injectable/injectable.dart';
import 'package:app/base_store/i_store.dart';
import 'package:mobx/mobx.dart';

part 'portfolio_store.g.dart';

@injectable
class PortfolioStore extends _PortfolioStore with _$PortfolioStore {
  PortfolioStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _PortfolioStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _PortfolioStore(this._apiProvider);

  ProfileMeResponse? otherUserData;

  String titleName = "";

  @observable
  int pageNumber = 0;

  @observable
  ObservableList<PortfolioModel> portfolioList = ObservableList();

  @observable
  ObservableList<Review> reviewsList = ObservableList();

  List<String> messages = [];

  setTitleName(String value) => titleName = value;

  setOtherUserData(ProfileMeResponse? value) => otherUserData = value;

  @action
  changePageNumber(int value) => pageNumber = value;

  cutMessages() {
    List<String> splitMessage = [];
    messages.clear();
    reviewsList.forEach((element) {
      splitMessage = element.message.split("\n");
      messages.add(splitMessage[0] + (splitMessage.length > 1 ? "..." : ""));
    });
  }

  @action
  addPortfolio(PortfolioModel portfolio) {
    final _index = portfolioList.indexWhere((element) => element.id == portfolio.id);
    print('index: $_index');
    if (_index == -1) {
      portfolioList.insert(0, portfolio);
    } else {
      portfolioList.removeAt(_index);
      portfolioList.insert(_index, portfolio);
    }
  }

  @action
  deletePortfolio({
    required String portfolioId,
    required String userId,
  }) async {
    try {
      this.onLoading();
      await _apiProvider.deletePortfolio(
        portfolioId: portfolioId,
      );
      portfolioList.removeWhere((portfolio) => portfolio.id == portfolioId);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  getPortfolio({
    required String userId,
    bool isForce = false,
  }) async {
    try {
      onLoading();
      if (isForce) {
        portfolioList.clear();
      }
      portfolioList.addAll(
        ObservableList.of(
          await _apiProvider.getPortfolio(
            userId: userId,
            offset: portfolioList.length,
          ),
        ),
      );
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  getReviews({
    required String userId,
    bool isForce = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    try {
      onLoading();
      if (isForce) {
        reviewsList.clear();
      }
      final response = ObservableList.of(
        await _apiProvider.getReviews(
          userId: userId,
          offset: reviewsList.length,
        ),
      );
      reviewsList.addAll(response);
      reviewsList.toList().sort((key1, key2) {
        if (key1.createdAt.millisecondsSinceEpoch <
            key2.createdAt.millisecondsSinceEpoch) {
          return 1;
        } else {
          return 0;
        }
      });
      cutMessages();
      this.onSuccess(true);
    } catch (e) {
      this.onError(
        e.toString(),
      );
    }
  }

  clearData() {
    reviewsList.clear();
  }
}
