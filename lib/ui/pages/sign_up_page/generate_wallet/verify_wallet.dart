import 'package:app/ui/pages/pin_code_page/pin_code_page.dart';
import 'package:app/ui/pages/sign_up_page/generate_wallet/create_wallet_store.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/modal_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import '../../../../constants.dart';
import '../../../../observer_consumer.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);
const _errorColor = Colors.red;

class VerifyWalletPage extends StatefulWidget {
  const VerifyWalletPage();

  @override
  _VerifyWalletPageState createState() => _VerifyWalletPageState();
}

class _VerifyWalletPageState extends State<VerifyWalletPage> {
  late final CreateWalletStore store;

  @override
  void initState() {
    super.initState();
    store = context.read<CreateWalletStore>();
    store.splitPhraseIntoWords();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<CreateWalletStore>();
    final String firstWord;
    final String secondWord;
    if (store.indexFirstWord == 1) {
      firstWord = '${store.indexFirstWord}st';
    } else if (store.indexFirstWord == 2) {
      firstWord = '${store.indexFirstWord}nd';
    } else if (store.indexFirstWord == 3) {
      firstWord = '${store.indexFirstWord}rd';
    } else {
      firstWord = '${store.indexFirstWord}th';
    }
    if (store.indexSecondWord == 1) {
      secondWord = '${store.indexSecondWord}st';
    } else if (store.indexSecondWord == 2) {
      secondWord = '${store.indexSecondWord}nd';
    } else if (store.indexSecondWord == 3) {
      secondWord = '${store.indexSecondWord}rd';
    } else {
      secondWord = '${store.indexSecondWord}th';
    }
    return ObserverListener<CreateWalletStore>(
      onFailure: () {
        Navigator.of(context, rootNavigator: true).pop();
        return false;
      },
      onSuccess: () async {
        Navigator.of(context, rootNavigator: true).pop();
        await AlertDialogUtils.showSuccessDialog(context);
        Navigator.pushNamed(
          context,
          PinCodePage.routeName,
        );
      },
      child: Observer(
        builder: (_) => Scaffold(
          appBar: CupertinoNavigationBar(),
          body: Container(
            color: Colors.white,
            padding: _padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'signUp.chooseWords'.tr(
                    namedArgs: {'firstIndex': '$firstWord', 'secondIndex': '$secondWord'},
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'signUp.firstWord'.tr(
                    namedArgs: {
                      'index': '$firstWord',
                    },
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _WordsWidget(
                  words: store.setOfWords!.toList(),
                  onTab: _pressedOnWord,
                  isFirst: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'signUp.secondWord'.tr(
                    namedArgs: {
                      'index': '$secondWord',
                    },
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _WordsWidget(
                  words: store.setOfWords!.toList(),
                  onTab: _pressedOnWord,
                  isFirst: false,
                ),
                Expanded(child: Container()),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 10.0,
                  ),
                  width: double.infinity,
                  child: LoginButton(
                    title: 'wallet.openWallet'.tr(),
                    onTap: store.statusGenerateButton && !store.isLoading ? _onPressedOnOpenWallet : null,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onPressedOnOpenWallet() {
    AlertDialogUtils.showLoadingDialog(context);
    store.openWallet();
  }

  void _pressedOnWord(String word, bool isFirstWord) async {
    final store = context.read<CreateWalletStore>();
    if (isFirstWord) {
      if (store.selectedFirstWord == null) {
        store.selectFirstWord(word);
      }
      if (store.selectedFirstWord != store.firstWord) {
        await _openModalBottomSheet();
        store.selectFirstWord(null);
        store.selectSecondWord(null);
      }
    } else {
      if (store.selectedSecondWord == null) {
        store.selectSecondWord(word);
      }
      if (store.selectedSecondWord != store.secondWord) {
        await _openModalBottomSheet();
        store.selectFirstWord(null);
        store.selectSecondWord(null);
      }
    }
  }

  Future<void> _openModalBottomSheet() async {
    await ModalBottomSheet.openModalBottomSheet(
      context,
      Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'modals.error'.tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 11,
              ),
              Text(
                'signUp.chosenWrongWords'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: ElevatedButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}

class _WordsWidget extends StatelessWidget {
  final Function(String, bool) onTab;
  final List<String> words;
  final bool isFirst;

  const _WordsWidget({
    Key? key,
    required this.onTab,
    required this.words,
    required this.isFirst,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = context.read<CreateWalletStore>();

    return Observer(
      builder: (_) => Wrap(
        children: words.map((word) {
          bool selectedWord;
          bool color;
          if (isFirst) {
            selectedWord = word == store.selectedFirstWord;
            color = store.selectedFirstWord == store.firstWord;
          } else {
            selectedWord = word == store.selectedSecondWord;
            color = store.selectedSecondWord == store.secondWord;
          }
          if (selectedWord) {
            return Container(
              margin: const EdgeInsets.only(right: 10.0, bottom: 10.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: AppColor.disabledButton,
                ),
                color: color ? AppColor.enabledButton : _errorColor,
              ),
              child: Text(
                word,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            );
          }
          return GestureDetector(
            onTap: () => onTab(word, isFirst),
            child: Container(
              margin: const EdgeInsets.only(right: 10.0, bottom: 10.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(
                  color: AppColor.disabledButton,
                ),
              ),
              child: Text(
                word,
                style: const TextStyle(fontSize: 16, color: Color(0xff4C5767)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
