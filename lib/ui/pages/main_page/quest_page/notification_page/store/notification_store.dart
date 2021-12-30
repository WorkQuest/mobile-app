import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/quest_page/notification_page/notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';
import 'package:app/utils/web_socket.dart';
import 'package:easy_localization/easy_localization.dart';

part 'notification_store.g.dart';

@injectable
class NotificationStore extends _NotificationStore with _$NotificationStore {
}

abstract class _NotificationStore extends IStore<bool> with Store {

  _NotificationStore() {
    WebSocket().handlerQuests = this.changeQuests;
    WebSocket().handlerChats = this.changeChats;
  }

  @observable
  ObservableList<Notifications> listOfNotifications = ObservableList.of([]);

  @action
  void changeQuests(dynamic json) {
    var quest = BaseQuestResponse.fromJson(json["data"]);
    listOfNotifications.insert(
        0,
        Notifications(
            firstName: quest.user.firstName,
            lastName: quest.user.lastName,
            avatar: quest.user.avatar,
            date: DateTime.now(),
            idEvent: quest.id,
            idUser: quest.user.id,
            type: "quests.notification.${json["action"]}",
            message: "quests.notification.${json["action"]}".tr()));
  }

  @action
  void changeChats(dynamic json) {
    var message;
    if (json["type"] == "request") {
      message = MessageModel.fromJson(json["payload"]["result"]);
    } else if (json["message"]["action"] == "groupChatCreate") {
      message = MessageModel.fromJson(json["message"]["data"]["lastMessage"]);
      listOfNotifications.insert(
          0,
          Notifications(
              firstName: message.sender.firstName,
              lastName: message.sender.lastName,
              avatar: message.sender.avatar,
              date: message.createdAt,
              idEvent: message.chatId,
              idUser: message.senderUserId,
              type: "chat.infoMessage.groupChatCreate",
              message: "chat.infoMessage.groupChatCreate".tr()));
    } else if (json["message"]["action"] == "newMessage") {
      message = MessageModel.fromJson(json["message"]["data"]);
      listOfNotifications.insert(
          0,
          Notifications(
              firstName: message.sender.firstName,
              lastName: message.sender.lastName,
              avatar: message.sender.avatar,
              date: message.createdAt,
              idEvent: message.chatId,
              idUser: message.senderUserId,
              type: "modals.newMessage",
              message: message.text != null
                  ? message.text
                  : message.infoMessage.messageAction));
    }
  }
}
