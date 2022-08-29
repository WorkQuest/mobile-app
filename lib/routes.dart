import 'package:app/enums.dart';
import 'package:app/model/chat_model/chat_model.dart';
import 'package:app/model/profile_response/portfolio.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/chat_page/chat_page.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/chat_room_page/chat_room_page.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/create_group_page/create_group_page.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/create_private_chat/create_private_page.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/create_private_chat/store/create_private_store.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/edit_chat_page/edit_chat_page.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/edit_chat_page/store/edit_chat_store.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/edit_chat_page/widgets/add_members.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/starred_messages_page/starred_message_page.dart';
import 'package:app/ui/pages/main_page/main_page.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/chat_room_page/store/chat_room_store.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/create_group_page/store/group_chat_store.dart';
import 'package:app/ui/pages/main_page/tabs/chat/pages/starred_messages_page/store/starred_message_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_details/pages/choose_quest_page/choose_quest_page.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_details/pages/choose_quest_page/store/choose_quest_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_details/pages/create_portfolio_page/store/create_portfolio_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_details/pages/portfolio_details_page/portfolio_details_page.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_details/pages/portfolio_details_page/store/portfolio_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_details/pages/profile_quests_page/store/profile_quests_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_details/pages/review_page/review_page.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_details/pages/user_profile_page/store/user_profile_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_details/pages/user_profile_page/user_profile_page.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_details/pages/user_profile_page/widgets/user_profile_employer.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_details/pages/user_profile_worker_page/user_profile_worker.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/change_language_page/change_language_page.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/SMS_verification_page/sms_verification_page.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/SMS_verification_page/store/sms_verification_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/change_password_page/change_password_page.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/2FA_page/2FA_page.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/2FA_page/store/2FA_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/change_password_page/store/change_password_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/my_disputes/pages/dispute_page/dispute_page.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/my_disputes/pages/dispute_page/store/dispute_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/my_disputes/pages/my_list_disputes_page/my_disputes_page.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/my_disputes/pages/my_list_disputes_page/store/my_disputes_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_visibility_page/profile_visibility_page.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/profile_visibility_page/store/profile_visibility_store.dart';
import 'package:app/ui/pages/main_page/tabs/more/pages/settings_page/settings_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_quest_page/store/create_quest_store.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_review_page/create_review_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/create_review_page/store/create_review_store.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/open_dispute_page/open_dispute_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/open_dispute_page/store/open_dispute_store.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/quest_details/pages/employer/quest_employer_page/quest_employer_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/quest_details/pages/employer/quest_employer_page/store/employer_store.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/quest_details/pages/map_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/quest_details/pages/worker/quest_worker_page/store/worker_store.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/raise_views_page/raise_views_page.dart';
import 'package:app/ui/pages/main_page/tabs/my_quests/pages/raise_views_page/store/raise_views_store.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/filter_quests_page/filter_quests_page.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/filter_quests_page/store/filter_quests_store.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/notification_page/notification_page.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/notification_page/store/notification_store.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_list_page/store/search_list_store.dart';
import 'package:app/ui/pages/main_page/tabs/search/pages/search_map/store/search_map_store.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/deposit_page/deposit_page.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/deposit_page/store/deposit_store.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/network_page/network_page.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/swap_page/store/swap_store.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/transfer_page/mobx/transfer_store.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/wallet_page/store/wallet_store.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/wallet_page/wallet_page.dart';
import 'package:app/ui/pages/main_page/tabs/wallet/pages/withdraw_page/withdraw_page.dart';
import 'package:app/ui/pages/pin_code_page/pin_code_page.dart';
import 'package:app/ui/pages/pin_code_page/store/pin_code_store.dart';
import 'package:app/ui/pages/report_page/report_page.dart';
import 'package:app/ui/pages/report_page/store/report_store.dart';
import 'package:app/ui/pages/restore_password_page/send_code_page.dart';
import 'package:app/ui/pages/restore_password_page/store/restore_password_store.dart';
import 'package:app/ui/pages/sign_in_page/mnemonic_page.dart';
import 'package:app/ui/pages/sign_up/pages/choose_role/pages/choose_role_page/choose_role_page.dart';
import 'package:app/ui/pages/sign_up/pages/choose_role/pages/choose_role_page/store/choose_role_store.dart';
import 'package:app/ui/pages/sign_up/pages/choose_role/pages/enter_totp_page.dart';
import 'package:app/ui/pages/sign_up/pages/confirm_email_page/confirm_email_page.dart';
import 'package:app/ui/pages/sign_up/pages/confirm_email_page/store/confirm_email_store.dart';
import 'package:app/ui/pages/sign_up/pages/generate_wallet/pages/create_wallet_page/create_wallet_page.dart';
import 'package:app/ui/pages/sign_up/pages/generate_wallet/pages/create_wallet_page/store/create_wallet_store.dart';
import 'package:app/ui/pages/sign_up/pages/generate_wallet/pages/import_wallet_page.dart';
import 'package:app/ui/pages/sign_up/pages/generate_wallet/pages/wallets_page.dart';
import 'package:app/ui/pages/sign_up/pages/sign_up_page/store/sign_up_store.dart';
import 'package:app/ui/pages/start_page/start_page.dart';
import 'package:app/ui/pages/start_page/store/start_store.dart';
import 'package:app/ui/widgets/web_view_page/web_view_page.dart';
import 'package:app/ui/pages/profile_me_store/profile_me_store.dart';
import 'package:app/ui/pages/sign_in_page/sign_in_page.dart';
import 'package:app/ui/pages/sign_in_page/store/sign_in_store.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart' as lang;
import 'di/injector.dart';
import 'ui/pages/main_page/tabs/more/pages/change_profile_page/change_profile_page.dart';
import 'ui/pages/main_page/tabs/more/pages/profile_details/pages/create_portfolio_page/create_portfolio_page.dart';
import 'ui/pages/main_page/tabs/more/pages/profile_details/pages/profile_quests_page/profile_quests_page.dart';
import 'ui/pages/main_page/tabs/my_quests/pages/create_quest_page/create_quest_page.dart';
import 'ui/pages/main_page/tabs/my_quests/pages/quest_details/pages/worker/quest_worker_page/quest_worker_page.dart';
import 'ui/pages/main_page/tabs/wallet/pages/swap_page/swap_page.dart';
import 'ui/pages/sign_up/pages/choose_role/pages/approve_role_page.dart';
import 'ui/pages/sign_up/pages/sign_up_page/sign_up_page.dart';

