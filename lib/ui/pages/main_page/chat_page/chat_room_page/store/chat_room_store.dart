import 'dart:async';
import 'dart:io';
import 'package:app/enums.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/chat_model/info_message.dart';
import 'package:app/model/chat_model/message_model.dart';
import 'package:app/model/chat_model/star.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/media_model.dart';
import 'package:app/ui/pages/main_page/chat_page/chat.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/utils/web_socket.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/http/chat_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:app/ui/widgets/media_upload/store/i_media_store.dart';
import 'package:path_provider/path_provider.dart';

part 'chat_room_store.g.dart';

@injectable
class ChatRoomStore extends _ChatRoomStore with _$ChatRoomStore {
  ChatRoomStore(ApiProvider apiProvider, ChatStore chats)
      : super(apiProvider, chats);
}

abstract class _ChatRoomStore extends IMediaStore<bool> with Store {
  final ApiProvider _apiProvider;
  final ChatStore chats;

  _ChatRoomStore(this._apiProvider, this.chats);

  int _count = 0;
  int _offset = 0;
  int _limit = 20;
  String? idChat;

  String idGroupChat = "";

  // @observable
  // ObservableMap<int, String> filesPath = ObservableMap.of({});

  final _atomMessages = Atom(name: '_ChatRoomStore.uncheck');

  final _atomSendMessage = Atom(name: '_ChatRoomStore.SengMessage');

  final _atomGetThumbnail = Atom(name: '_ChatRoomStore.GetThumbnail');

  @observable
  String chatName = "";

  @observable
  bool sendingMessage = false;

  @observable
  ObservableMap<String, bool> idMessagesForStar = ObservableMap.of({});

  @observable
  ObservableList<String> idMessages = ObservableList.of([]);

  @observable
  int index = 0;

  @observable
  bool messageSelected = false;

  @observable
  ObservableMap<String, bool> userInChat = ObservableMap.of({});

  @observable
  ObservableList<String> userForDeleting = ObservableList.of([]);

  @observable
  String _myId = "";

  UserRole? myRole;

  @observable
  String infoMessageValue = "";

  @observable
  String userName = "";

  @computed
  Chats? get chat => chats.chatByID(idChat!);

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
  ObservableMap<Media, String> mediaPaths = ObservableMap.of({});

  // @observable
  // ObservableList<File> media = ObservableList.of([]);

  @observable
  int pageNumber = 0;

  @observable
  Map<String, Star?> star = {};

  @observable
  ObservableMap<String, dynamic> mapOfPath = ObservableMap.of({});

  @action
  void changePageNumber(int value) => pageNumber = value;

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
  Future<void> getThumbnail(List<MessageModel> value) async {
    for (int i = 0; i < value.length; i++) {
      for (int j = 0; j < value[i].medias.length; j++) {
        if (value[i].medias[j].type == TypeMedia.Video) {
          String dir = "";
          if (Platform.isAndroid) {
            dir = (await getExternalStorageDirectory())!.path;
          } else if (Platform.isIOS) {
            dir = (await getApplicationDocumentsDirectory()).path;
          }
          var existsFile = await File(dir +
                  "/" +
                  "${value[i].medias[j].url.split("/").reversed.first}.mp4")
              .exists();
          if (!existsFile) {
            final f = await downloadFile(value[i].medias[j].url,
                value[i].medias[j].url.split("/").reversed.first + ".mp4", dir);
            mediaPaths[value[i].medias[j]] = f;
          } else
            mediaPaths[value[i].medias[j]] = dir +
                "/" +
                "${value[i].medias[j].url.split("/").reversed.first}.mp4";
        }
        _atomGetThumbnail.reportChanged();
      }
    }
  }

