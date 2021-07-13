import 'package:app/ui/pages/main_page/create_quest_page/create_quest_page.dart';
import 'package:app/ui/pages/main_page/create_quest_page/store/create_quest_store.dart';
import 'package:app/ui/pages/main_page/main_page.dart';
import 'package:app/ui/pages/main_page/my_quests_page/my_quest_details.dart';
import 'package:app/ui/pages/main_page/notification_page/notification_page.dart';
import 'package:app/ui/pages/main_page/profile_reviews_page/profileMe_reviews_page.dart';
import 'package:app/ui/pages/main_page/quest_page/store/quests_store.dart';
import 'package:app/ui/pages/main_page/settings_page/settings_page_employer/settings_page.dart';
import 'package:app/ui/pages/main_page/settings_page/settings_page_employer/store/settings_store.dart';
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

import 'di/injector.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SignInPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<SignInStore>(),
            child: SignInPage(),
          ),
        );

      case SignUpPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<SignUpStore>(),
            child: SignUpPage(),
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
                create: (context) => getIt.get<SettingsPageStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
            ],
            child: MainPage(),
          ),
        );

      case MyQuestDetails.routeName:
        return MaterialPageRoute(
          builder: (context) => MyQuestDetails(),
        );

      case ChooseRolePage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ChooseRoleStore>(),
            child: ChooseRolePage(),
          ),
        );

      case ApproveRolePage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ChooseRoleStore>(),
            child: ApproveRolePage(settings.arguments),
          ),
        );

      case NotificationPage.routeName:
        return MaterialPageRoute(
          builder: (context) => NotificationPage(),
        );

      case ProfileReviews.routeName:
        return MaterialPageRoute(
          builder: (context) => ProfileReviews(),
        );

      case ConfirmEmail.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ChooseRoleStore>(),
            child: ConfirmEmail(settings.arguments),
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
            child: SettingsPage(),
          ),
        );

      case CreateQuestPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<CreateQuestStore>(),
            child: CreateQuestPage(),
          ),
        );

      case WalletPage.routeName:
        return MaterialPageRoute(
          builder: (context) => WalletPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => Container(),
        );
    }
  }
}