class Routes {
  static TextDirection checkDirection(BuildContext context) {
    return context.locale.toString() == "ar_SA" ? TextDirection.rtl : TextDirection.ltr;
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SignInPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<SignInStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: SignInPage(),
            ),
          ),
        );

      case StartPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<StartStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: StartPage(),
            ),
          ),
        );

      case SignUpPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<SignUpStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: SignUpPage(),
            ),
          ),
        );

      case PinCodePage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<PinCodeStore>(),
              ),
              Provider(
                create: (context) => getIt.get<EmployerStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: PinCodePage(),
            ),
          ),
        );

      case SendEmailPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<RestorePasswordStore>(),
            child: SendEmailPage(),
          ),
        );

      case ChangePasswordPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Directionality(
            textDirection: checkDirection(context),
            child: Provider(
              create: (context) => getIt.get<ChangePasswordStore>(),
              child: ChangePasswordPage(),
            ),
          ),
        );

      case SMSVerificationPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<SMSVerificationStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: SMSVerificationPage(),
            ),
          ),
        );

      case MainPage.routeName:
        final role = getIt.get<ProfileMeStore>().userData?.role;
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<SearchListStore>(),
              ),
              Provider(
                create: (context) => getIt.get<MyQuestStore>(),
              ),
              Provider(
                create: (context) => getIt.get<SearchMapStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ChangePasswordStore>(),
              ),
              Provider(
                create: (context) => getIt.get<FilterQuestsStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ChooseRoleStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
              Provider(
                create: (context) => getIt.get<WalletStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ChatStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: MainPage(role ?? UserRole.Worker),
            ),
          ),
        );

      case QuestEmployerPage.routeName:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as QuestArguments;
            return MultiProvider(
              providers: [
                Provider(
                  create: (context) => getIt.get<EmployerStore>(),
                ),
                Provider(
                  create: (context) => getIt.get<ProfileMeStore>(),
                ),
                Provider(
                  create: (context) => getIt.get<MyQuestStore>(),
                ),
                Provider(
                  create: (context) => getIt.get<ChatStore>(),
                ),
                Provider(
                  create: (context) => getIt.get<SearchListStore>(),
                ),
              ],
              child: Directionality(
                textDirection: checkDirection(context),
                child: QuestEmployerPage(arguments),
              ),
            );
          },
        );

      case QuestWorkerPage.routeName:
        return MaterialPageRoute(
          builder: (context) {
            final arguments = settings.arguments as QuestArguments;
            return MultiProvider(
              providers: [
                Provider(
                  create: (context) => getIt.get<WorkerStore>(),
                ),
                Provider(
                  create: (context) => getIt.get<ProfileMeStore>(),
                ),
                Provider(
                  create: (context) => getIt.get<MyQuestStore>(),
                ),
                Provider(
                  create: (context) => getIt.get<SearchListStore>(),
                ),
                Provider(
                  create: (context) => getIt.get<ChatStore>(),
                ),
              ],
              child: Directionality(
                textDirection: checkDirection(context),
                child: QuestWorkerPage(arguments),
              ),
            );
          },
        );

      case FilterQuestsPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<FilterQuestsStore>(),
              ),
              Provider(
                create: (context) => getIt.get<SearchListStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: FilterQuestsPage(),
            ),
          ),
        );

      case ChooseRolePage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ChooseRoleStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: ChooseRolePage(),
            ),
          ),
        );

      case ProfileQuestsPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<ProfileQuestsStore>(),
              ),
              Provider(
                create: (context) => getIt.get<MyQuestStore>(),
              ),
              Provider(
                create: (context) => getIt.get<SearchListStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: ProfileQuestsPage(
                settings.arguments as ProfileQuestsArguments,
              ),
            ),
          ),
        );

      case ApproveRolePage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ChooseRoleStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: ApproveRolePage(settings.arguments as ChooseRoleStore),
            ),
          ),
        );

      case NotificationPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<NotificationStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ChatStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: NotificationPage(),
            ),
          ),
        );

      case ChooseQuestPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<ChooseQuestStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ChatStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: ChooseQuestPage(
                workerId: settings.arguments as String,
              ),
            ),
          ),
        );

      case MyDisputesPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<MyDisputesStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: MyDisputesPage(),
            ),
          ),
        );

      case WalletsPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Directionality(
            textDirection: checkDirection(context),
            child: WalletsPage(),
          ),
        );

      case MapPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Directionality(
            textDirection: checkDirection(context),
            child: MapPage(settings.arguments as BaseQuestResponse),
          ),
        );

      case ImportWalletPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<CreateWalletStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: ImportWalletPage(),
            ),
          ),
        );

      case CreateWalletPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<CreateWalletStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: CreateWalletPage(),
            ),
          ),
        );

      case UserProfile.routeName:
        final arguments = settings.arguments as ProfileArguments?;
        final _isWorker = (arguments?.role ?? GetIt.I.get<ProfileMeStore>().userData!.role) == UserRole.Worker;
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
              Provider(
                create: (context) => getIt.get<UserProfileStore>(),
              ),
              Provider(
                create: (context) => getIt.get<MyQuestStore>(),
              ),
              Provider(
                create: (context) => getIt.get<SearchListStore>(),
              ),
              Provider(
                create: (context) => getIt.get<PortfolioStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: _isWorker ? WorkerProfile(arguments) : EmployerProfile(arguments),
            ),
          ),
        );

      case ConfirmEmail.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ConfirmEmailStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: ConfirmEmail(settings.arguments as ConfirmEmailArguments),
            ),
          ),
        );

      case SettingsPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<ChangePasswordStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
              Provider(
                create: (context) => getIt.get<MyQuestStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: SettingsPage(),
            ),
          ),
        );

      case ChangeProfilePage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
              Provider(
                create: (context) => getIt.get<SMSVerificationStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: ChangeProfilePage(),
            ),
          ),
        );

      case EnterTotpPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ChooseRoleStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: EnterTotpPage(),
            ),
          ),
        );

      case CreateQuestPage.routeName:
        return MaterialPageRoute<bool>(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<CreateQuestStore>(),
              ),
              Provider(
                create: (context) => getIt.get<MyQuestStore>(),
              ),
              Provider(
                create: (context) => getIt.get<SearchListStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
              Provider(
                create: (context) => getIt.get<TransferStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: CreateQuestPage(
                questInfo: settings.arguments as BaseQuestResponse?,
              ),
            ),
          ),
        );

      case WalletPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<WalletStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: WalletPage(),
            ),
          ),
        );

      case SwapPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<SwapStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: SwapPage(),
            ),
          ),
        );

      case NetworkPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Directionality(
            textDirection: checkDirection(context),
            child: NetworkPage(),
          ),
        );

      case DepositPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<DepositStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: DepositPage(),
            ),
          ),
        );

      case WithdrawPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<TransferStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: WithdrawPage(),
            ),
          ),
        );

      case RaiseViews.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<RaiseViewStore>(),
              ),
              Provider(
                create: (context) => getIt.get<MyQuestStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: RaiseViews(settings.arguments as String),
            ),
          ),
        );

      // case PaymentPage.routeName:
      //   return MaterialPageRoute(
      //     builder: (context) => Provider(
      //       create: (context) => getIt.get<RaiseViewStore>(),
      //       child: Directionality(
      //         textDirection: checkDirection(context),
      //         child: PaymentPage(settings.arguments as RaiseViewStore),
      //       ),
      //     ),
      //   );

      case MnemonicPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<SignInStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: MnemonicPage(),
            ),
          ),
        );

      case WebViewPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<SignInStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: WebViewPage(
                settings.arguments.toString(),
              ),
            ),
          ),
        );

      case TwoFAPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
              Provider(create: (context) => getIt.get<TwoFAStore>()),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: TwoFAPage(),
            ),
          ),
        );

      case ChatPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<ChatStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: ChatPage(),
            ),
          ),
        );

      case ChatRoomPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<ChatRoomStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ChatStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: ChatRoomPage(
                settings.arguments as ChatRoomArguments,
              ),
            ),
          ),
        );

      case StarredMessagePage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<StarredMessageStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: StarredMessagePage(settings.arguments as String),
            ),
          ),
        );

      case CreateGroupPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<GroupChatStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: CreateGroupPage(settings.arguments as bool),
            ),
          ),
        );

      case CreatePrivatePage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<CreatePrivateStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ChatStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: CreatePrivatePage(settings.arguments as String),
            ),
          ),
        );

      case AddMembers.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<EditChatStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: AddMembers(settings.arguments as String),
            ),
          ),
        );

      case EditChatPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<ChatStore>(),
              ),
              Provider(
                create: (context) => getIt.get<EditChatStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: EditChatPage(settings.arguments as ChatModel),
            ),
          ),
        );

      case OpenDisputePage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<OpenDisputeStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: OpenDisputePage(settings.arguments as BaseQuestResponse),
            ),
          ),
        );

      case DisputePage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<MyQuestStore>(),
              ),
              Provider(
                create: (context) => getIt.get<DisputeStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
              Provider(
                create: (context) => getIt.get<SearchListStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ChatRoomStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: DisputePage(settings.arguments as String),
            ),
          ),
        );

      case CreateReviewPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<CreateReviewStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: CreateReviewPage(
                settings.arguments as CreateReviewArguments,
              ),
            ),
          ),
        );

      case ReviewPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: ReviewPage(settings.arguments as ReviewPageArguments),
            ),
          ),
        );

      case ChangeLanguagePage.routeName:
        return MaterialPageRoute(
          builder: (context) => Directionality(
            textDirection: checkDirection(context),
            child: ChangeLanguagePage(),
          ),
        );

      case CreatePortfolioPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<CreatePortfolioStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: CreatePortfolioPage(
                portfolio: settings.arguments as PortfolioModel?,
              ),
            ),
          ),
        );

      case PortfolioDetails.routeName:
        return MaterialPageRoute(
          builder: (context) => Directionality(
            textDirection: checkDirection(context),
            child: PortfolioDetails(
              arguments: settings.arguments as PortfolioDetailsArguments,
            ),
          ),
        );

      case ReportPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ReportStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: ReportPage(
                arguments: settings.arguments as ReportPageArguments,
              ),
            ),
          ),
        );

      case ProfileVisibilityPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ProfileVisibilityStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: ProfileVisibilityPage(settings.arguments as ProfileMeResponse),
            ),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => Directionality(
            textDirection: checkDirection(context),
            child: Container(),
          ),
        );
    }
  }

  // static push(BuildContext ct, dynamic store, Widget widgets) {
  //   Navigator.of(ct).push(
  //     MaterialPageRoute(
  //       builder: (ct) => Directionality(
  //         textDirection: checkDirection(ct),
  //         child: Provider(
  //           create: (_) => store,
  //           child: widgets,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  generateRouteEmployer(settings) {}

  generateRouteWorker(settings) {}
}
