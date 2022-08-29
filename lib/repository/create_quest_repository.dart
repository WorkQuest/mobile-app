import 'package:app/constants.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/entity/create_quest_request_model.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:app/web3/service/client_service.dart';
import 'package:decimal/decimal.dart';
import 'package:web3dart/web3dart.dart';

abstract class ICreateQuestRepository {
  Future editQuest({
    required CreateQuestRequestModel quest,
    required String questId,
    required String contractAddress,
  });

  Future createQuest({required CreateQuestRequestModel quest});

  Future approve({required String? contractAddress, required String price});

  Future<bool> needApprove(
      {required String price, required String? contractAddress});

  Future<String> getGasApprove({required String price});

  Future<String> getGasEditQuest(
      {required String price, required String contractAddress});

  Future<String> getGasCreateQuest(
      {required String price, required String description});
}

class CreateQuestRepository extends ICreateQuestRepository {
  CreateQuestRepository(ApiProvider apiProvider) : _apiProvider = apiProvider;

  final ApiProvider _apiProvider;

  @override
  Future createQuest({required CreateQuestRequestModel quest}) async {
    final _client = WalletRepository().getClientWorkNet();
    try {
      final gas = await getGasCreateQuest(
          price: quest.price!, description: quest.description!);
      await Web3Utils.checkPossibilityTx(
        typeCoin: TokenSymbols.WUSD,
        fee: Decimal.parse(gas.toString()),
        amount: (Decimal.parse(quest.price!) / Decimal.fromInt(10).pow(18))
            .toDouble(),
        isMain: true,
      );
      final nonce = await _apiProvider.createQuest(
        quest: quest,
      );

      await _client.createNewContract(
        jobHash: quest.description!,
        price: Decimal.parse(quest.price!).toBigInt(),
        deadline: 0.toString(),
        nonce: nonce,
      );
    } catch (e) {
      print('CreateQuestRepository createQuest | error: $e');
      throw CreateQuestException(e.toString());
    }
    _client.stream?.cancel();
    _client.client?.dispose();
  }

  @override
  Future editQuest({
    required CreateQuestRequestModel quest,
    required String questId,
    required String contractAddress,
  }) async {
    final _client = WalletRepository().getClientWorkNet();
    try {
      final gas = await getGasEditQuest(
          price: quest.price!, contractAddress: contractAddress);
      await Web3Utils.checkPossibilityTx(
        typeCoin: TokenSymbols.WUSD,
        fee: Decimal.parse(gas.toString()),
        amount: (Decimal.parse(quest.price!) / Decimal.fromInt(10).pow(18))
            .toDouble(),
        isMain: true,
      );
      await _client.handleEvent(
        function: WQContractFunctions.editJob,
        contractAddress: contractAddress,
        params: [
          Decimal.parse(quest.price!).toBigInt(),
        ],
        value: null,
      );
      quest = quest.editQuest();
      await _apiProvider.editQuest(
        quest: quest,
        questId: questId,
      );
    } catch (e) {
      print('CreateQuestRepository editQuest | error: $e');
      throw CreateQuestException(e.toString());
    }
    _client.stream?.cancel();
    _client.client?.dispose();
  }

  @override
  Future<bool> needApprove(
      {required String price, required String? contractAddress}) async {
    final _client = WalletRepository().getClientWorkNet();
    try {
      final _priceForApprove = Decimal.parse(price) *
          Decimal.parse(Constants.commissionForQuest.toString());
      final _allowance = await _client.allowanceCoin(
          address: contractAddress == null
              ? null
              : EthereumAddress.fromHex(contractAddress));
      _client.stream?.cancel();
      _client.client?.dispose();
      return _allowance < _priceForApprove.toBigInt();
    } catch (e) {
      _client.stream?.cancel();
      _client.client?.dispose();
      print('CreateQuestRepository needApprove | error: $e');
      throw CreateQuestException(e.toString());
    }
  }

  @override
  Future approve(
      {required String? contractAddress, required String price}) async {
    final _client = WalletRepository().getClientWorkNet();
    try {
      final _price = Decimal.parse(price);
      final _priceForApprove =
          _price * Decimal.parse(Constants.commissionForQuest.toString());
      final _isEdit = contractAddress != null;
      final gas = await getGasApprove(price: price);
      await Web3Utils.checkPossibilityTx(
        typeCoin: TokenSymbols.WUSD,
        fee: Decimal.parse(gas.toString()),
        amount: (Decimal.parse(price) / Decimal.fromInt(10).pow(18)).toDouble(),
        isMain: true,
      );
      await WalletRepository().getClientWorkNet().approveCoin(
            price: _priceForApprove.toBigInt(),
            address: _isEdit ? EthereumAddress.fromHex(contractAddress!) : null,
          );
    } catch (e) {
      _client.stream?.cancel();
      _client.client?.dispose();
      print('CreateQuestRepository approve | error: $e');
      throw CreateQuestException(e.toString());
    }
  }

  @override
  Future<String> getGasApprove({required String price}) async {
    final _client = WalletRepository().getClientWorkNet();
    try {
      final _price = Decimal.parse(price);
      final _gasForApprove =
          await _client.getEstimateGasForApprove(_price.toBigInt());
      _client.stream?.cancel();
      _client.client?.dispose();
      return _gasForApprove.toStringAsFixed(17);
    } catch (e) {
      _client.stream?.cancel();
      _client.client?.dispose();
      print('CreateQuestRepository getGasApprove | error: $e');
      throw CreateQuestException(e.toString());
    }
  }

  @override
  Future<String> getGasEditQuest(
      {required String price, required String contractAddress}) async {
    final _client = WalletRepository().getClientWorkNet();
    try {
      final _price = Decimal.parse(price);
      final _contract =
          await _client.getDeployedContract("WorkQuest", contractAddress);
      final _function = _contract.function(WQContractFunctions.editJob.name);
      final _params = [
        _price.toBigInt(),
      ];
      final _gas = await _client.getEstimateGasCallContract(
          contract: _contract, function: _function, params: _params);
      _client.stream?.cancel();
      _client.client?.dispose();
      return _gas.toStringAsFixed(17);
    } catch (e) {
      _client.stream?.cancel();
      _client.client?.dispose();
      print('CreateQuestRepository getGasEditQuest | error: $e');
      throw CreateQuestException(e.toString());
    }
  }

  @override
  Future<String> getGasCreateQuest(
      {required String price, required String description}) async {
    final _client = WalletRepository().getClientWorkNet();
    try {
      final _contract = await _client.getDeployedContract(
          "WorkQuestFactory", Web3Utils.getAddressWorknetWQFactory());
      final _function =
          _contract.function(WQFContractFunctions.newWorkQuest.name);
      final _params = [
        _client.stringToBytes32(description),
        BigInt.zero,
        BigInt.from(0.0),
        BigInt.from(0.0),
      ];
      final _gas = await _client.getEstimateGasCallContract(
          contract: _contract, function: _function, params: _params);
      _client.stream?.cancel();
      _client.client?.dispose();
      return _gas.toStringAsFixed(17);
    } catch (e) {
      _client.stream?.cancel();
      _client.client?.dispose();
      print('CreateQuestRepository getGasCreateQuest | error: $e');
      throw CreateQuestException(e.toString());
    }
  }
}

class CreateQuestException implements Exception {
  final String message;

  CreateQuestException([this.message = 'Unknown create quest error']);

  @override
  String toString() => message;
}
