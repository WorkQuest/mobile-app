// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../http/api_provider.dart' as _i8;
import '../http/core/http_client.dart' as _i5;
import '../http/core/i_http_client.dart' as _i4;
import '../log_service.dart' as _i6;
import '../ui/pages/main_page/chat_page/chat_room_page/create_private_chat/store/create_private_store.dart'
    as _i13;
import '../ui/pages/main_page/chat_page/chat_room_page/group_chat/edit_chat/store/edit_chat_store.dart'
    as _i19;
import '../ui/pages/main_page/chat_page/chat_room_page/group_chat/store/group_chat_store.dart'
    as _i21;
import '../ui/pages/main_page/chat_page/chat_room_page/starred_message/store/starred_message_store.dart'
    as _i35;
import '../ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart'
    as _i7;
import '../ui/pages/main_page/chat_page/store/chat_store.dart' as _i41;
import '../ui/pages/main_page/my_quests_page/store/my_quest_store.dart' as _i43;
import '../ui/pages/main_page/notification_page/store/notification_store.dart'
    as _i23;
import '../ui/pages/main_page/profile_details_page/portfolio_page/create_portfolio/store/create_portfolio_store.dart'
    as _i12;
import '../ui/pages/main_page/profile_details_page/portfolio_page/details_portfolio/store/portfolio_store.dart'
    as _i25;
import '../ui/pages/main_page/profile_details_page/user_profile_page/pages/choose_quest/store/choose_quest_store.dart'
    as _i9;
import '../ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/store/create_review_store.dart'
    as _i15;
import '../ui/pages/main_page/profile_details_page/user_profile_page/pages/profile_quests_page/store/profile_quests_store.dart'
    as _i26;
import '../ui/pages/main_page/profile_details_page/user_profile_page/pages/store/user_profile_store.dart'
    as _i37;
import '../ui/pages/main_page/quest_details_page/details/store/quest_details_store.dart'
    as _i28;
import '../ui/pages/main_page/quest_details_page/dispute_page/store/open_dispute_store.dart'
    as _i24;
import '../ui/pages/main_page/quest_details_page/employer/store/employer_store.dart'
    as _i20;
import '../ui/pages/main_page/quest_details_page/worker/store/worker_store.dart'
    as _i39;
import '../ui/pages/main_page/quest_page/create_quest_page/store/create_quest_store.dart'
    as _i14;
import '../ui/pages/main_page/quest_page/filter_quests_page/store/filter_quests_store.dart'
    as _i42;
import '../ui/pages/main_page/quest_page/quest_list/store/quests_store.dart'
    as _i47;
import '../ui/pages/main_page/quest_page/quest_map/store/quest_map_store.dart'
    as _i46;
import '../ui/pages/main_page/raise_views_page/store/raise_views_store.dart'
    as _i29;
import '../ui/pages/main_page/settings_page/pages/2FA_page/2FA_store.dart'
    as _i50;
import '../ui/pages/main_page/settings_page/pages/my_disputes/dispute/store/dispute_store.dart'
    as _i18;
import '../ui/pages/main_page/settings_page/pages/my_disputes/store/my_disputes_store.dart'
    as _i22;
import '../ui/pages/main_page/settings_page/pages/profile_visibility_page/store/profile_visibility_store.dart'
    as _i27;
import '../ui/pages/main_page/settings_page/pages/SMS_verification_page/store/sms_verification_store.dart'
    as _i48;
import '../ui/pages/main_page/settings_page/store/settings_store.dart' as _i32;
import '../ui/pages/main_page/wallet_page/deposit_page/store/deposit_store.dart'
    as _i17;
import '../ui/pages/main_page/wallet_page/store/wallet_store.dart' as _i51;
import '../ui/pages/main_page/wallet_page/swap_page/store/swap_store.dart'
    as _i36;
import '../ui/pages/main_page/wallet_page/transactions/store/transactions_store.dart'
    as _i49;
