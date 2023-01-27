import 'package:app/main.dart';
import 'package:app/ui/pages/main_page/settings_page/store/settings_store.dart';
import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:app/ui/widgets/default_textfield.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/storage.dart';

import 'package:app/utils/validator.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';

import '../../../../../observer_consumer.dart';

final spacer = const SizedBox(
  height: 20.0,
);

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  static const String routeName = "/changePasswordPage";

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late final _formKey;

  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmNewPasswordController;

  late SettingsPageStore store;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    store = context.read<SettingsPageStore>();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmNewPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          automaticallyImplyLeading: true,
          middle: Text("settings.changePass".tr()),
        ),
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _FormTextField(
                    controller: _currentPasswordController,
                    title: "modals.currentPassword".tr(),
                    hint: "modals.currentPassword".tr(),
                    onChanged: store.setPassword,
                    validator: Validators.signUpPasswordValidator,
                  ),
                  spacer,
                  _FormTextField(
                    controller: _newPasswordController,
                    title: "modals.newPassword".tr(),
                    hint: "modals.newPassword".tr(),
                    onChanged: store.setNewPassword,
                    validator: Validators.signUpPasswordValidator,
                  ),
                  spacer,
                  _FormTextField(
                    controller: _confirmNewPasswordController,
                    title: "modals.confirmNewPassword".tr(),
                    hint: "modals.confirmNewPassword".tr(),
                    onChanged: store.setConfirmNewPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 8) {
                        return "modals.lengthPassword".tr();
                      }
                      if (value != _newPasswordController.text) {
                        return "modals.mustMatchNewPassword".tr();
                      }
                      return null;
                    },
                  ),
                  spacer,
                  ObserverListener<SettingsPageStore>(
                    onFailure: () {
                      return false;
                    },
                    onSuccess: () {
                      Navigator.pop(context);
                    },
                    child: Observer(
                      builder: (context) {
                        return LoginButton(
                          enabled: store.isLoading,
                          onTap: store.canSubmit
                              ? () async {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    _changePasswordOnPressed();
                                  }
                                }
                              : null,
                          title: "meta.submit".tr(),
                        );
                      },
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _changePasswordOnPressed() async {
    await store.changePassword();
    if (store.isSuccess) {
      await store.deleteToken();
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        SignInPage.routeName,
        (route) => false,
      );
      AccountRepository().clearData();
      Storage.deleteAllFromSecureStorage();
      AlertDialogUtils.showInfoAlertDialog(
        navigatorKey.currentState!.context,
        title: "Success",
        content: "Login with new password",
      );
    }
  }
}

class _FormTextField extends StatelessWidget {
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final Function(String) onChanged;
  final String title;
  final String hint;

  const _FormTextField({
    Key? key,
    required this.title,
    required this.hint,
    required this.validator,
    required this.onChanged,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(
          height: 5.0,
        ),
        DefaultTextField(
          controller: controller,
          onChanged: onChanged,
          isPassword: true,
          hint: hint,
          validator: validator,
          suffixIcon: null,
          inputFormatters: [],
        ),
      ],
    );
  }
}
