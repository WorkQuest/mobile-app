import 'dart:async';

import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/chat_model/star.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/ui/pages/main_page/chat_page/repository/chat.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/utils/web_socket.dart';
import 'package:drishya_picker/drishya_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'chat_room_store.g.dart';

@injectable
class ChatRoomStore extends _ChatRoomStore with _$ChatRoomStore {
  ChatRoomStore(ApiProvider apiProvider, ChatStore chats)
      : super(apiProvider, chats);
}

abstract class _ChatRoomStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;
  final ChatStore chats;
  _ChatRoomStore(this._apiProvider, this.chats);

  int _count = 0;
  int _offset = 0;
  int _limit = 20;
  String? idChat;

  String idGroupChat = "";

  final _atomMessages = Atom(name: '_ChatRoomStore.uncheck');

  final _atomSendMessage = Atom(name: '_ChatRoomStore.SengMessage');

  @observable
  String chatName = "";

  @observable
  ObservableList<bool> isMessageHighlighted = ObservableList.of([]);

  @observable
  ObservableList<String> idMessages = ObservableList.of([]);

  @observable
  ObservableList<String> idMessagesForDeleting = ObservableList.of([]);

  @observable
  int index = 0;

  @observable
  bool messageSelected = false;

  @observable
  ObservableList<bool> userInChat = ObservableList.of([]);

  @observable
  ObservableList<String> userForDeleting = ObservableList.of([]);

  @observable
  String _myId = "";

  @observable
  String infoMessageValue = "";

  @observable
  String userName = "";

  @computed
  Chats? get chat => chats.chatByID(idChat!);

  @observable
  bool isLoadingMessages = false;

  @observable
  bool refresh = false;

  @observable
  ProfileMeResponse? companion;

  @observable
  ObservableList<String> usersId = ObservableList.of([]);

  @observable
  ObservableList<ProfileMeResponse> availableUsers = ObservableList.of([]);

  @observable
  ObservableList<ProfileMeResponse> foundUsers = ObservableList.of([]);

  @observable
  ObservableList<bool> selectedUsers = ObservableList.of([]);

  @observable
  ObservableList<MessageModel> starredMessage = ObservableList.of([]);

  @observable
  ObservableList<DrishyaEntity> media = ObservableList.of([]);

  @observable
  int pageNumber = 0;

  @action
  void changePageNumber(int value) => pageNumber = value;

  @action
  void setMessageSelected(bool value) {
    messageSelected = value;
  }

  void uncheck() {
    for (int i = 0; i < isMessageHighlighted.length; i++) {
      isMessageHighlighted[i] = false;
    }
    _atomMessages.reportChanged();
  }

  void availableUsersForAdding(List<ProfileMeResponse> list) {
    for (int i = 0; i < list.length; i++)
      for (int j = 0; j < availableUsers.length; j++)
        if (availableUsers[j].id == list[i].id)
          availableUsers.remove(availableUsers[j]);
  }

  @action
  void setMessageHighlighted(int index, MessageModel message) {
    isMessageHighlighted[index] = !isMessageHighlighted[index];
    for (int i = 0; i < idMessages.length; i++)
      if (idMessages[i] == message.id) {
        idMessages.removeAt(i);
        return;
      }
    idMessages.add(message.id);
  }

  Future setStar() async {
    for (int i = 0; i < idMessages.length; i++)
      for (int j = 0; j < chat!.messages.length; j++)
        if (idMessages[i] == chat!.messages[j].id &&
            chat!.messages[j].star != null) {
          chat!.messages[j].star = null;
          await _apiProvider.removeStarFromMsg(messageId: idMessages[i]);
        } else if (idMessages[i] == chat!.messages[j].id &&
            chat!.messages[j].star == null) {
          await _apiProvider.setMessageStar(
            chatId: chat!.chatModel.id,
            messageId: idMessages[i],
          );
          chat!.messages[j].star = Star(
            id: "",
            messageId: chat!.messages[j].id,
            createdAt: DateTime.now(),
            userId: chat!.messages[j].senderUserId,
          );
        }
    _atomMessages.reportChanged();
  }

  @action
  String copyMessage() {
    String text = "";
    for (int i = 0; i < idMessages.length; i++)
      for (int j = 0; j < chat!.messages.length; j++)
        if (idMessages[i] == chat!.messages[j].id)
          text += chat!.messages[j].text! + " ";
    return text;
  }

  @action
  void setChatName(String value) => chatName = value;

  @action
  void findUser(String text) {
    userName = text;
    foundUsers.clear();
    availableUsers.forEach((element) {
      if (element.firstName.toLowerCase().contains(text.toLowerCase()) ||
          element.lastName.toLowerCase().contains(text.toLowerCase()))
        foundUsers.add(element);
    });
  }

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
  void undeletingUser(ProfileMeResponse user) {
    for (int i = 0; i < userForDeleting.length; i++) {
      if (userForDeleting[i] == user.id) {
        userForDeleting.removeAt(i);
      }
    }
  }

  @action
  void deleteUser(ProfileMeResponse user) {
    userForDeleting.add(user.id);
  }

  // @action
  // void setLists() {
  //   isMessageHighlighted =
  //       ObservableList.of(List.generate(_count, (index) => false));
  //   idMessages = ObservableList.of(List.generate(_count, (index) => ""));
  // }

  @action
  Future getUsersForGroupCHat() async {
    try {
      availableUsers.clear();
      selectedUsers.clear();
      availableUsers
          .addAll(ObservableList.of(await _apiProvider.getUsersForGroupCHat()));
      selectedUsers = ObservableList.of(
          List.generate(availableUsers.length, (index) => false));
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future getCompanion(String userId) async {
    try {
      this.onLoading();
      companion = await _apiProvider.getProfileUser(userId: userId);
      this.onSuccess(true);
    } catch (e, trace) {
      print(trace);
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
      chats.setMessages([MessageModel.fromJson(responseData["lastMessage"])],
          ChatModel.fromJson(responseData));
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  Future addUsersInChat() async {
    try {
      this.onLoading();
      await _apiProvider.addUsersInChat(
        chatId: chat!.chatModel.id,
        userIds: usersId,
      );
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  Future removeUserFromChat() async {
    if (userForDeleting.isNotEmpty)
      try {
        this.onLoading();
        userForDeleting.forEach((element) async {
          await _apiProvider.removeUser(
            chatId: chat!.chatModel.id,
            userId: element,
          );
          for (int i = 0; i < chat!.chatModel.userMembers.length; i++)
            if (chat!.chatModel.userMembers[i].id == element) {
              chat!.chatModel.userMembers
                  .remove(chat!.chatModel.userMembers[i]);
            }
        });
        this.onSuccess(true);
      } catch (e) {
        this.onError(e.toString());
      }
  }

  @action
  getMessages(bool isPagination) async {
    if (chat!.messages.length >= _count && refresh) {
      return;
    }
    if (isPagination) _offset = chat!.messages.length;
    isLoadingMessages = true;
    final responseData = await _apiProvider.getMessages(
      chatId: chat!.chatModel.id,
      offset: _offset,
      limit: _limit,
    );

    _count = responseData["count"];
    chats.addAllMessages(
        List<MessageModel>.from(
            responseData["messages"].map((x) => MessageModel.fromJson(x))),
        chat!.chatModel.id);

    _offset = chat!.messages.length;
    if (!refresh)
      isMessageHighlighted =
          ObservableList.of(List.generate(_count, (index) => false));
    refresh = true;
    isLoadingMessages = false;
    chat!.update();
  }

  Future sendMessage(String text, String chatId, String userId) async {
    WebSocket().sendMessage(
        chatId: chatId,
        text: text,
        medias: await _apiProvider.uploadMedia(medias: media));
    media.clear();
    isMessageHighlighted.addAll(List.generate(1, (index) => false));
    _atomSendMessage.reportChanged();
  }
}
