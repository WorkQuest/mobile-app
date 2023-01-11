import 'package:app/ui/pages/pin_code_page/pin_code_page.dart';
import 'package:app/ui/pages/sign_up_page/generate_wallet/create_wallet_store.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/modal_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import '../../../../constants.dart';
import '../../../../observer_consumer.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);
const _errorColor = Colors.red;

class VerifyWalletPage extends StatefulWidget {
  const VerifyWalletPage() ;

  @override
  _VerifyWalletPageState createState() => _VerifyWalletPageState();
}

class _VerifyWalletPageState extends State<VerifyWalletPage> {

  @override
  void initState() {
    super.initState();
    final store = context.read<CreateWalletStore>();
    store.splitPhraseIntoWords();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<CreateWalletStore>();
    return Observer(
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
                'Choose the ${store.indexFirstWord}' == 1 ? 'st' : 'th' 'and ${store.indexSecondWord}' == 1 ? 'st' : 'th' 'words of your mnemonic',
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
                '${store.indexFirstWord}th word',
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
                '${store.indexSecondWord}th word',
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
                    bottom: MediaQuery.of(context).padding.bottom + 10.0),
                width: double.infinity,
                child: ObserverListener<CreateWalletStore>(
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
                  child: ElevatedButton(
                    child: Text('Confirm'),
                    onPressed: store.statusGenerateButton
                        ? () {
                            AlertDialogUtils.showLoadingDialog(context);
                            store.openWallet();
                          }
                        : null,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
            children: const [
              Text(
                'Error',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 11,
              ),
              Text(
                'You’ve chosen wrong words. Try again ',
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
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
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
