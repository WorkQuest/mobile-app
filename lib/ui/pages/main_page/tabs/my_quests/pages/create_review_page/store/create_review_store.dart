import 'package:app/http/api_provider.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';

part 'create_review_store.g.dart';

@injectable
class CreateReviewStore extends _CreateReviewStore with _$CreateReviewStore {
  CreateReviewStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _CreateReviewStore extends IStore<CreateReviewStoreState>
    with Store {
  final ApiProvider _apiProvider;

  _CreateReviewStore(this._apiProvider);

  @observable
  String message = "";

  @observable
  int mark = 5;

  @observable
  ObservableList<bool> star = ObservableList.of(
    List.generate(5, (index) => true),
  );

  @action
  void setStar() {
    if (star[mark - 1] == false)
      for (int i = 0; i < mark; i++) star[i] = !star[mark - 1];
    else
      for (int i = mark; i < 5; i++) star[i] = false;
  }

  @action
  void setMessage(String value) => message = value;

  @action
  Future<void> addReview(String questId) async {
    try {
      this.onLoading();
      await _apiProvider.sendReview(
        questId: questId,
        message: message,
        mark: mark,
      );
      this.onSuccess(CreateReviewStoreState.addReview);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }

  @action
  Future<void> addReviewDispute(String disputeId) async {
    try {
      this.onLoading();
      await _apiProvider.sendReviewDispute(
        disputeId: disputeId,
        message: message,
        mark: mark,
      );
      this.onSuccess(CreateReviewStoreState.addReviewDispute);
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}

enum CreateReviewStoreState { addReview, addReviewDispute }
