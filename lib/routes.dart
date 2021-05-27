import 'package:app/ui/pages/main_page/create_quest_page/create_quest_page.dart';
import 'package:app/ui/pages/main_page/main_page.dart';
import 'package:app/ui/pages/main_page/my_quests_page/my_quest_details.dart';
import 'package:app/ui/pages/main_page/notification_page/notification_page.dart';
import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:app/ui/pages/sign_in_page/store/sign_in_store.dart';
import 'package:app/ui/pages/sign_up_page/choose_role_page/approve_role_page.dart';
import 'package:app/ui/pages/sign_up_page/choose_role_page/choose_role_page.dart';
import 'package:app/ui/pages/sign_up_page/choose_role_page/store/choose_role_store.dart';
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
            child: const SignInPage(),
          ),
        );

      case SignUpPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<SignUpStore>(),
            child: const SignUpPage(),
          ),
        );

      case MainPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MainPage(),
        );

      case MyQuestDetails.routeName:
        return MaterialPageRoute(
          builder: (context) => MyQuestDetails(),
        );

      case ChooseRolePage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(providers: [
            Provider(
              create: (context) => getIt.get<SignUpStore>(),
            ),
            Provider(
              create: (context) => getIt.get<ChooseRoleStore>(),
            )
          ],
            child: ChooseRolePage(),
          ),
        );

      case ApproveRolePage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(providers: [
            Provider(
              create: (context) => getIt.get<SignUpStore>(),
            ),
            Provider(
              create: (context) => getIt.get<ChooseRoleStore>(),
            ),
          ],
            child: ApproveRolePage(),
          ),
        );

      case NotificationPage.routeName:
        return MaterialPageRoute(
          builder: (context) => NotificationPage(),
        );

      case CreateQuestPage.routeName:
        return MaterialPageRoute(
          builder: (context) => CreateQuestPage(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => Container(),
        );
    }
  }
}
