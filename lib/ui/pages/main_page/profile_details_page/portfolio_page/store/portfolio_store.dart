import 'dart:io';

import 'package:app/http/api_provider.dart';
import 'package:app/model/profile_response/portfolio.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/profile_response/review.dart';
import 'package:app/model/media_model.dart';
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

  ProfileMeResponse? otherUserData;

  String titleName = "";

  int portfolioIndex = -1;

  int offset = 0;

  int offsetReview = 0;

  bool pagination = true;

  @observable
  bool tabBarScrolling = false;

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

  List<String> messages = [];

  void setTitleName(String value) => titleName = value;

  void setOtherUserData(ProfileMeResponse? value) => otherUserData = value;

  @action
  void setScrolling(bool value) => tabBarScrolling = value;

  @action
  void changePageNumber(int value) => pageNumber = value;

  @action
  void setTitle(String value) => title = value;

  @action
  void setDescription(String value) {
    description = value;
  }

  void cutMessages() {
    List<String> splitMessage = [];
    messages.clear();
    reviewsList.forEach((element) {
      splitMessage = element.message.split("\n");
      messages.add(splitMessage[0] + (splitMessage.length > 1 ? "..." : ""));
    });
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
      await getPortfolio(userId: userId, newList: true);
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
      await getPortfolio(userId: userId, newList: true);
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
      await getPortfolio(userId: userId, newList: true);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future<void> getPortfolio({
    required String userId,
    required bool newList,
  }) async {
    try {
      if (newList) {
        portfolioList.clear();
        offset = 0;
      }
      if (offset == portfolioList.length) {
        this.onLoading();
        portfolioList.addAll(
          ObservableList.of(
            await _apiProvider.getPortfolio(
              userId: userId,
              offset: offset,
            ),
          ),
        );
        offset += 10;
        this.onSuccess(true);
      }
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future<void> getReviews({
    required String userId,
    required bool newList,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));
    try {
      if (newList) {
        reviewsList.clear();
        offsetReview = 0;
      }
      if (offsetReview > reviewsList.length) return;
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
      cutMessages();
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
