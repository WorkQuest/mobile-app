import 'package:app/base_store/i_store.dart';
import 'package:app/http/api_provider.dart';
import 'package:app/repository/create_wallet_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

part 'create_wallet_store.g.dart';

@injectable
class CreateWalletStore extends _CreateWalletStore with _$CreateWalletStore {
  CreateWalletStore(ApiProvider apiProvider) : super(apiProvider);
}

abstract class _CreateWalletStore extends IStore<CreateWalletState> with Store {
  final ICreateWalletRepository _repository;

  _CreateWalletStore(ApiProvider apiProvider)
      : _repository = CreateWalletRepository(apiProvider);

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
  setMnemonic(String value) => mnemonic = value;

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
    try {
      mnemonic = _repository.generateMnemonic();
      onSuccess(CreateWalletState.generateMnemonic);
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  splitPhraseIntoWords() {
    try {
      setOfWords = ObservableList.of([]);
      final list = mnemonic!.split(' ').toList();
      final arg = _repository.randomPlaceWords(list);

      indexFirstWord = arg.indexFirst;
      indexSecondWord = arg.indexSecond;
      firstWord = arg.firstWord;
      secondWord = arg.secondWord;
      setOfWords!.addAll(arg.result);
      setOfWords!.shuffle();

      onSuccess(CreateWalletState.splitPhraseIntoWords);
    } catch (e) {
      onError(e.toString());
    }
  }

  @action
  openWallet() async {
    onLoading();
    try {
      await _repository.openWallet(mnemonic!);
      onSuccess(CreateWalletState.openWallet);
    } on FormatException catch (e) {
      onError(e.message);
    } catch (e) {
      onError(e.toString());
    }
  }
}

enum CreateWalletState { generateMnemonic, splitPhraseIntoWords, openWallet }
