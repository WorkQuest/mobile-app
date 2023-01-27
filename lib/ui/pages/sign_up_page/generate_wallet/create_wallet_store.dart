import 'dart:convert';
import 'dart:math';
import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/http/web3_extension.dart';
import 'package:app/utils/storage.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:app/web3/service/address_service.dart';
import 'package:app/web3/wallet.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'create_wallet_store.g.dart';

@injectable
class CreateWalletStore extends _CreateWalletStore with _$CreateWalletStore {
  CreateWalletStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _CreateWalletStore extends IStore<bool> with Store {
  final ApiProvider _apiProvider;

  _CreateWalletStore(this._apiProvider);

  @observable
  String? mnemonic;

  @observable
  bool isSaved = false;

  @observable
  String? firstWord;

  @observable
  String? secondWord;

  @observable
  int? indexFirstWord;

  @observable
  int? indexSecondWord;

  @observable
  String? selectedFirstWord;

  @observable
  String? selectedSecondWord;

  @observable
  ObservableList<String>? setOfWords;

  @action
  setMnemonic(String value) {
    mnemonic = value;
  }

  @action
  setIsSaved(bool value) => isSaved = value;

  @computed
  bool get statusGenerateButton =>
      selectedFirstWord == firstWord && selectedSecondWord == secondWord;

  @action
  selectFirstWord(String? value) => selectedFirstWord = value;

  @action
  selectSecondWord(String? value) => selectedSecondWord = value;

  @action
  generateMnemonic() {
    mnemonic = AddressService.generateMnemonic();
  }

  @action
  splitPhraseIntoWords() {
    setOfWords = ObservableList.of([]);
    final list = mnemonic!.split(' ').toList();
    setOfWords!.addAll(_listRandom(list));

    setOfWords!.shuffle();
  }

  List<String> _listRandom(List<String> list) {
    Random _random = Random();

    indexFirstWord = _random.nextInt(5) + 1;
    indexSecondWord = _random.nextInt(5) + 6;
    while (indexSecondWord == indexFirstWord) {
      indexSecondWord = _random.nextInt(11) + 1;
    }
    firstWord = list[indexFirstWord! - 1];
    secondWord = list[indexSecondWord! - 1];

    list.shuffle(_random);
    List<String> result = [];
    int i = 0;
    while (result.length < 5) {
      if (list[i] != firstWord && list[i] != secondWord) {
        result.add(list[i]);
      }
      i++;
    }
    result.add(firstWord!);
    result.add(secondWord!);
    result.shuffle(_random);
    return result;
  }

  @action
  openWallet() async {
    onLoading();
    try {
      await Future.delayed(const Duration(seconds: 1));
      Wallet wallet = await Wallet.derive(mnemonic!);
      await _apiProvider.registerWallet(wallet.publicKey!, wallet.address!);
      await Storage.write(StorageKeys.wallet.name, jsonEncode(wallet.toJson()));
      AccountRepository().setWallet(wallet);
      onSuccess(true);
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }
}
