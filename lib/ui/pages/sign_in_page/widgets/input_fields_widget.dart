import 'package:app/constants.dart';
import 'package:app/ui/pages/sign_in_page/store/sign_in_store.dart';
import 'package:app/ui/widgets/default_textfield.dart';
import 'package:app/ui/widgets/dropdown_adaptive_widget.dart';
import 'package:app/utils/storage.dart';
import 'package:app/utils/validator.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const double _horizontalConstraints = 44.0;
const double _verticalConstraints = 24.0;

const _prefixConstraints = const BoxConstraints(
  maxHeight: _verticalConstraints,
  maxWidth: _horizontalConstraints,
  minHeight: _verticalConstraints,
  minWidth: _horizontalConstraints,
);

class InputFieldsWidget extends StatefulWidget {
  final SignInStore signInStore;

  const InputFieldsWidget({
    Key? key,
    required this.signInStore,
  }) : super(key: key);

  @override
  _InputFieldsWidgetState createState() => _InputFieldsWidgetState();
}

class _InputFieldsWidgetState extends State<InputFieldsWidget> {
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 0.0),
          child: DefaultTextField(
            controller: usernameController,
            keyboardType: TextInputType.emailAddress,
            onChanged: widget.signInStore.setUsername,
            validator: Validators.emailValidator,
            autofillHints: [AutofillHints.email],
            prefixIconConstraints: _prefixConstraints,
            prefixIcon: SvgPicture.asset(
              "assets/user.svg",
              color: Theme.of(context).iconTheme.color,
            ),
            hint: "signIn.username".tr(),
            inputFormatters: [],
            suffixIcon: null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
          child: DefaultTextField(
            controller: passwordController,
            isPassword: true,
            onChanged: widget.signInStore.setPassword,
            inputFormatters: [],
            prefixIconConstraints: _prefixConstraints,
            validator: Validators.passwordValidator,
            autofillHints: [AutofillHints.password],
            prefixIcon: SvgPicture.asset(
              "assets/lock.svg",
              color: Theme.of(context).iconTheme.color,
            ),
            hint: "signIn.password".tr(),
            suffixIcon: null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 16.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: SwitchNetworkWidget<Network>(
              colorText: Colors.black,
              items: Network.values,
              value: WalletRepository().notifierNetwork.value,
              onChanged: (value) {
                setState(() {
                  final _networkName =
                  (value as Network) == Network.mainnet ? NetworkName.workNetMainnet : NetworkName.workNetTestnet;
                  WalletRepository().setNetwork(_networkName);
                  Storage.write(StorageKeys.networkName.name, _networkName.name);
                });
                return value;
              },
            ),
          ),
        ),
      ],
    );
  }
}