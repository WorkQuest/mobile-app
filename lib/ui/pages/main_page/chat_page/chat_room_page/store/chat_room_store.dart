import 'dart:async';
import 'package:app/http/api_provider.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/chat_model/star.dart';
import 'package:app/model/dispute_model.dart';
import 'package:app/model/media_model.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/utils/thumbnails.dart';
import 'package:app/utils/web_socket.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/http/chat_extension.dart';
import 'package:app/ui/widgets/media_upload/store/i_media_store.dart';

part 'chat_room_store.g.dart';

@injectable
class ChatRoomStore extends _ChatRoomStore with _$ChatRoomStore {
  ChatRoomStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ChatRoomStore extends IMediaStore<bool> with Store {
  _ChatRoomStore(this._apiProvider) {
    WebSocket().handlerMessages = this.addedMessage;
  }

  final ApiProvider _apiProvider;

  @observable
  BaseQuestResponse? quest;

  @observable
  DisputeModel? dispute;

  int _offset = 0;

  String? idChat;

  String ownerId = "";

  @observable
  bool initPage = true;

  @observable
  bool loadMessage = false;

  @observable
  ChatModel? chatRoom;

  @observable
  ObservableList<MessageModel> messages = ObservableList.of([]);

  @observable
  ObservableMap<MessageModel, bool> selectedMessages = ObservableMap.of({});

  @observable
  bool firstLoad = true;

  @observable
  bool sendingMessage = false;

  @observable
  bool messageSelected = false;

  @observable
  ObservableList<MessageModel> starredMessage = ObservableList.of([]);

  @observable
  ObservableMap<Media, String> mediaPaths = ObservableMap.of({});

  @observable
  Map<String, Star?> star = {};

  @action
  Future<void> getMessages({
    required String chatId,
    bool newList = false,
  }) async {
    try {
      if (newList) {
        messages.clear();
        _offset = 0;
      }
      if (messages.length != _offset) return;
      loadMessage = true;
      final responseData = await _apiProvider.getMessages(
        chatId: chatId,
        offset: _offset,
      );

      messages.addAll(List<MessageModel>.from(
          responseData["messages"].map((x) => MessageModel.fromJson(x))));

      chatRoom = ChatModel.fromJson(responseData["chat"]);

      messages.forEach((element) {
        if (selectedMessages[element] == null)
          selectedMessages[element] = false;
      });

      mediaPaths.addAll(await Thumbnail().getThumbnail(messages));

      _offset += 10;
      initPage = false;
      loadMessage = false;
    } catch (e, trace) {
      this.onError(e.toString());
      print("ERROR: $e");
      print("ERROR: $trace");
    }
  }

  void getOwnerId() {
    ///ownerMemberId isn't owner id!
    final ownerChatId = chatRoom!.groupChat!.ownerMemberId;
    chatRoom!.members!.forEach((element) {
      if (ownerChatId == element.id) ownerId = element.userId!;
    });
  }

  @action
  void setMessageHighlighted(MessageModel message) =>
      selectedMessages[message] = !selectedMessages[message]!;

  @action
  void setSendingMessage(bool value) => sendingMessage = value;

  @action
  void setMessageSelected(bool value) => messageSelected = value;

  @action
  Future<void> leaveFromChat() async {
    try {
      this.onLoading();
      await _apiProvider.leaveFromChat(chatId: idChat!);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  void resetSelectedMessages() =>
      selectedMessages.forEach((key, value) => selectedMessages[key] = false);

  String getCountStarredChats() {
    int count = 0;
    selectedMessages.values.toList().forEach((element) {
      if (element) count++;
    });
    return count.toString();
  }

  @action
  Future<void> setStar() async {
    selectedMessages.forEach((key, value) async {
      if (selectedMessages[key] == true) {
        final index = messages.indexWhere((element) => element == key);
        if (key.star == null) {
          await _apiProvider.setMessageStar(
              chatId: chatRoom!.id, messageId: key.id);
          selectedMessages.removeWhere((msg, value) => msg == key);
          key.star = Star();
          selectedMessages[key] = false;
          messages[index].star = Star();
        } else {
          await _apiProvider.removeStarFromMsg(messageId: key.id);
          selectedMessages.removeWhere((msg, value) => msg == key);
          key.star = null;
          selectedMessages[key] = false;
          messages[index].star = null;
        }
      }
    });
    setMessageSelected(false);
    resetSelectedMessages();
  }

  String copyMessage() {
    String text = "";
    selectedMessages.forEach((key, value) {
      if (selectedMessages[key] == true) text += key.text! + " ";
    });
    return text;
  }

  @action
  void addedMessage(dynamic json) {
    try {
      MessageModel? message;
      if (json["type"] == "request")
        message = MessageModel.fromJson(json["payload"]["result"]);
      else if (json["type"] == "pub")
        message = MessageModel.fromJson(json["message"]["data"]);

      if (chatRoom!.chatData.chatId == message!.chatId) {
        messages.insert(0, message);

        if (selectedMessages[message] == null)
          selectedMessages[message] = false;
      }
    } catch (e, trace) {
      this.onError(e.toString());
      print("ERROR: $e");
      print("ERROR: $trace");
    }
  }

  Future sendMessage(
    String text,
    String chatId,
    String entity,
  ) async {
    setSendingMessage(true);
    await sendImages(_apiProvider);
    WebSocket().sendMessage(
      chatId: chatId,
      text: text,
      medias: medias.map((media) => media.id).toList(),
      entity: entity,
    );
    progressImages.clear();
    setSendingMessage(false);
  }

  @action
  Future<void> getQuest(String id) async {
    try {
      this.onLoading();
      quest = await _apiProvider.getQuest(id: id);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future<void> getDispute(String disputeId) async {
    try {
      this.onLoading();
      dispute = await _apiProvider.getDispute(disputeId: disputeId);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }
}
