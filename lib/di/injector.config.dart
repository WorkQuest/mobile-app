// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../http/api_provider.dart' as _i9;
import '../http/core/http_client.dart' as _i5;
import '../http/core/i_http_client.dart' as _i4;
import '../log_service.dart' as _i6;
import '../ui/pages/main_page/chat_page/chat_room_page/create_private_chat/store/create_private_store.dart'
    as _i12;
import '../ui/pages/main_page/chat_page/chat_room_page/group_chat/edit_chat/store/edit_chat_store.dart'
    as _i18;
import '../ui/pages/main_page/chat_page/chat_room_page/group_chat/store/group_chat_store.dart'
    as _i20;
import '../ui/pages/main_page/chat_page/chat_room_page/starred_message/store/starred_message_store.dart'
    as _i30;
import '../ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart'
    as _i8;
import '../ui/pages/main_page/chat_page/store/chat_store.dart' as _i35;
import '../ui/pages/main_page/my_quests_page/store/my_quest_store.dart' as _i37;
import '../ui/pages/main_page/profile_details_page/portfolio_page/store/portfolio_store.dart'
    as _i39;
import '../ui/pages/main_page/profile_details_page/user_profile_page/pages/choose_quest/store/choose_quest_store.dart'
    as _i10;
import '../ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/store/create_review_store.dart'
    as _i14;
import '../ui/pages/main_page/profile_details_page/user_profile_page/pages/store/user_profile_store.dart'
    as _i46;
import '../ui/pages/main_page/quest_details_page/details/store/quest_details_store.dart'
    as _i24;
import '../ui/pages/main_page/quest_details_page/dispute_page/store/open_dispute_store.dart'
    as _i23;
import '../ui/pages/main_page/quest_details_page/employer/store/employer_store.dart'
    as _i19;
import '../ui/pages/main_page/quest_details_page/worker/store/worker_store.dart'
    as _i32;
import '../ui/pages/main_page/quest_page/create_quest_page/store/create_quest_store.dart'
    as _i13;
import '../ui/pages/main_page/quest_page/filter_quests_page/store/filter_quests_store.dart'
    as _i36;
import '../ui/pages/main_page/quest_page/notification_page/store/notification_store.dart'
    as _i22;
import '../ui/pages/main_page/quest_page/quest_list/store/quests_store.dart'
    as _i42;
import '../ui/pages/main_page/quest_page/quest_map/store/quest_map_store.dart'
    as _i41;
import '../ui/pages/main_page/raise_views_page/store/raise_views_store.dart'
    as _i25;
import '../ui/pages/main_page/settings_page/pages/2FA_page/2FA_store.dart'
    as _i45;
import '../ui/pages/main_page/settings_page/pages/my_disputes/dispute/store/dispute_store.dart'
    as _i17;
import '../ui/pages/main_page/settings_page/pages/my_disputes/store/my_disputes_store.dart'
    as _i21;
import '../ui/pages/main_page/settings_page/pages/SMS_verification_page/store/sms_verification_store.dart'
    as _i43;
import '../ui/pages/main_page/settings_page/store/settings_store.dart' as _i27;
import '../ui/pages/main_page/wallet_page/deposit_page/store/deposit_store.dart'
    as _i16;
import '../ui/pages/main_page/wallet_page/store/wallet_store.dart' as _i34;
import '../ui/pages/main_page/wallet_page/swap_page/store/swap_store.dart'
    as _i7;
import '../ui/pages/main_page/wallet_page/transactions/store/transactions_store.dart'
    as _i44;
import '../ui/pages/main_page/wallet_page/transfer_page/confirm_page/mobx/confirm_transfer_store.dart'
    as _i3;
import '../ui/pages/main_page/wallet_page/transfer_page/mobx/transfer_store.dart'
    as _i33;
import '../ui/pages/main_page/wallet_page/withdraw_page/store/withdraw_page_store.dart'
    as _i31;
import '../ui/pages/pin_code_page/store/pin_code_store.dart' as _i38;
import '../ui/pages/profile_me_store/profile_me_store.dart' as _i40;
import '../ui/pages/restore_password_page/store.dart' as _i26;
import '../ui/pages/sign_in_page/store/sign_in_store.dart' as _i28;
import '../ui/pages/sign_up_page/choose_role_page/store/choose_role_store.dart'
    as _i11;
import '../ui/pages/sign_up_page/generate_wallet/create_wallet_store.dart'
    as _i15;
import '../ui/pages/sign_up_page/store/sign_up_store.dart' as _i29;

