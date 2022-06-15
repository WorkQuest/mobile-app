import 'package:app/enums.dart';
import 'package:app/model/profile_response/profile_me_response.dart';
import 'package:app/model/quests_models/base_quest_response.dart';
import 'package:app/ui/pages/main_page/change_profile_page/change_profile_page.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_page.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/chat_room_page.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/group_chat/add_members/add_members.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/group_chat/create_group_page.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/group_chat/edit_group_chat.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/starred_message/starred_message.dart';
import 'package:app/ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart';
import 'package:app/ui/pages/main_page/chat_page/store/chat_store.dart';
import 'package:app/ui/pages/main_page/main_page.dart';
import 'package:app/ui/pages/main_page/my_quests_page/store/my_quest_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/create_portfolio_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/portfolio_details_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/portfolio_page/store/portfolio_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/choose_quest/choose_quest_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/choose_quest/store/choose_quest_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/create_review_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/store/create_review_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/profile_quests_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/review_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/store/user_profile_store.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_page.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_employer.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/pages/user_profile_worker.dart';
import 'package:app/ui/pages/main_page/profile_details_page/user_profile_page/widgets/profile_widgets.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/store/quest_details_store.dart';
import 'package:app/ui/pages/main_page/quest_details_page/dispute_page/open_dispute_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/dispute_page/store/open_dispute_store.dart';
import 'package:app/ui/pages/main_page/quest_details_page/employer/store/employer_store.dart';
import 'package:app/ui/pages/main_page/quest_details_page/details/quest_details_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/employer/quest_employer_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/worker/quest_worker_page.dart';
import 'package:app/ui/pages/main_page/quest_details_page/worker/store/worker_store.dart';
import 'package:app/ui/pages/main_page/quest_page/create_quest_page/create_quest_page.dart';
import 'package:app/ui/pages/main_page/quest_page/create_quest_page/store/create_quest_store.dart';
import 'package:app/ui/pages/main_page/quest_page/filter_quests_page/filter_quests_page.dart';
import 'package:app/ui/pages/main_page/quest_page/filter_quests_page/store/filter_quests_store.dart';
import 'package:app/ui/pages/main_page/quest_page/notification_page/notification_page.dart';
import 'package:app/ui/pages/main_page/quest_page/notification_page/store/notification_store.dart';
import 'package:app/ui/pages/main_page/raise_views_page/payment_page.dart';
import 'package:app/ui/pages/main_page/raise_views_page/raise_views_page.dart';
import 'package:app/ui/pages/main_page/raise_views_page/store/raise_views_store.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_list/store/quests_store.dart';
import 'package:app/ui/pages/main_page/quest_page/quest_map/store/quest_map_store.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/2FA_page/2FA_page.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/2FA_page/2FA_store.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/SMS_verification_page/sms_verification_page.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/SMS_verification_page/store/sms_verification_store.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/change_language_page.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/change_password_page.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/my_disputes/dispute/dispute_page.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/my_disputes/dispute/store/dispute_store.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/my_disputes/my_disputes_page.dart';
import 'package:app/ui/pages/main_page/settings_page/pages/my_disputes/store/my_disputes_store.dart';
import 'package:app/ui/pages/main_page/settings_page/settings_page.dart';
import 'package:app/ui/pages/main_page/settings_page/store/settings_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/deposit_page/deposit_page.dart';
import 'package:app/ui/pages/main_page/wallet_page/deposit_page/store/deposit_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/network_page.dart';
import 'package:app/ui/pages/main_page/wallet_page/store/wallet_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/swap_page/store/swap_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/swap_page/swap_page.dart';
import 'package:app/ui/pages/main_page/wallet_page/transfer_page/mobx/transfer_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/withdraw_page/store/withdraw_page_store.dart';
import 'package:app/ui/pages/pin_code_page/pin_code_page.dart';
import 'package:app/ui/pages/pin_code_page/store/pin_code_store.dart';
import 'package:app/ui/pages/main_page/wallet_page/withdraw_page/withdraw_page.dart';
import 'package:app/ui/pages/restore_password_page/send_code.dart';
import 'package:app/ui/pages/restore_password_page/store.dart';
import 'package:app/ui/pages/sign_in_page/mnemonic_page.dart';
import 'package:app/ui/pages/sign_up_page/choose_role_page/enter_totp_page.dart';
import 'package:app/ui/pages/start_page/start_page.dart';
import 'package:app/ui/pages/start_page/store/start_store.dart';
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
    return context.locale.toString() == "ar_SA"
        ? TextDirection.rtl
        : TextDirection.ltr;
  }

  // static RouteSettings parseDeepLinks(RouteSettings settings) {
  //   print("SettingsBefore: ${settings.name}");
  //   if (settings.arguments.runtimeType == ProfileArguments)
  //     print(
  //         "SettingsBefore: ${(settings.arguments as ProfileArguments).userId}");
  //   String name;
  //   if (settings.name!.contains("quests"))
  //     name = QuestDetails.routeName;
  //   else if (settings.name!.contains("profile"))
  //     name = UserProfile.routeName;
  //   else
  //     name = settings.name ?? "";
  //   var arguments;
  //   if (settings.name!.contains("quests"))
  //     arguments =
  //         QuestArguments(questInfo: null, id: settings.name!.split("/").last);
  //   else if (settings.name!.contains("profile"))
  //     arguments = ProfileArguments(
  //         role: UserRole.Employer, userId: settings.name!.split("/").last);
  //   else
  //     arguments = settings.arguments;
  //   settings = RouteSettings(name: name, arguments: arguments);
  //   print("SettingsAfter: ${settings.name}");
  //   print("SettingsAfter: ${settings.arguments}");
  //   return settings;
  // }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    print("SettingsAfter: ${settings.name}");
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
          builder: (context) => Provider(
            create: (context) => getIt.get<StartStore>(),
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
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: PinCodePage(),
            ),
          ),
        );

      case SendEmail.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<RestorePasswordStore>(),
            child: SendEmail(),
          ),
        );

      case ChangePasswordPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Directionality(
            textDirection: checkDirection(context),
            child: Provider(
              create: (context) => getIt.get<SettingsPageStore>(),
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

      case QuestDetails.routeName:
        return MaterialPageRoute(
          builder: (context) {
            final role = getIt.get<ProfileMeStore>().userData?.role;
            final arguments = settings.arguments as QuestArguments;
            if (role == UserRole.Employer)
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
                    create: (context) => getIt.get<QuestDetailsStore>(),
                  ),
                  Provider(
                    create: (context) => getIt.get<ChatStore>(),
                  ),
                ],
                child: Directionality(
                  textDirection: checkDirection(context),
                  child: QuestEmployer(arguments),
                ),
              );
            else {
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
                    create: (context) => getIt.get<QuestsStore>(),
                  ),
                  Provider(
                    create: (context) => getIt.get<QuestDetailsStore>(),
                  ),
                  Provider(
                    create: (context) => getIt.get<ChatStore>(),
                  ),
                ],
                child: Directionality(
                  textDirection: checkDirection(context),
                  child: QuestWorker(arguments),
                ),
              );
            }
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
                create: (context) => getIt.get<QuestsStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child:
                  FilterQuestsPage(settings.arguments as Map<int, List<int>>),
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
          builder: (context) => Provider(
            create: (context) => getIt.get<ProfileMeStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: ProfileQuestsPage(settings.arguments as ProfileMeResponse),
            ),
          ),
        );

      case ApproveRolePage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ChooseRoleStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: ApproveRolePage(settings.arguments),
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
              child: NotificationPage(settings.arguments as String),
            ),
          ),
        );

      case ChooseQuestPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ChooseQuestStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: ChooseQuestPage(
                arguments: settings.arguments as ChooseQuestArguments,
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

      case UserProfile.routeName:
        final role = getIt.get<ProfileMeStore>().userData?.role;
        final arguments = settings.arguments as ProfileArguments?;
        final isViewProfile;
        if (settings.arguments == null)
          isViewProfile = role ?? UserRole.Worker;
        else
          isViewProfile = arguments!.role;
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
                create: (context) => getIt.get<PortfolioStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: (settings.arguments == null)
                  ? role == UserRole.Worker
                      ? WorkerProfile(arguments)
                      : EmployerProfile(arguments)
                  : isViewProfile == UserRole.Worker
                      ? WorkerProfile(arguments)
                      : EmployerProfile(arguments),
            ),
          ),
        );

      case ConfirmEmail.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ChooseRoleStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: ConfirmEmail(
                settings.arguments.toString(),
              ),
            ),
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
              textDirection: checkDirection(context),
              child: SettingsPage(),
            ),
          ),
        );

      case ChangeProfilePage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ProfileMeStore>(),
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
                create: (context) => getIt.get<QuestsStore>(),
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
          builder: (context) => Provider(
            create: (context) => {},
            child: Directionality(
              textDirection: checkDirection(context),
              child: NetworkPage(),
            ),
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
            create: (context) => getIt.get<WithdrawPageStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: WithdrawPage(),
            ),
          ),
        );

      case RaiseViews.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<RaiseViewStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: RaiseViews(settings.arguments as String),
            ),
          ),
        );

      case PaymentPage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<RaiseViewStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: PaymentPage(settings.arguments as RaiseViewStore),
            ),
          ),
        );

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
          builder: (context) => Provider(
            create: (context) => getIt.get<SignInStore>(),
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
                settings.arguments as String,
              ),
            ),
          ),
        );

      case StarredMessage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ChatRoomStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: StarredMessage(settings.arguments as String),
            ),
          ),
        );

      case CreateGroupPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<ChatRoomStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ChatStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: CreateGroupPage(
                settings.arguments as String,
              ),
            ),
          ),
        );

      case AddMembers.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ChatRoomStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: AddMembers(settings.arguments as ChatRoomStore),
            ),
          ),
        );

      case EditGroupChat.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<ChatRoomStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: EditGroupChat(
                settings.arguments as ChatRoomStore,
              ),
            ),
          ),
        );

      case OpenDisputePage.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<OpenDisputeStore>(),
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
                create: (context) => getIt.get<DisputeStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
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
                settings.arguments as ReviewArguments,
              ),
            ),
          ),
        );

      case ReviewPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              Provider(
                create: (context) => getIt.get<PortfolioStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
              Provider(
                create: (context) => getIt.get<UserProfileStore>(),
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
                create: (context) => getIt.get<PortfolioStore>(),
              ),
              Provider(
                create: (context) => getIt.get<ProfileMeStore>(),
              ),
            ],
            child: Directionality(
              textDirection: checkDirection(context),
              child: CreatePortfolioPage(
                allowEdit: settings.arguments as bool,
              ),
            ),
          ),
        );

      case PortfolioDetails.routeName:
        return MaterialPageRoute(
          builder: (context) => Provider(
            create: (context) => getIt.get<PortfolioStore>(),
            child: Directionality(
              textDirection: checkDirection(context),
              child: PortfolioDetails(
                arguments: settings.arguments as PortfolioArguments,
              ),
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

  // static push(BuildContext ct, dynamic store, Widget widget) {
  //   Navigator.of(ct).push(
  //     MaterialPageRoute(
  //       builder: (ct) => Directionality(
  //         textDirection: checkDirection(ct),
  //         child: Provider(
  //           create: (_) => store,
  //           child: widget,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  generateRouteEmployer(settings) {}

  generateRouteWorker(settings) {}
}
