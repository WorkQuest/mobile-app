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
  String? selectedFirstWord;

  @observable
  String? selectedSecondWord;

  @observable
  ObservableList<String>? setOfWords;

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
    mnemonic = AddressService().generateMnemonic();
    final list = mnemonic!.split(' ').toList();
    firstWord = list[2];
    secondWord = list[6];
  }

  @action
  splitPhraseIntoWords() {
    setOfWords = ObservableList.of([]);

    final _random = Random();

    final list = mnemonic!.split(' ').toList();

    for (var i = list.length - 1; i > 4; i--) {
      var n = _random.nextInt(i + 1);
      if (setOfWords!.length == 7) {
        break;
      }
      while (setOfWords!.contains(list[n])) {
        n = _random.nextInt(i + 1);
      }
      setOfWords!.add(list[n]);
    }
    if (!setOfWords!.contains(firstWord)) {
      setOfWords!.removeLast();
      setOfWords!.add(firstWord!);
    }
    if (!setOfWords!.contains(secondWord)) {
      setOfWords!.removeLast();
      setOfWords!.add(secondWord!);
    }
    setOfWords!.shuffle();
  }

  @action
  openWallet() async {
    onLoading();
    try {
      Wallet wallet = await Wallet.derive(mnemonic!);
      await _apiProvider.registerWallet(wallet.publicKey!, wallet.address!);
      await Storage.write("wallets", jsonEncode([wallet.toJson()]));
      await Storage.write("address", wallet.address!);
      AccountRepository().userAddress = wallet.address;
      AccountRepository().addWallet(wallet);
      onSuccess(true);
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }
}
