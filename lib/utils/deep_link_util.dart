import 'dart:async';

import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/pages/sign_up_page/confirm_email_page/confirm_email_page.dart';
import 'package:app/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:uni_links/uni_links.dart';

@singleton
class DeepLinkUtil {
  bool _initialURILinkHandled = false;
  StreamSubscription? _streamSubscription;

  void initDeepLink({
    required BuildContext context,
  }) {
    ProfileMeStore store = GetIt.I.get<ProfileMeStore>();
    initURIHandler(context: context, store: store);
    incomingLinkHandler(context: context, store: store);
  }

  Future<void> initURIHandler({
    required BuildContext context,
    required ProfileMeStore store,
  }) async {
    if (!_initialURILinkHandled) {
      _initialURILinkHandled = true;
      try {
        final token = await Storage.readAccessToken();
        if (token == null) return;
        var initialURI = await getInitialUri();
        if (initialURI != null) {
          final argument = initialURI.path.split("/").last;
          if (initialURI.path.contains("quests"))
            Navigator.of(context, rootNavigator: true).pushNamed(
              QuestDetails.routeName,
              arguments: QuestArguments(
                questInfo: null,
                id: argument,
              ),
            );
          else if (initialURI.path.contains("profile")) {
            await store.getQuestHolder(argument);
            await Navigator.of(context, rootNavigator: true).pushNamed(
              UserProfile.routeName,
              arguments: ProfileArguments(
                role: store.questHolder!.role,
                userId: store.questHolder!.id,
              ),
            );
          } else if (initialURI.path.contains("sign-in")) {
            final code = initialURI.path.split("=").last;
            Navigator.of(context, rootNavigator: true).pushNamed(
              ConfirmEmail.routeName,
              arguments: ConfirmEmailArguments(code: code),
            );
          }
        }
      } on PlatformException {
        print("Failed to receive initial uri");
      } on FormatException {
        print('Malformed Initial URI received');
      }
    }
  }

  void incomingLinkHandler({
    required BuildContext context,
    required ProfileMeStore store,
  }) async {
    _streamSubscription = uriLinkStream.listen((Uri? uri) async {
      final token = await Storage.readAccessToken();
      if (token == null) return;
      final argument = uri?.path.split("/").last;
      if ((uri?.path ?? "").contains("quests"))
        Navigator.of(context, rootNavigator: true).pushNamed(
          QuestDetails.routeName,
          arguments: QuestArguments(
            questInfo: null,
            id: argument,
          ),
        );
      else if ((uri?.path ?? "").contains("profile")) {
        await store.getQuestHolder(argument!);
        await Navigator.of(context, rootNavigator: true).pushNamed(
          UserProfile.routeName,
          arguments: ProfileArguments(
            role: store.questHolder!.role,
            userId: argument,
          ),
        );
      } else if ((uri?.path ?? "").contains("sign-in")) {
        final code = uri?.query.split("=").last;
        Navigator.of(context, rootNavigator: true).pushNamed(
          ConfirmEmail.routeName,
          arguments: ConfirmEmailArguments(code: code),
        );
      }
    }, onError: (Object err) {
      print('Error occurred: $err');
    });
  }
}