  Future<String> downloadFile(String url, String fileName, String dir) async {
    HttpClient httpClient = new HttpClient();
    File file;
    String filePath = '';

    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      } else
        filePath = 'Error code: ' + response.statusCode.toString();
    } catch (ex) {
      filePath = 'Can not fetch url';
    }

    return filePath;
  }

  void uncheck() {
    for (int i = 0; i < idMessages.length; i++) {
      idMessagesForStar[idMessages[i]] = false;
    }
    idMessages.clear();
    _atomMessages.reportChanged();
  }

  void availableUsersForAdding(List<ProfileMeResponse> list) {
    for (int i = 0; i < list.length; i++)
      for (int j = 0; j < availableUsers.length; j++)
        if (availableUsers[j].id == list[i].id)
          availableUsers.remove(availableUsers[j]);
  }

  @action
  void setMessageHighlighted(MessageModel message) {
    if (idMessagesForStar[message.id] != null)
      idMessagesForStar[message.id] = !idMessagesForStar[message.id]!;
    for (int i = 0; i < idMessages.length; i++)
      if (idMessages[i] == message.id) {
        idMessages.removeAt(i);
        return;
      }
    idMessages.add(message.id);
  }

  @action
  Future setStar(bool allMsg) async {
    List<MessageModel> messages = [];
    if (allMsg)
      messages = chat!.messages;
    else
      messages = starredMessage;
    for (int i = 0; i < idMessages.length; i++) {
      for (int j = 0; j < messages.length; j++) {
        if (idMessages[i] == messages[j].id && messages[j].star != null) {
          messages[j].star = null;
          _apiProvider.removeStarFromMsg(messageId: idMessages[i]);
          if (!allMsg) {
            messages.removeAt(j);
            break;
          }
        } else if (idMessages[i] == messages[j].id &&
            messages[j].star == null) {
          _apiProvider.setMessageStar(
            chatId: chat!.chatModel.id,
            messageId: idMessages[i],
          );
          chat!.messages[j].star = Star(
            id: "",
            messageId: chat!.messages[j].id,
            chatId: null,
            createdAt: DateTime.now(),
            userId: chat!.messages[j].senderUserId,
          );
        }
      }
    }
    uncheck();
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

  @action
  Future getUsersForGroupCHat() async {
    try {
      usersId.clear();
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
        return infoMessageValue = "chat.infoMessage.groupChatCreate".tr();
      case "employerRejectResponseOnQuest":
        return infoMessageValue =
            "chat.infoMessage.employerRejectResponseOnQuest".tr();
      case "employerInviteOnQuest":
        return infoMessageValue = "chat.infoMessage.employerInviteOnQuest".tr();
      case "workerResponseOnQuest":
        return infoMessageValue = "chat.infoMessage.workerResponseOnQuest".tr();
      case "groupChatAddUser":
        return infoMessageValue = "chat.infoMessage.groupChatAddUser".tr();
      case "groupChatDeleteUser":
        return infoMessageValue = "chat.infoMessage.groupChatDeleteUser".tr();
      case "groupChatLeaveUser":
        return infoMessageValue = "chat.infoMessage.groupChatLeaveUser".tr();
      case "workerRejectedQuest":
        return infoMessageValue = "chat.infoMessage.workerRejectedQuest".tr();
      case "workerAcceptedQuest":
        return infoMessageValue = "chat.infoMessage.workerAcceptedQuest".tr();
      case "workerCompletedQuest":
        return infoMessageValue = "chat.infoMessage.workerCompletedQuest".tr();
      case "workerAcceptedInvitationToQuest":
        return infoMessageValue =
            "chat.infoMessage.workerAcceptedInvitationToQuest".tr();
      case "workerRejectedInvitationToQuest":
        return infoMessageValue =
            "chat.infoMessage.workerRejectedInvitationToQuest".tr();
    }
    return infoMessage;
  }

  @action
  generateListUserInChat() {
    chat!.chatModel.userMembers.forEach((element) {
      userInChat[element.id] = true;
    });
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

  @action
  Future addUsersInChat() async {
    try {
      this.onLoading();
      await _apiProvider.addUsersInChat(
        chatId: chat!.chatModel.id,
        userIds: usersId,
      );
      chat!.messages.insert(
          0,
          MessageModel(
            id: "",
            number: 0,
            chatId: chat!.chatModel.id,
            senderUserId: chat!.chatModel.id,
            senderStatus: "",
            type: "",
            text: null,
            createdAt: DateTime.now(),
            medias: [],
            sender: chat!.chatModel.owner,
            infoMessage: InfoMessage(
              id: "",
              messageId: "",
              userId: chat!.chatModel.id,
              messageAction: "groupChatAddUser",
              user: null,
            ),
            star: null,
          ));
      availableUsers.forEach((element) {
        usersId.forEach((idUser) => {
              if (idUser == element.id)
                {
                  userInChat[idUser] = true,
                  chat!.chatModel.userMembers.add(ProfileMeResponse(
                    id: element.id,
                    avatarId: element.avatarId,
                    firstName: element.firstName,
                    lastName: element.lastName,
                    phone: element.phone,
                    tempPhone: element.tempPhone,
                    email: element.email,
                    additionalInfo: element.additionalInfo,
                    role: element.role,
                    avatar: element.avatar,
                    userSpecializations: element.userSpecializations,
                    ratingStatistic: element.ratingStatistic,
                    locationCode: element.locationCode,
                    locationPlaceName: element.locationPlaceName,
                    wagePerHour: element.wagePerHour,
                    workplace: element.workplace,
                    priority: element.priority,
                    questsStatistic: element.questsStatistic,
                    walletAddress: element.walletAddress,
                    isTotpActive: element.isTotpActive,
                    payPeriod: element.payPeriod,
                    workerProfileVisibilitySetting: element.workerProfileVisibilitySetting,
                  )),
                }
            });
      });
      chat!.update();
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future removeUserFromChat() async {
    if (userForDeleting.isNotEmpty)
      try {
        this.onLoading();
        userForDeleting.forEach((element) async {
          _apiProvider.removeUser(
            chatId: chat!.chatModel.id,
            userId: element,
          );
          for (int i = 0; i < chat!.chatModel.userMembers.length; i++)
            if (chat!.chatModel.userMembers[i].id == element)
              chat!.chatModel.userMembers
                  .remove(chat!.chatModel.userMembers[i]);
          chat!.messages.insert(
              0,
              MessageModel(
                id: "",
                number: 0,
                chatId: chat!.chatModel.id,
                senderUserId: chat!.chatModel.id,
                senderStatus: "",
                type: "",
                text: null,
                createdAt: DateTime.now(),
                medias: [],
                sender: chat!.chatModel.owner,
                infoMessage: InfoMessage(
                  id: "",
                  messageId: "",
                  userId: chat!.chatModel.id,
                  messageAction: "groupChatDeleteUser",
                  user: null,
                ),
                star: null,
              ));
        });
        userForDeleting.clear();
        this.onSuccess(true);
        chat!.update();
      } catch (e) {
        this.onError(e.toString());
      }
  }

  setMyRole(UserRole value) => myRole = value;

  @action
  getMessages(bool isPagination) async {
    if (chat!.messages.length >= _count && refresh) {
      return;
    }
    if (isPagination) _offset = chat!.messages.length;
    this.onLoading();
    final responseData = await _apiProvider.getMessages(
      chatId: chat!.chatModel.id,
      offset: _offset,
      limit: _limit,
    );

    _count = responseData["count"];
    final messages = List<MessageModel>.from(
        responseData["messages"].map((x) => MessageModel.fromJson(x)));
    chats.addAllMessages(messages, chat!.chatModel.id);

    chat!.messages.forEach((element) {
      if (idMessagesForStar[element.id] == null)
        idMessagesForStar[element.id] = false;
    });

    getThumbnail(messages);

    _offset = chat!.messages.length;
    refresh = true;
    this.onSuccess(true);
    chat!.update();
  }

  Future sendMessage(String text, String chatId, String userId) async {
    setSendingMessage(true);
    await sendImages(_apiProvider);
    WebSocket().sendMessage(
      chatId: chatId,
      text: text,
      medias: medias.map((media) => media.id).toList(),
    );
    progressImages.clear();
    // media.clear();
    setSendingMessage(false);
    _atomSendMessage.reportChanged();
  }
}
