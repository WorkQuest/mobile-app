import 'dart:io';

import 'package:app/http/api_provider.dart';
import 'package:app/repository/open_dispute_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:app/base_store/i_store.dart';

part 'open_dispute_store.g.dart';

@injectable
class OpenDisputeStore extends _OpenDisputeStore with _$OpenDisputeStore {
  OpenDisputeStore(ApiProvider _apiProvider) : super(_apiProvider);
}

abstract class _OpenDisputeStore extends IStore<OpenDisputeState> with Store {
  final IOpenDisputeRepository _repository;

  _OpenDisputeStore(ApiProvider apiProvider)
      : _repository = OpenDisputeRepository(apiProvider);

  @observable
  String theme = "dispute_page.theme";

  @observable
  String description = '';

  String fee = "";

  String resultDisputeId = '';

  @computed
  bool get isButtonEnable =>
      theme != "dispute_page.theme" &&
      description.isNotEmpty &&
      !this.isLoading;

  @action
  setDescription(String value) => description = value;

  @action
  setTheme(String theme) => this.theme = theme;

  @action
  getGasOpenDispute(String contractAddress) async {
    try {
      onLoading();
      fee = await _repository.getGasOpenDispute(contractAddress);
      onSuccess(OpenDisputeState.getGasOpenDispute);
    } on SocketException catch (_) {
      onError("Lost connection to server");
    }
  }

  @action
  openDispute(String questId, String contractAddress) async {
    try {
      resultDisputeId = '';
      this.onLoading();
      final result = await _repository.openDispute(
        theme: theme,
        description: description,
        questId: questId,
        contractAddress: contractAddress,
      );
      resultDisputeId = result;
      this.onSuccess(OpenDisputeState.openDispute);
    } catch (e, trace) {
      print('openDispute | $e\n$trace');
      this.onError(e.toString());
    }
  }
}

enum OpenDisputeState { getGasOpenDispute, openDispute }
