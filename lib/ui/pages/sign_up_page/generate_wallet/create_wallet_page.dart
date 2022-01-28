import 'package:app/di/injector.dart';
import 'package:app/ui/pages/sign_up_page/generate_wallet/create_wallet_store.dart';
import 'package:app/ui/pages/sign_up_page/generate_wallet/verify_wallet.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../../../constants.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

class CreateWalletPage extends StatefulWidget {
  const CreateWalletPage({Key? key}) : super(key: key);

  @override
  _CreateWalletPageState createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<CreateWalletPage> {
  @override
  void initState() {
    super.initState();
    final _store = context.read<CreateWalletStore>();
    _store.generateMnemonic();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.read<CreateWalletStore>();
    return Observer(
      builder: (_) => WillPopScope(
        onWillPop: () {
          //TODO: Correct
          Future<bool> close = Future.value(false);
          AlertDialogUtils.showAlertDialog(
            context,
            title: const Text('Warning!'),
            content: const Text(
                'If you leave the page, you will not link the wallet to your profile.\nAre you sure?'),
            needCancel: true,
            titleCancel: "Cancel",
            titleOk: "Return",
            onTabCancel: null,
            onTabOk: () => Navigator.pop(context),
            colorCancel: AppColor.enabledButton,
            colorOk: Colors.red,
          );
          return close;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CupertinoNavigationBar(),
          body: Padding(
            padding: _padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Save this phrase to be able to login in next time',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                _YourPhrase(phrase: store.mnemonic),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    const Text(
                      'I’ve saved mnemonic phrase',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Switch.adaptive(
                      value: store.isSaved,
                      activeColor: AppColor.enabledButton,
                      onChanged: (value) => store.setIsSaved(value),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text('Next'),
                      onPressed: store.isSaved
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Provider(
                                    create: (_) => store,
                                    child: const VerifyWalletPage(),
                                  ),
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _YourPhrase extends StatelessWidget {
  final String? phrase;

  const _YourPhrase({
    required this.phrase,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your phrase',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 11.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: AppColor.disabledButton,
            ),
          ),
          child: Text(
            phrase ?? "",
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xff1D2127),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 171,
          child: ElevatedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: phrase));
              SnackBarUtils.success(
                context,
                title: 'Copied!',
                duration: const Duration(milliseconds: 250),
              );
            },
            child: Text('Copy phrase'),
          ),
        ),
      ],
    );
  }
}
