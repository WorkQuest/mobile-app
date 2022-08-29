import 'package:app/constants.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/utils/dispute_util.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:app/web3/service/client_service.dart';
import 'package:decimal/decimal.dart';

abstract class IOpenDisputeRepository {
  Future<String> getGasOpenDispute(String contractAddress);

  Future<String> openDispute({
    required String theme,
    required String description,
    required String questId,
    required String contractAddress,
  });
}

class OpenDisputeRepository extends IOpenDisputeRepository {
  OpenDisputeRepository(ApiProvider apiProvider) : _apiProvider = apiProvider;

  final ApiProvider _apiProvider;

  @override
  Future<String> getGasOpenDispute(String contractAddress) async {
    try {
      final _client = WalletRepository().getClientWorkNet();
      final _contract = await _client.getDeployedContract("WorkQuest", contractAddress);
      final _function = _contract.function(WQContractFunctions.arbitration.name);
      final _gas = await _client.getEstimateGasCallContract(
        contract: _contract,
        function: _function,
        params: [],
        value: "1",
      );
      return _gas.toStringAsFixed(17);
    } catch (e) {
      print('OpenDisputeRepository getGasOpenDispute | error: $e');
      throw OpenDisputeException(e.toString());
    }
  }

  @override
  Future<String> openDispute({
    required String theme,
    required String description,
    required String questId,
    required String contractAddress,
  }) async {
    try {
      final _fee = await getGasOpenDispute(contractAddress);
      await Web3Utils.checkPossibilityTx(
        typeCoin: TokenSymbols.WQT,
        fee: Decimal.parse(_fee),
        amount: 0.0,
        isMain: true,
      );
      final result = await _apiProvider.openDispute(
        questId: questId,
        reason: DisputeUtil.getThemeValue(theme),
        problemDescription: description,
      );
      await WalletRepository().getClientWorkNet().handleEvent(
            function: WQContractFunctions.arbitration,
            contractAddress: contractAddress,
            value: "1",
          );
      return result;
    } catch (e) {
      print('OpenDisputeRepository openDispute | error: $e');
      throw OpenDisputeException(e.toString());
    }
  }
}

class OpenDisputeException implements Exception {
  final String message;

  OpenDisputeException([this.message = 'Unknown open dispute error']);

  @override
  String toString() => message;
}