import '../ui/pages/main_page/wallet_page/transfer_page/confirm_page/mobx/confirm_transfer_store.dart'
    as _i3;
import '../ui/pages/main_page/wallet_page/transfer_page/mobx/transfer_store.dart'
    as _i40;
import '../ui/pages/main_page/wallet_page/withdraw_page/store/withdraw_page_store.dart'
    as _i38;
import '../ui/pages/pin_code_page/store/pin_code_store.dart' as _i44;
import '../ui/pages/profile_me_store/profile_me_store.dart' as _i45;
import '../ui/pages/report_page/store/report_store.dart' as _i30;
import '../ui/pages/restore_password_page/store.dart' as _i31;
import '../ui/pages/sign_in_page/store/sign_in_store.dart' as _i33;
import '../ui/pages/sign_up/pages/choose_role/pages/choose_role_page/store/choose_role_store.dart'
    as _i10;
import '../ui/pages/sign_up/pages/confirm_email_page/store/confirm_email_store.dart'
    as _i11;
import '../ui/pages/sign_up/pages/generate_wallet/pages/create_wallet_page/store/create_wallet_store.dart'
    as _i16;
import '../ui/pages/sign_up/pages/sign_up_page/store/sign_up_store.dart'
    as _i34;

const String _test = 'test';
const String _prod = 'prod';
const String _dev = 'dev';

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// an extension to register the provided dependencies inside of [GetIt]
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of provided dependencies inside of [GetIt]
  _i1.GetIt init(
      {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
    final gh = _i2.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i3.ConfirmTransferStore>(() => _i3.ConfirmTransferStore());
    gh.factory<_i4.IHttpClient>(() => _i5.TestHttpClient(),
        registerFor: {_test});
    gh.factory<_i6.LogService>(() => _i6.LogServiceProd(),
        registerFor: {_prod});
    gh.factory<_i6.LogService>(() => _i6.LogServiceDev(),
        registerFor: {_dev, _test});
    gh.factory<_i7.ChatRoomStore>(
        () => _i7.ChatRoomStore(get<_i8.ApiProvider>()));
    gh.factory<_i9.ChooseQuestStore>(
        () => _i9.ChooseQuestStore(get<_i8.ApiProvider>()));
    gh.factory<_i10.ChooseRoleStore>(
        () => _i10.ChooseRoleStore(get<_i8.ApiProvider>()));
    gh.factory<_i11.ConfirmEmailStore>(
        () => _i11.ConfirmEmailStore(get<_i8.ApiProvider>()));
    gh.factory<_i12.CreatePortfolioStore>(
        () => _i12.CreatePortfolioStore(get<_i8.ApiProvider>()));
    gh.factory<_i13.CreatePrivateStore>(
        () => _i13.CreatePrivateStore(get<_i8.ApiProvider>()));
    gh.factory<_i14.CreateQuestStore>(
        () => _i14.CreateQuestStore(get<_i8.ApiProvider>()));
    gh.factory<_i15.CreateReviewStore>(
        () => _i15.CreateReviewStore(get<_i8.ApiProvider>()));
    gh.factory<_i16.CreateWalletStore>(
        () => _i16.CreateWalletStore(get<_i8.ApiProvider>()));
    gh.factory<_i17.DepositStore>(
        () => _i17.DepositStore(get<_i8.ApiProvider>()));
    gh.factory<_i18.DisputeStore>(
        () => _i18.DisputeStore(get<_i8.ApiProvider>()));
    gh.factory<_i19.EditChatStore>(
        () => _i19.EditChatStore(get<_i8.ApiProvider>()));
    gh.factory<_i20.EmployerStore>(
        () => _i20.EmployerStore(get<_i8.ApiProvider>()));
    gh.factory<_i21.GroupChatStore>(
        () => _i21.GroupChatStore(get<_i8.ApiProvider>()));
    gh.factory<_i22.MyDisputesStore>(
        () => _i22.MyDisputesStore(get<_i8.ApiProvider>()));
    gh.factory<_i23.NotificationStore>(
        () => _i23.NotificationStore(get<_i8.ApiProvider>()));
    gh.factory<_i24.OpenDisputeStore>(
        () => _i24.OpenDisputeStore(get<_i8.ApiProvider>()));
    gh.factory<_i25.PortfolioStore>(
        () => _i25.PortfolioStore(get<_i8.ApiProvider>()));
    gh.factory<_i26.ProfileQuestsStore>(
        () => _i26.ProfileQuestsStore(get<_i8.ApiProvider>()));
    gh.factory<_i27.ProfileVisibilityStore>(
        () => _i27.ProfileVisibilityStore(get<_i8.ApiProvider>()));
    gh.factory<_i28.QuestDetailsStore>(
        () => _i28.QuestDetailsStore(get<_i8.ApiProvider>()));
    gh.factory<_i29.RaiseViewStore>(
        () => _i29.RaiseViewStore(get<_i8.ApiProvider>()));
    gh.factory<_i30.ReportStore>(
        () => _i30.ReportStore(get<_i8.ApiProvider>()));
    gh.factory<_i31.RestorePasswordStore>(
        () => _i31.RestorePasswordStore(get<_i8.ApiProvider>()));
    gh.factory<_i32.SettingsPageStore>(
        () => _i32.SettingsPageStore(get<_i8.ApiProvider>()));
    gh.factory<_i33.SignInStore>(
        () => _i33.SignInStore(get<_i8.ApiProvider>()));
    gh.factory<_i34.SignUpStore>(
        () => _i34.SignUpStore(get<_i8.ApiProvider>()));
    gh.factory<_i35.StarredMessageStore>(
        () => _i35.StarredMessageStore(get<_i8.ApiProvider>()));
    gh.factory<_i36.SwapStore>(() => _i36.SwapStore(get<_i8.ApiProvider>()));
    gh.factory<_i37.UserProfileStore>(
        () => _i37.UserProfileStore(get<_i8.ApiProvider>()));
    gh.factory<_i38.WithdrawPageStore>(
        () => _i38.WithdrawPageStore(get<_i8.ApiProvider>()));
    gh.factory<_i39.WorkerStore>(
        () => _i39.WorkerStore(get<_i8.ApiProvider>()));
    gh.singleton<_i40.TransferStore>(_i40.TransferStore());
    gh.singleton<_i8.ApiProvider>(_i8.ApiProvider(get<_i4.IHttpClient>()));
    gh.singleton<_i41.ChatStore>(_i41.ChatStore(get<_i8.ApiProvider>()));
    gh.singleton<_i42.FilterQuestsStore>(
        _i42.FilterQuestsStore(get<_i8.ApiProvider>()));
    gh.singleton<_i43.MyQuestStore>(_i43.MyQuestStore(get<_i8.ApiProvider>()));
    gh.singleton<_i44.PinCodeStore>(_i44.PinCodeStore(get<_i8.ApiProvider>()));
    gh.singleton<_i45.ProfileMeStore>(
        _i45.ProfileMeStore(get<_i8.ApiProvider>()));
    gh.singleton<_i46.QuestMapStore>(
        _i46.QuestMapStore(get<_i8.ApiProvider>()));
    gh.singleton<_i47.QuestsStore>(_i47.QuestsStore(get<_i8.ApiProvider>()));
    gh.singleton<_i48.SMSVerificationStore>(
        _i48.SMSVerificationStore(get<_i8.ApiProvider>()));
    gh.singleton<_i49.TransactionsStore>(
        _i49.TransactionsStore(get<_i8.ApiProvider>()));
    gh.singleton<_i50.TwoFAStore>(_i50.TwoFAStore(get<_i8.ApiProvider>()));
    gh.singleton<_i51.WalletStore>(_i51.WalletStore(get<_i8.ApiProvider>()));
    return this;
  }
}
