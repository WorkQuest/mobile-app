import 'package:app/di/injector.dart';
import 'package:app/main.dart';
import 'package:app/observer_consumer.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/change_password_page/store/change_password_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/change_password_page/widgets/form_text_field_widget.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/filter_quests_page/store/filter_quests_store.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_list_page/store/search_list_store.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:app/ui/widgets/login_button.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/storage.dart';

import 'package:app/utils/validator.dart';
import 'package:app/web3/repository/wallet_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import "package:provider/provider.dart";
import 'package:easy_localization/easy_localization.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

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

  late ChangePasswordStore store;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    store = context.read<ChangePasswordStore>();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmNewPasswordController = TextEditingController();
    super.initState();
  }

  _stateListener() {
    if (store.successData == ChangePasswordState.changePassword) {
      store.deleteToken();
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        SignInPage.routeName,
        (_) => false,
      );
      getIt.get<ProfileMeStore>().deletePushToken();
      getIt.get<SearchListStore>().clearData();
      getIt.get<FilterQuestsStore>().clearFilters();
      getIt.get<MyQuestStore>().clearData();
      final cookieManager = WebviewCookieManager();
      cookieManager.clearCookies();
      WalletRepository().clearData();
      Storage.deleteAllFromSecureStorage();
      AlertDialogUtils.showInfoAlertDialog(
        navigatorKey.currentState!.context,
        title: "Success",
        content: "Login with new password",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener<ChangePasswordStore>(
      onSuccess: _stateListener,
      onFailure: () => false,
      child: Form(
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
                  delegate: SliverChildListDelegate(
                    [
                      FormTextField(
                        controller: _currentPasswordController,
                        title: "modals.currentPassword".tr(),
                        hint: "modals.currentPassword".tr(),
                        onChanged: store.setPassword,
                        validator: Validators.signUpPasswordValidator,
                      ),
                      spacer,
                      FormTextField(
                        controller: _newPasswordController,
                        title: "modals.newPassword".tr(),
                        hint: "modals.newPassword".tr(),
                        onChanged: store.setNewPassword,
                        validator: Validators.signUpPasswordValidator,
                      ),
                      spacer,
                      FormTextField(
                        controller: _confirmNewPasswordController,
                        title: "modals.confirmNewPassword".tr(),
                        hint: "modals.confirmNewPassword".tr(),
                        onChanged: store.setConfirmNewPassword,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 8) {
                            return "modals.lengthPassword".tr();
                          }
                          if (value != _newPasswordController.text) {
                            return "modals.mustMatchNewPassword".tr();
                          }
                          return null;
                        },
                      ),
                      spacer,
                      Observer(
                        builder: (_) => LoginButton(
                          enabled: store.isLoading,
                          onTap:
                              store.canSubmit ? _changePasswordOnPressed : null,
                          title: "meta.submit".tr(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _changePasswordOnPressed() async {
    if (_formKey.currentState?.validate() ?? false) {
      store.changePassword();
    }
  }
}
