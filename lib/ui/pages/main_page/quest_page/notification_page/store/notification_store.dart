import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/model/quests_models/notifications.dart';
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

  _NotificationStore(this._apiProvider) {
    // WebSocket().handlerQuests = this.changeQuests;
  }

  int offset = 0;

  BaseQuestResponse? quest;

  @observable
  ObservableList<NotificationElement> listOfNotifications = ObservableList.of([]);

  // @action
  // void changeQuests(dynamic json) {
  //   try {
  //     final id = DateTime.now().millisecond.toString();
  //     final recipients = json["recipients"];
  //     listOfNotifications.insert(
  //       0,
  //       NotificationElement(
  //         id: id,
  //         userId: recipients[0],
  //         notification: NotificationNotification(
  //           data: Data.fromJson(json["data"]),
  //           action: json["action"],
  //           recipients: recipients,
  //         ),
  //         seen: false,
  //         createdAt: DateTime.now(),
  //       ),
  //     );
  //   } catch (e, trace) {
  //     print("ERROR: $e");
  //     print("ERROR: $trace");
  //   }
  // }

  Future<void> getQuest(String questId) async {
    try {
      this.onLoading();
      quest = await _apiProvider.getQuest(id: questId);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future<void> getNotification(bool newList) async {
    try {
      if (newList) offset = 0;
      if (offset == listOfNotifications.length) {
        final responseData = await _apiProvider.getNotifications(offset: offset);
        listOfNotifications.addAll(responseData.notifications);
        offset += 10;
        this.onSuccess(true);
      }
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  updateNotification() async {
    try {
      this.onLoading();
      offset = 0;
      listOfNotifications.clear();
      final responseData = await _apiProvider.getNotifications(offset: 0);
      listOfNotifications.addAll(responseData.notifications);
      offset += 10;
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
}
