import 'package:app/base_store/i_store.dart';
import 'package:app/enums.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/http/chat_extension.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'group_chat_store.g.dart';

@injectable
class GroupChatStore extends _GroupChatStore with _$GroupChatStore {
  GroupChatStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _GroupChatStore extends IStore<bool> with Store {
  _GroupChatStore(this._apiProvider);

  final ApiProvider _apiProvider;

  @observable
  ObservableMap<ProfileMeResponse, bool> users = ObservableMap.of({});

  @observable
  ObservableList<ProfileMeResponse> foundUsers = ObservableList.of([]);

  @observable
  int index = 0;

  @observable
  String chatName = "";

  @observable
  String userName = "";

  @observable
  String userId = "";

  bool? isGroupChat;

  List<String> usersId = [];

  String idGroupChat = "";

  UserRole? myRole;

  String? ownerId;

  @computed
  bool get isSelectedUsers {
    for (int i = 0; i < users.length; i++)
      if (users.values.toList()[i] == true) return true;
    return false;
  }

  @action
  Future<void> getUsers() async {
    try {
      this.onLoading();
      final response = await _apiProvider.getUsersForChat();
      response.forEach((element) {
        users[element] = false;
      });
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  void setChatName(String value) => chatName = value;

  @action
  void findUser(String text) {
    userName = text;
    foundUsers.clear();
    users.keys.toList().forEach((element) {
      if (element.firstName.toLowerCase().contains(text.toLowerCase()) ||
          element.lastName.toLowerCase().contains(text.toLowerCase()))
        foundUsers.add(element);
    });
  }

  @action
  void setUserId(String value) => userId = value;

  void setGroupChat(bool value) {
    isGroupChat = value;
    value ? index = 0 : index = 1;
  }

  void getSelectedUsers() {
    users.forEach((key, value) {
      if (value == true) usersId.add(key.id);
    });
  }

  Future<void> createGroupChat() async {
    try {
      this.onLoading();
      final responseData = await _apiProvider.createGroupChat(
          chatName: chatName, usersId: usersId);
      idGroupChat = responseData["chat"]["id"];
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  void getOwnerInfo(ChatModel chat) {
    final ownerChatId = chat.groupChat!.ownerMemberId;
    chat.members!.forEach((element) {
      if (ownerChatId == element.id) {
        ownerId = element.userId;
        myRole = element.user!.role;
      }
    });
  }
}
