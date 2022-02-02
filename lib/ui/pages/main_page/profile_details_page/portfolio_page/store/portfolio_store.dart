import 'dart:io';

import 'package:app/http/api_provider.dart';
import 'package:app/model/profile_response/portfolio.dart';
import 'package:app/model/profile_response/review.dart';
import 'package:app/model/quests_models/media_model.dart';
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

  int portfolioIndex = -1;

  int offset = 0;

  int offsetReview = 0;

  bool pagination = true;

  @observable
  int pageNumber = 0;

  @observable
  String title = '';

  @observable
  String description = '';

  @observable
  ObservableList<PortfolioModel> portfolioList = ObservableList();

  @observable
  ObservableList<Review> reviewsList = ObservableList();

  @observable
  ObservableList<Media> mediaIds = ObservableList();

  @observable
  ObservableList<File> media = ObservableList();

  @action
  void changePageNumber(int value) => pageNumber = value;

  @action
  void setTitle(String value) => title = value;

  @action
  void setDescription(String value) {
    description = value;
  }

  void clearData() {
    reviewsList.clear();
    offsetReview = 0;
    offset = 0;
    pagination = true;
  }

  @action
  Future<void> createPortfolio({
    required String userId,
  }) async {
    try {
      this.onLoading();
      await _apiProvider.addPortfolio(
        title: title,
        description: description,
        media: mediaIds.map((e) => e.id).toList() +
            await _apiProvider.uploadMedia(
              medias: media,
            ),
      );
      await getPortfolio(userId: userId);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future<void> editPortfolio({
    required String portfolioId,
    required String userId,
  }) async {
    try {
      this.onLoading();
      await _apiProvider.editPortfolio(
        portfolioId: portfolioId,
        title: title,
        description: description,
        media: mediaIds.map((e) => e.id).toList() +
            await _apiProvider.uploadMedia(
              medias: media,
            ),
      );
      await getPortfolio(userId: userId);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future<void> deletePortfolio({
    required String portfolioId,
    required String userId,
  }) async {
    try {
      this.onLoading();
      await _apiProvider.deletePortfolio(
        portfolioId: portfolioId,
      );
      await getPortfolio(userId: userId);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future<void> getPortfolio({
    required String userId,
  }) async {
    try {
      this.onLoading();
      portfolioList = ObservableList.of(
        await _apiProvider.getPortfolio(
          userId: userId,
          offset: offset,
        ),
      );
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future<void> getReviews({
    required String userId,
  }) async {
    try {
      if (!pagination) return;
      this.onLoading();
      final response = ObservableList.of(
        await _apiProvider.getReviews(
          userId: userId,
          offset: offsetReview,
        ),
      );
      reviewsList.addAll(response);
      reviewsList.toList().sort((key1, key2) =>
          key1.createdAt.millisecondsSinceEpoch <
                  key2.createdAt.millisecondsSinceEpoch
              ? 1
              : 0);
      if (response.length == 0 || response.length % 10 != 0) pagination = false;
      offsetReview += 10;
      this.onSuccess(true);
    } catch (e) {
      this.onError(
        e.toString(),
      );
    }
  }

  @computed
  bool get canSubmit =>
      title.isNotEmpty &&
      description.isNotEmpty &&
      (media.isNotEmpty || mediaIds.isNotEmpty);
}
