import 'dart:io';

import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:web3dart/credentials.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../../../../web3/contractEnums.dart';
import '../../../../../../../../web3/repository/account_repository.dart';
import '../../../../../../../../web3/service/client_service.dart';

part 'choose_quest_store.g.dart';

@injectable
class ChooseQuestStore extends _ChooseQuestStore with _$ChooseQuestStore {
  ChooseQuestStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _ChooseQuestStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _ChooseQuestStore(this._apiProvider);

  int offset = 0;

  ProfileMeResponse? user;

  @observable
  ObservableList<BaseQuestResponse> quests = ObservableList.of([]);

  @observable
  String questId = "";

  String fee = "";

  @observable
  String contractAddress = "";

  @action
  void setQuest(String id, String contractAddress) {
    questId = id;
    this.contractAddress = contractAddress;
  }

  @action
  Future<void> getUser({
    required String userId,
  }) async {
    try {
      this.onLoading();
      user = await _apiProvider.getProfileUser(userId: userId);
      this.onSuccess(true);
    } catch (e) {
      this.onError(e.toString());
    }
  }

  @action
  Future<void> getQuests({
    required String userId,
    required bool newList,
    required bool isProfileYours,
  }) async {
    try {
      this.onLoading();
      if (newList) {
        quests.clear();
        offset = 0;
      }
      if (offset == quests.length) {
        quests.addAll(await _apiProvider.getAvailableQuests(
          userId: userId,
          offset: offset,
        ));

        quests.toList().sort(
            (key1, key2) => key1.createdAt!.millisecondsSinceEpoch < key2.createdAt!.millisecondsSinceEpoch ? 1 : 0);
        offset += 10;
        this.onSuccess(true);
      }
    } catch (e) {
      this.onError(e.toString());
    }
  }

  Future<void> getFee(String userId) async {
    try {
      final _gas = await getEstimateGas(userId);
      fee = _gas.toStringAsFixed(17);
    } on SocketException catch (_) {
      onError("Lost connection to server");
    }
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
      await AccountRepository().getClientWorkNet().handleEvent(
            function: WQContractFunctions.assignJob,
            contractAddress: quest.contractAddress!,
            params: [
              EthereumAddress.fromHex(user.walletAddress!),
            ],
            value: null,
          );
      this.onSuccess(true);
    } catch (e) {
      print("getQuests error: $e");
      this.onError(e.toString());
    }
  }

  Future<double> getEstimateGas(String userId) async {
    final _client = AccountRepository().getClientWorkNet();
    final _user = await _apiProvider.getProfileUser(userId: userId);
    final _contract = await _client.getDeployedContract("WorkQuest", contractAddress);
    final _function = _contract.function(WQContractFunctions.assignJob.name);
    final _params = [EthereumAddress.fromHex(_user.walletAddress!)];
    final _estimateGas = _client.getEstimateGasCallContract(
      contract: _contract,
      function: _function,
      params: _params,
    );
    return _estimateGas;
  }
}
