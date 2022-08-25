import 'dart:convert';
import 'dart:math';

import 'package:app/http/api_provider.dart';
import 'package:app/http/web3_extension.dart';
import 'package:app/utils/storage.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:app/web3/service/address_service.dart';
import 'package:app/web3/wallet.dart';

abstract class ICreateWalletRepository {
  String generateMnemonic();

  _RandomWordsArguments randomPlaceWords(List<String> list);

  Future openWallet(String mnemonic);
}

class CreateWalletRepository extends ICreateWalletRepository {
  CreateWalletRepository(ApiProvider apiProvider) : _apiProvider = apiProvider;

  final ApiProvider _apiProvider;

  @override
  String generateMnemonic() {
    try {
      return AddressService.generateMnemonic();
    } catch (e) {
      print('CreateWalletRepository generateMnemonic | error: $e');
      throw CreateWalletException('Error generate mnemonic');
    }
  }

  @override
  Future openWallet(String mnemonic) async {
    try {
      Wallet wallet = await Wallet.derive(mnemonic);
      await _apiProvider.registerWallet(wallet.publicKey!, wallet.address!);
      await Storage.write(StorageKeys.wallet.name, jsonEncode(wallet.toJson()));
      WalletRepository().setWallet(wallet);
    } catch (e) {
      print('CreateWalletRepository openWallet | error: $e');
      throw CreateWalletException(e.toString());
    }
  }

  @override
  _RandomWordsArguments randomPlaceWords(List<String> list) {
    try {
      Random _random = Random();

      int indexFirst = _random.nextInt(5) + 1;
      int indexSecond = _random.nextInt(5) + 6;
      while (indexSecond == indexFirst) {
        indexSecond = _random.nextInt(11) + 1;
      }
      String firstWord = list[indexFirst - 1];
      String secondWord = list[indexSecond - 1];

      list.shuffle(_random);
      List<String> result = [];
      int i = 0;
      while (result.length < 5) {
        if (list[i] != firstWord && list[i] != secondWord) {
          result.add(list[i]);
        }
        i++;
      }
      result.add(firstWord);
      result.add(secondWord);
      result.shuffle(_random);
      return _RandomWordsArguments(
        indexFirst: indexFirst,
        indexSecond: indexSecond,
        firstWord: firstWord,
        secondWord: secondWord,
        result: result,
      );
    } catch (e) {
      print('CreateWalletRepository randomPlaceWords | error: $e');
      throw CreateWalletException('Error random list');
    }
  }
}

class CreateWalletException implements Exception {
  final String message;

  const CreateWalletException([this.message = 'Unknown create wallet error']);

  @override
  String toString() => message;
}

class _RandomWordsArguments {
  final int indexFirst;
  final int indexSecond;
  final String firstWord;
  final String secondWord;
  final List<String> result;

  const _RandomWordsArguments({
    required this.indexFirst,
    required this.indexSecond,
    required this.firstWord,
    required this.secondWord,
    required this.result,
  });
}