const String _test = 'test';
const String _dev = 'dev';
const String _prod = 'prod';

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
    gh.factory<_i6.LogService>(() => _i6.LogServiceDev(),
        registerFor: {_dev, _test});
    gh.factory<_i6.LogService>(() => _i6.LogServiceProd(),
        registerFor: {_prod});
    gh.factory<_i7.SwapStore>(() => _i7.SwapStore());
    gh.factory<_i8.ChatRoomStore>(
        () => _i8.ChatRoomStore(get<_i9.ApiProvider>()));
    gh.factory<_i10.ChooseQuestStore>(
        () => _i10.ChooseQuestStore(get<_i9.ApiProvider>()));
    gh.factory<_i11.ChooseRoleStore>(
        () => _i11.ChooseRoleStore(get<_i9.ApiProvider>()));
    gh.factory<_i12.CreatePrivateStore>(
        () => _i12.CreatePrivateStore(get<_i9.ApiProvider>()));
    gh.factory<_i13.CreateQuestStore>(
        () => _i13.CreateQuestStore(get<_i9.ApiProvider>()));
    gh.factory<_i14.CreateReviewStore>(
        () => _i14.CreateReviewStore(get<_i9.ApiProvider>()));
    gh.factory<_i15.CreateWalletStore>(
        () => _i15.CreateWalletStore(get<_i9.ApiProvider>()));
    gh.factory<_i16.DepositStore>(
        () => _i16.DepositStore(get<_i9.ApiProvider>()));
    gh.factory<_i17.DisputeStore>(
        () => _i17.DisputeStore(get<_i9.ApiProvider>()));
    gh.factory<_i18.EditChatStore>(
        () => _i18.EditChatStore(get<_i9.ApiProvider>()));
    gh.factory<_i19.EmployerStore>(
        () => _i19.EmployerStore(get<_i9.ApiProvider>()));
    gh.factory<_i20.GroupChatStore>(
        () => _i20.GroupChatStore(get<_i9.ApiProvider>()));
    gh.factory<_i21.MyDisputesStore>(
        () => _i21.MyDisputesStore(get<_i9.ApiProvider>()));
    gh.factory<_i22.NotificationStore>(
        () => _i22.NotificationStore(get<_i9.ApiProvider>()));
    gh.factory<_i23.OpenDisputeStore>(
        () => _i23.OpenDisputeStore(get<_i9.ApiProvider>()));
    gh.factory<_i24.QuestDetailsStore>(
        () => _i24.QuestDetailsStore(get<_i9.ApiProvider>()));
    gh.factory<_i25.RaiseViewStore>(
        () => _i25.RaiseViewStore(get<_i9.ApiProvider>()));
    gh.factory<_i26.RestorePasswordStore>(
        () => _i26.RestorePasswordStore(get<_i9.ApiProvider>()));
    gh.factory<_i27.SettingsPageStore>(
        () => _i27.SettingsPageStore(get<_i9.ApiProvider>()));
    gh.factory<_i28.SignInStore>(
        () => _i28.SignInStore(get<_i9.ApiProvider>()));
    gh.factory<_i29.SignUpStore>(
        () => _i29.SignUpStore(get<_i9.ApiProvider>()));
    gh.factory<_i30.StarredMessageStore>(
        () => _i30.StarredMessageStore(get<_i9.ApiProvider>()));
    gh.factory<_i31.WithdrawPageStore>(
        () => _i31.WithdrawPageStore(get<_i9.ApiProvider>()));
    gh.factory<_i32.WorkerStore>(
        () => _i32.WorkerStore(get<_i9.ApiProvider>()));
    gh.singleton<_i33.TransferStore>(_i33.TransferStore());
    gh.singleton<_i34.WalletStore>(_i34.WalletStore());
    gh.singleton<_i9.ApiProvider>(_i9.ApiProvider(get<_i4.IHttpClient>()));
    gh.singleton<_i35.ChatStore>(_i35.ChatStore(get<_i9.ApiProvider>()));
    gh.singleton<_i36.FilterQuestsStore>(
        _i36.FilterQuestsStore(get<_i9.ApiProvider>()));
    gh.singleton<_i37.MyQuestStore>(_i37.MyQuestStore(get<_i9.ApiProvider>()));
    gh.singleton<_i38.PinCodeStore>(_i38.PinCodeStore(get<_i9.ApiProvider>()));
    gh.singleton<_i39.PortfolioStore>(
        _i39.PortfolioStore(get<_i9.ApiProvider>()));
    gh.singleton<_i40.ProfileMeStore>(
        _i40.ProfileMeStore(get<_i9.ApiProvider>()));
    gh.singleton<_i41.QuestMapStore>(
        _i41.QuestMapStore(get<_i9.ApiProvider>()));
    gh.singleton<_i42.QuestsStore>(_i42.QuestsStore(get<_i9.ApiProvider>()));
    gh.singleton<_i43.SMSVerificationStore>(
        _i43.SMSVerificationStore(get<_i9.ApiProvider>()));
    gh.singleton<_i44.TransactionsStore>(
        _i44.TransactionsStore(get<_i9.ApiProvider>()));
    gh.singleton<_i45.TwoFAStore>(_i45.TwoFAStore(get<_i9.ApiProvider>()));
    gh.singleton<_i46.UserProfileStore>(
        _i46.UserProfileStore(get<_i9.ApiProvider>()));
    return this;
  }
}
