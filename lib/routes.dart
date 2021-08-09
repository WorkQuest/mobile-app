import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/chat_room_page.dart';
import 'package:app/ui/pages/main_page/create_quest_page/create_quest_page.dart';
import 'package:app/ui/pages/main_page/create_quest_page/store/create_quest_store.dart';
import 'package:app/ui/pages/main_page/main_page.dart';
import 'package:app/ui/pages/main_page/my_quests_page/my_quest_details.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/notification_page/notification_page.dart';
import 'package:app/ui/pages/main_page/profile_reviews_page/profileMe_reviews_page.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/store/quests_store.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_map/store/quest_map_store.dart';
import 'package:app/ui/pages/main_page/settings_page/change_passsword_page.dart';
import 'package:app/ui/pages/main_page/settings_page/settings_page.dart';
import 'package:app/ui/pages/main_page/settings_page/store/settings_store.dart';
import 'package:app/ui/pages/pin_code_page/pin_code_page.dart';
import 'package:app/ui/pages/pin_code_page/store/pin_code_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/transfer_page.dart';
import 'package:app/ui/widgets/web_view_page/web_view_page.dart';
import 'package:app/ui/pages/main_page/wallet_page/wallet_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:app/ui/pages/sign_in_page/store/sign_in_store.dart';
import 'package:app/ui/pages/sign_up_page/choose_role_page/approve_role_page.dart';
import 'package:app/ui/pages/sign_up_page/choose_role_page/choose_role_page.dart';
import 'package:app/ui/pages/sign_up_page/choose_role_page/store/choose_role_store.dart';
import 'package:app/ui/pages/sign_up_page/confirm_email_page/confirm_email_page.dart';
import 'package:app/ui/pages/sign_up_page/sign_up_page.dart';
import 'package:app/ui/pages/sign_up_page/store/sign_up_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart' as lang;

import 'di/injector.dart';

class Routes {
  static TextDirection checkDirection(BuildContext context) {
    print(context.locale.toString());
    return context.locale.toString() == "ar_SA"
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SignInPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<SignInStore>(),
            child: Directionality(
                textDirection: checkDirection(context), child: SignInPage()),
          ),
        );

      case SignUpPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<SignUpStore>(),
            child: Directionality(
                textDirection: checkDirection(context), child: SignUpPage()),
          ),
        );

      case PinCodePage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<PinCodeStore>(),
            child: Directionality(
                textDirection: checkDirection(context), child: PinCodePage()),
          ),
        );

      case ChangePasswordPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<SettingsPageStore>(),
            child: ChangePasswordPage(),
          ),
        );

      case MainPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<QuestsStore>(),
              ),
              Provider(
                create: (context) => getIt.get<MyQuestStore>(),
              ),
              Provider(
                create: (context) => getIt.get<QuestMapStore>(),
              ),
              Provider(
                create: (context) => getIt.get<SettingsPageStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
            ],
            child: Directionality(
                textDirection: checkDirection(context), child: MainPage()),
          ),
        );

      case MyQuestDetails.routeName:
        return MaterialPageRoute(
          builder: (context) => Directionality(
              textDirection: checkDirection(context),
              child: MyQuestDetails(settings.arguments as BaseQuestResponse,
                  getIt.get<ProfileMeStore>().userData?.role)),
        );

      case ChooseRolePage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ChooseRoleStore>(),
            child: Directionality(
                textDirection: checkDirection(context),
                child: ChooseRolePage()),
          ),
        );

      case ApproveRolePage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ChooseRoleStore>(),
            child: Directionality(
                textDirection: checkDirection(context),
                child: ApproveRolePage(settings.arguments)),
          ),
        );

      case NotificationPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Directionality(
              textDirection: checkDirection(context),
              child: NotificationPage()),
        );

      case ProfileReviews.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
            ],
            child: Directionality(
                textDirection: checkDirection(context),
                child: ProfileReviews()),
          ),
        );

      case ConfirmEmail.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ChooseRoleStore>(),
            child: Directionality(
                textDirection: checkDirection(context),
                child: ConfirmEmail(settings.arguments)),
          ),
        );

      case SettingsPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<SettingsPageStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
            ],
            child: Directionality(
                textDirection: checkDirection(context), child: SettingsPage()),
          ),
        );

      case CreateQuestPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<CreateQuestStore>(),
            child: Directionality(
                textDirection: checkDirection(context),
                child: CreateQuestPage(
                    questInfo: settings.arguments as BaseQuestResponse?)),
          ),
        );

      case WalletPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Directionality(
              textDirection: checkDirection(context), child: WalletPage()),
        );

      case TransferPage.routeName:
        return MaterialPageRoute(
          builder: (context) => TransferPage(),
        );

      case WebViewPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Directionality(
              textDirection: checkDirection(context),
              child: WebViewPage(settings.arguments.toString())),
        );

      case ChatRoomPage.routeName:
        return MaterialPageRoute(
          builder: (context) => ChatRoomPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => Directionality(
              textDirection: checkDirection(context), child: Container()),
        );
    }
  }
}
