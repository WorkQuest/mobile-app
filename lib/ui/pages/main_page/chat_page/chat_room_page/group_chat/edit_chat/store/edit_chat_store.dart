import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/http/chat_extension.dart';
import 'package:app/model/chat_model/member.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'edit_chat_store.g.dart';

@injectable
class EditChatStore extends _EditChatStore with _$EditChatStore {
  EditChatStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _EditChatStore extends IStore<bool> with Store {
  _EditChatStore(this._apiProvider);

  final ApiProvider _apiProvider;

  @observable
  ObservableMap<ProfileMeResponse, bool> users = ObservableMap.of({});

  @observable
  ObservableList<ProfileMeResponse> foundUsers = ObservableList.of([]);

  @observable
  String userName = "";

  List<String> userIds = [];

  @computed
  bool get isSelectedUsers {
    for (int i = 0; i < users.length; i++)
      if (users.values.toList()[i] == true) return true;
    return false;
  }

  void getUserIds() {}

  void getChatMembers(List<Member> members) {
    members.forEach((element) {
      users[element.user!] = false;
    });
  }

  void getIds() {
    users.forEach((key, value) {
      if (value == true) userIds.add(key.id!);
    });
  }

  Future<void> removeUser(String chatId, String userId) async {
    try {
      this.onLoading();
      await _apiProvider.removeUser(chatId: chatId, userId: userId);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  Future<void> addUsers(String chatId) async {
    try {
      this.onLoading();
      getIds();
      await _apiProvider.addUsersInChat(chatId: chatId, userIds: userIds);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future<void> getUsersForChat(String chatId) async {
    try {
      this.onLoading();
      final response =
          await _apiProvider.getUsersForChat(excludeMembersChatId: chatId);
      response.forEach((element) {
        users[element] = false;
      });
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

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
}
