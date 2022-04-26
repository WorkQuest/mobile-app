import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:web3dart/credentials.dart';
import '../../../../../../../enums.dart';
import '../../../../../../../web3/contractEnums.dart';
import '../../../../../../../web3/service/client_service.dart';

part 'user_profile_store.g.dart';

@singleton
class UserProfileStore extends _UserProfileStore with _$UserProfileStore {
  UserProfileStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _UserProfileStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;
  ProfileMeResponse? userData;
  ProfileMeResponse? questHolder;

  @observable
  ObservableList<BaseQuestResponse> quests = ObservableList.of([]);

  _UserProfileStore(
    this._apiProvider,
  );

  int offset = 0;

  String workerId = "";

  // @observable
  // String questName = "";

  @observable
  String questId = "";

  @observable
  String contractAddress = "";

  @action
  void setQuest(String id, String contractAddress) {
    // questName = index ?? "";
    questId = id;
    this.contractAddress = contractAddress;
  }

  @action
  Future<void> startQuest({
    required String userId,
    required String userAddress,
  }) async {
    try {
      this.onLoading();
      final user = await _apiProvider.getProfileUser(userId: userId);
      final quest = await _apiProvider.getQuest(id: questId);
      await _apiProvider.inviteOnQuest(
        questId: questId,
        userId: userId,
        message: "quests.inviteToQuest".tr(),
      );
      await ClientService().handleEvent(
        function: WQContractFunctions.assignJob,
        contractAddress: quest.contractAddress!,
        params: [
          EthereumAddress.fromHex(user.walletAddress!),
        ],
      );
      this.onSuccess(true);
    } catch (e) {
      print("getQuests error: $e");
      this.onError(e.toString());
    }
  }

  // void removeOddQuests() {
  //   for (int i = 0; i < quests.length; i++) {
  //     if (quests[i].responded?.workerId == workerId ||
  //         quests[i].invited?.workerId == workerId) {
  //       quests.removeAt(i);
  //       i--;
  //     }
  //   }
  //   quests.removeWhere((element) => element.title == questName);
  // }

  Future<void> getQuests({
    required String userId,
    required UserRole role,
    required bool newList,
    required bool isProfileYours,
  }) async {
    try {
      if (newList) quests.clear();
      if (offset == quests.length) {
        this.onLoading();
        //TODO:offset scroll
        if (role == UserRole.Employer) {
          quests.addAll(isProfileYours
              ? await _apiProvider.getQuests(
            offset: offset,
            performing: true,
            invited: false,
            sort: "sort[createdAt]=desc",
          )
              : await _apiProvider.getEmployerQuests(
            userId: userId,
            offset: offset,
            performing: true,
            invited: false,
            sort: "sort[createdAt]=desc",
          ));
        }
        if (role == UserRole.Worker) {
          quests.addAll(await _apiProvider.getAvailableQuests(
            userId: userId,
            offset: offset,
          ));
        }

        quests.toList().sort((key1, key2) =>
        key1.createdAt.millisecondsSinceEpoch <
            key2.createdAt.millisecondsSinceEpoch
            ? 1
            : 0);
        offset += 10;
        this.onSuccess(true);
      }
    } catch (e, trace) {
      print("getQuests error: $e\n$trace");
      this.onError(e.toString());
    }
  }
}
