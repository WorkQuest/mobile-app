import 'package:app/constants.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/utils/web3_utils.dart';
import 'package:app/web3/contractEnums.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:app/web3/service/client_service.dart';
import 'package:decimal/decimal.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/web3dart.dart';

abstract class IRaiseViewsRepository {
  Future<BaseQuestResponse> getQuest(String questId);

  Future<bool> needApprove(BigInt price);

  Future approve(BigInt price);

  Future raiseViewProfile({
    required int levelGroup,
    required int period,
    required String amount,
  });

  Future raiseViewQuest({
    required int levelGroup,
    required int period,
    required String amount,
    required String contractAddress,
  });

  Future<String> getGasRaiseViewProfile({
    required int levelGroup,
    required int period,
  });

  Future<String> getGasRaiseViewQuest({
    required int levelGroup,
    required int period,
    required String amount,
    required String contractAddress,
  });

  Future<String> getGasApprove(BigInt price);
}

class RaiseViewsRepository implements IRaiseViewsRepository {
  RaiseViewsRepository(ApiProvider apiProvider) : _apiProvider = apiProvider;

  final ApiProvider _apiProvider;

  @override
  Future approve(BigInt price) async {
    final _client = WalletRepository().getClientWorkNet();
    try {
      final _fee = await getGasApprove(price);
      await Web3Utils.checkPossibilityTx(
        typeCoin: TokenSymbols.WUSD,
        fee: Decimal.parse(_fee),
        amount: (Decimal.fromBigInt(price) / Decimal.fromInt(10).pow(18)).toDouble(),
      );
      await _client.approveCoin(
        price: price,
        address: EthereumAddress.fromHex(Web3Utils.getAddressWorknetWQPromotion()),
      );
    } catch (e) {
      print('RaiseViewsRepository approve | error: $e');
      throw RaiseViewException(e.toString());
    } finally {
      _client.client?.dispose();
      _client.stream?.cancel();
    }
  }



  @override
  Future<String> getGasApprove(BigInt price) async {
    final _client = WalletRepository().getClientWorkNet();
    try {
      final _contract = Erc20(address: EthereumAddress.fromHex(Web3Utils.getAddressWUSD()), client: _client.client!);
      final result = await _client.getEstimateGasCallContract(
        contract: _contract.self,
        function: _contract.self.abi.functions[1],
        params: [
          EthereumAddress.fromHex(Web3Utils.getAddressWUSD()),
          price,
        ],
      );
      return result.toStringAsFixed(17);
    } catch (e) {
      print('RaiseViewsRepository getGasApprove | error: $e');
      throw RaiseViewException(e.toString());
    } finally {
      _client.client?.dispose();
      _client.stream?.cancel();
    }
  }

  @override
  Future<String> getGasRaiseViewProfile({required int levelGroup, required int period}) async {
    final _client = WalletRepository().getClientWorkNet();
    try {
      final _contractPromote =
          await _client.getDeployedContract("WQPromotion", Web3Utils.getAddressWorknetWQPromotion());
      final result = await _client.getEstimateGasCallContract(
        contract: _contractPromote,
        function: _contractPromote.function(WQPromotionFunctions.promoteUser.name),
        params: [
          BigInt.from(levelGroup),
          BigInt.from(period),
        ],
      );
      return result.toStringAsFixed(17);
    } catch (e) {
      print('RaiseViewsRepository getGasRaiseViewProfile | error: $e');
      throw RaiseViewException(e.toString());
    } finally {
      _client.client?.dispose();
      _client.stream?.cancel();
    }
  }

  @override
  Future<String> getGasRaiseViewQuest({
    required int levelGroup,
    required int period,
    required String amount,
    required String contractAddress,
  }) async {
    final _client = WalletRepository().getClientWorkNet();
    try {
      final _contractPromote =
          await _client.getDeployedContract("WQPromotion", Web3Utils.getAddressWorknetWQPromotion());
      final result = await _client.getEstimateGasCallContract(
        contract: _contractPromote,
        function: _contractPromote.function(WQPromotionFunctions.promoteQuest.name),
        params: [
          EthereumAddress.fromHex(contractAddress),
          BigInt.from(levelGroup),
          BigInt.from(period),
        ],
      );
      return result.toStringAsFixed(17);
    } catch (e) {
      print('RaiseViewsRepository getGasRaiseViewQuest | error: $e');
      throw RaiseViewException(e.toString());
    } finally {
      _client.client?.dispose();
      _client.stream?.cancel();
    }
  }

  @override
  Future<BaseQuestResponse> getQuest(String questId) async {
    try {
      return await _apiProvider.getQuest(id: questId);
    } catch (e) {
      print('RaiseViewsRepository getQuest | error: $e');
      throw RaiseViewException(e.toString());
    }
  }

  @override
  Future<bool> needApprove(BigInt price) async {
    final _client = WalletRepository().getClientWorkNet();
    try {
      final _allowance = await _client.allowanceCoin(
        address: EthereumAddress.fromHex(Web3Utils.getAddressWorknetWQPromotion()),
      );
      print('_allowance: $_allowance');
      return _allowance < price;
    } catch (e) {
      print('RaiseViewsRepository needApprove | error: $e');
      throw RaiseViewException(e.toString());
    } finally {
      _client.client?.dispose();
      _client.stream?.cancel();
    }
  }

  @override
  Future raiseViewProfile({required int levelGroup, required int period, required String amount}) async {
    final _client = WalletRepository().getClientWorkNet();
    try {
      final _fee = await getGasRaiseViewProfile(levelGroup: levelGroup, period: period);
      await Web3Utils.checkPossibilityTx(
        typeCoin: TokenSymbols.WUSD,
        fee: Decimal.parse(_fee),
        amount: double.parse(amount),
      );
      await _client.promoteUser(
        tariff: levelGroup,
        period: period,
      );
    } catch (e) {
      print('RaiseViewsRepository raiseViewProfile | error: $e');
      throw RaiseViewException(e.toString());
    } finally {
      _client.client?.dispose();
      _client.stream?.cancel();
    }
  }

  @override
  Future raiseViewQuest({
    required int levelGroup,
    required int period,
    required String amount,
    required String contractAddress,
  }) async {
    final _client = WalletRepository().getClientWorkNet();
    try {
      final _fee = await getGasRaiseViewQuest(
        levelGroup: levelGroup,
        period: period,
        amount: amount,
        contractAddress: contractAddress,
      );
      await Web3Utils.checkPossibilityTx(
        typeCoin: TokenSymbols.WUSD,
        fee: Decimal.parse(_fee),
        amount: double.parse(amount),
      );
      await _client.promoteQuest(
        tariff: levelGroup,
        period: period,
        questAddress: contractAddress,
      );
    } catch (e) {
      print('RaiseViewsRepository raiseViewProfile | error: $e');
      throw RaiseViewException(e.toString());
    } finally {
      _client.client?.dispose();
      _client.stream?.cancel();
    }
  }
}

class RaiseViewException implements Exception {
  final String message;

  RaiseViewException([this.message = 'Unknown raise view error']);

  @override
  String toString() => message;
}
