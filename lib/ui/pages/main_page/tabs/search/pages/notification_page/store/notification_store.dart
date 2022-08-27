import 'package:app/http/api_provider.dart';
import 'package:app/model/dispute_model.dart';
import 'package:app/model/notification_model.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';

part 'notification_store.g.dart';

@injectable
class NotificationStore extends _NotificationStore with _$NotificationStore {
  NotificationStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _NotificationStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _NotificationStore(this._apiProvider);

  @observable
  ObservableList<NotificationElement> listOfNotifications = ObservableList.of([]);

  @observable
  ObservableMap<String, DisputeModel> disputes = ObservableMap.of({});

  @action
  Future<void> getNotification({bool isForce = true}) async {
    onLoading();
    if (isForce) {
      listOfNotifications.clear();
    }
    try {
      final _result = await _apiProvider.getNotifications(offset: listOfNotifications.length);
      listOfNotifications.addAll(_result.notifications);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future<void> deleteNotification(String notificationId) async {
    try {
      this.onLoading();
      await _apiProvider.deleteNotification(notificationId: notificationId);
      listOfNotifications.removeWhere((element) => element.id == notificationId);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future<void> getDispute(String disputeId) async {
    try {
      disputes[disputeId] = await _apiProvider.getDispute(disputeId: disputeId);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
