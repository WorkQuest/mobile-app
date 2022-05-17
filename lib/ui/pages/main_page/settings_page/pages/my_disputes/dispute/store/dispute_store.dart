import 'package:app/http/api_provider.dart';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/chat_extension.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/dispute_model.dart';
import 'package:app/ui/pages/main_page/chat_page/chat.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'dispute_store.g.dart';

@injectable
class DisputeStore extends _DisputeStore with _$DisputeStore {
  DisputeStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _DisputeStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _DisputeStore(this._apiProvider);

  int _count = 0;
  int _offset = 0;
  int _limit = 20;

  Chats? chat;

  @observable
  String status = "";

  @observable
  DisputeModel? dispute;

  @observable
  ObservableList<MessageModel> messages = ObservableList.of([]);

  String getStatus(int value) {
    switch (value) {
      case 0:
        return status = "dispute.statuses.pending";
      case 1:
        return status = "dispute.statuses.created";
      case 2:
        return status = "dispute.statuses.inProgress";
      case 3:
        return status = "dispute.statuses.closed";
    }
    return status;
  }

  @action
  Future<void> getDispute(String disputeId) async {
    try {
      this.onLoading();
      dispute = await _apiProvider.getDispute(disputeId: disputeId);
      this.onSuccess(true);
    } catch (e, trace) {
      print("ERROR: $e");
      print("ERROR: $trace");
      this.onError(e.toString());
    }
  }

  @action
  Future<void> getMessages(String chatId) async {
    try {
      if (_offset <= _count) {
        this.onLoading();
        final responseData = await _apiProvider.getMessages(
          chatId: chatId,
          offset: _offset,
          limit: _limit,
        );
        _count = responseData["count"];
        messages.addAll(
          List<MessageModel>.from(
              responseData["messages"].map((x) => MessageModel.fromJson(x))),
        );
        _offset += 20;
        this.onSuccess(true);
      }
    } catch (e, trace) {
      print("ERROR: $e");
      print("ERROR: $trace");
      this.onError(e.toString());
    }
  }
}
