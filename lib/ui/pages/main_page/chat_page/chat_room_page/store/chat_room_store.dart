import 'dart:async';

import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/chat_page/repository/chat.dart';
import 'package:app/ui/pages/main_page/chat_page/repository/conversation_repository.dart';
import 'package:app/utils/web_socket.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'chat_room_store.g.dart';

@injectable
class ChatRoomStore extends _ChatRoomStore with _$ChatRoomStore {
  ChatRoomStore(ApiProvider apiProvider, ConversationRepository repo)
      : super(apiProvider, repo);
}

abstract class _ChatRoomStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;
  final ConversationRepository repo;

  _ChatRoomStore(this._apiProvider, this.repo);

  int _count = 0;
  int _offset = 0;
  int _limit = 20;
  String? idChat;

  String idGroupChat = "";

  @observable
  String chatName = "";

  @observable
  int index = 0;

  @observable
  ObservableList<bool> userInChat = ObservableList.of([]);

  @observable
  String _myId = "";

  @observable
  String infoMessageValue = "";

  @computed
  Chats? get chat => repo.chatByID(idChat);

  @observable
  bool isLoadingMessages = false;

  @observable
  bool refresh = false;

  @observable
  ObservableList<String> usersId = ObservableList.of([]);

  @observable
  ObservableList<ProfileMeResponse> availableUsers = ObservableList.of([]);

  @observable
  ObservableList<bool> selectedUsers = ObservableList.of([]);

  @observable
  ObservableList<MessageModel> starredMessage = ObservableList.of([]);

  // Observable<BaseQuestResponse?> quest = Observable(null);

  @action
  void setChatName(String value) => chatName = value;

  @action
  void selectUser(int index) {
    for (int i = 0; i < usersId.length; i++) {
      if (usersId[i] == availableUsers[index].id) {
        usersId.removeAt(i);
        return;
      }
    }
    usersId.add(availableUsers[index].id);
  }

  @action
  Future getUsersForGroupCHat() async {
    try {
      availableUsers
          .addAll(ObservableList.of(await _apiProvider.getUsersForGroupCHat()));
      selectedUsers = ObservableList.of(
          List.generate(availableUsers.length, (index) => false));
    } catch (e) {
      this.onError(e.toString());
    }
  }

  // onStar() async {
  //   if (quest.value!.star) {
  //     await _apiProvider.removeStar(id: quest.value!.id);
  //   } else
  //     await _apiProvider.setStar(id: quest.value!.id);
  //   await _getQuest();
  // }

  @action
  Future getStarredMessage() async {
    try {
      starredMessage =
          ObservableList.of(await _apiProvider.getStarredMessage());
      selectedUsers = ObservableList.of(
          List.generate(availableUsers.length, (index) => false));
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future createGroupChat() async {
    try {
      this.onLoading();
      final responseData = await _apiProvider.createGroupChat(
        chatName: chatName,
        usersId: usersId,
      );
      idGroupChat = responseData["id"];
      repo.setMessage([MessageModel.fromJson(responseData["lastMessage"])],
          ChatModel.fromJson(responseData));
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  String setInfoMessage(String infoMessage) {
    switch (infoMessage) {
      case "groupChatCreate":
        return infoMessageValue = "You created a group chat";
      case "employerRejectResponseOnQuest":
        return infoMessageValue =
            "The employer rejected the response to the request";
      case "workerResponseOnQuest":
        return infoMessageValue = "The worker responded to the quest";
      case "groupChatAddUser":
        return infoMessageValue = "User added";
      case "groupChatDeleteUser":
        return infoMessageValue = "User deleted";
      case "groupChatLeaveUser":
        return infoMessageValue = "User left chat";
    }
    return infoMessage;
  }

  @action
  generateListUserInChat() {
    userInChat = ObservableList.of(
        List.generate(chat!.chatModel.userMembers.length, (index) => true));
    print("userInChat: ${userInChat.length}");
  }

  @action
  getMessages(bool isPagination) async {
    if (chat!.messages.length >= _count && refresh) {
      return;
    }
    refresh = true;
    if (isPagination) _offset = chat!.messages.length;
    isLoadingMessages = true;
    final responseData = await _apiProvider.getMessages(
      chatId: chat!.chatModel.id,
      offset: _offset,
      limit: _limit,
    );

    _count = responseData["count"];

    repo.addAllMessages(
        List<MessageModel>.from(
            responseData["messages"].map((x) => MessageModel.fromJson(x))),
        chat!.chatModel.id);

    for (int index = 0; index < chat!.messages.length; index++)
      if (chat!.messages[index].text == null &&
          chat!.messages[index].infoMessage == null) {
        chat!.messages.removeAt(index);
      }
    _offset = chat!.messages.length;
    isLoadingMessages = false;
  }

  @action
  Future sendMessage(String text, String chatId, String userId) async {
    WebSocket().sendMessage(chatId: chatId, text: text, medias: []);
  }
}
