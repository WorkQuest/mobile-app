import 'dart:async';

import 'package:app/constants.dart';
import 'package:app/main.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/pages/sign_up_page/confirm_email_page/confirm_email_page.dart';
import 'package:app/utils/alert_dialog.dart';
import 'package:app/utils/storage.dart';
import 'package:app/web3/repository/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:uni_links/uni_links.dart';

class DeepLinkUtil {
  bool _initialURILinkHandled = false;
  StreamSubscription? _streamSubscription;
  ProfileMeStore store = GetIt.I.get<ProfileMeStore>();

  String get _network => AccountRepository().notifierNetwork.value.name;

  void initDeepLink() {
    initURIHandler();
    incomingLinkHandler();
  }

  Future<void> initURIHandler() async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        final token = await Storage.readAccessToken();
        if (token == null) return;
        var initialURI = await getInitialUri();
        if (initialURI != null) {
          if (_checkHost(initialURI.host)) _goToPage(initialURI);
        }
      } on PlatformException {
        print("Failed to receive initial uri");
      } on FormatException {
        print('Malformed Initial URI received');
      }
    }
  }

  void incomingLinkHandler() async {
    _streamSubscription = uriLinkStream.listen((Uri? uri) async {
      if (uri == null) return;
      final token = await Storage.readAccessToken();
      if (token == null) return;
      if (_checkHost(uri.host)) _goToPage(uri);
    }, onError: (Object err) {
      print('Error occurred: $err');
    });
  }

  bool _checkHost(String host) {
    if (_network == Network.testnet.name) {
      if (!host.contains("testnet")) {
        _showDialog(network: Network.mainnet.name);
        return false;
      }
    } else if (_network == Network.mainnet.name) {
      if (host != "app.workquest.co") {
        _showDialog(network: Network.testnet.name);
        return false;
      }
    }
    return true;
  }

  void _showDialog({required String network}) =>
      AlertDialogUtils.showInfoAlertDialog(
        navigatorKey.currentState!.context,
        title: "Warning!",
        content: "In order to follow the link, you need to change the network"
            " to $network",
      );

  Future<void> _goToPage(Uri uri) async {
    final argument = uri.path.split("/").last;
    if (uri.path.contains("quests"))
      Navigator.of(navigatorKey.currentState!.context, rootNavigator: true)
          .pushNamed(
        QuestDetails.routeName,
        arguments: QuestArguments(
          id: argument,
          questInfo: null
        ),
      );
    else if (uri.path.contains("profile")) {
      await store.getQuestHolder(argument);
      await Navigator.of(navigatorKey.currentState!.context,
              rootNavigator: true)
          .pushNamed(
        UserProfile.routeName,
        arguments: ProfileArguments(
          role: store.questHolder!.role,
          userId: store.questHolder!.id,
        ),
      );
    } else if (uri.path.contains("sign-in")) {
      final isToken = await Storage.toLoginCheck();
      if (isToken) return;
      final code = uri.query.split("=").last;
      Navigator.of(navigatorKey.currentState!.context, rootNavigator: true)
          .pushNamed(
        ConfirmEmail.routeName,
        arguments: ConfirmEmailArguments(code: code),
      );
    }
  }

  clearData() {
    _streamSubscription?.cancel();
  }
}
