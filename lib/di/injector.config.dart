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
import '../ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart'
    as _i27;
import '../ui/pages/main_page/chat_page/store/chat_store.dart' as _i28;
import '../ui/pages/main_page/my_quests_page/store/my_quest_store.dart' as _i32;
import '../ui/pages/main_page/profile_details_page/portfolio_page/store/portfolio_store.dart'
    as _i34;
import '../ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/store/create_review_store.dart'
    as _i11;
import '../ui/pages/main_page/profile_details_page/user_profile_page/pages/store/user_profile_store.dart'
    as _i38;
import '../ui/pages/main_page/quest_details_page/dispute_page/store/open_dispute_store.dart'
    as _i17;
import '../ui/pages/main_page/quest_details_page/employer/store/employer_store.dart'
    as _i15;
import '../ui/pages/main_page/quest_details_page/worker/store/worker_store.dart'
    as _i26;
import '../ui/pages/main_page/quest_page/create_quest_page/store/create_quest_store.dart'
    as _i10;
import '../ui/pages/main_page/quest_page/filter_quests_page/store/filter_quests_store.dart'
    as _i31;
import '../ui/pages/main_page/quest_page/notification_page/store/notification_store.dart'
    as _i7;
import '../ui/pages/main_page/quest_page/quest_list/store/quests_store.dart'
    as _i36;
import '../ui/pages/main_page/quest_page/quest_map/store/quest_map_store.dart'
    as _i18;
import '../ui/pages/main_page/raise_views_page/store/raise_views_store.dart'
    as _i19;
import '../ui/pages/main_page/settings_page/pages/2FA_page/2FA_store.dart'
    as _i37;
import '../ui/pages/main_page/settings_page/pages/my_disputes/dispute/store/dispute_store.dart'
    as _i14;
import '../ui/pages/main_page/settings_page/pages/my_disputes/store/my_disputes_store.dart'
    as _i16;
import '../ui/pages/main_page/settings_page/pages/SMS_verification_page/store/sms_verification_store.dart'
    as _i21;
import '../ui/pages/main_page/settings_page/store/settings_store.dart' as _i22;
import '../ui/pages/main_page/wallet_page/deposit_page/store/deposit_store.dart'
    as _i13;
import '../ui/pages/main_page/wallet_page/store/wallet_store.dart' as _i39;
import '../ui/pages/main_page/wallet_page/transfer_page/confirm_page/mobx/confirm_transfer_store.dart'
    as _i3;
import '../ui/pages/main_page/wallet_page/transfer_page/mobx/transfer_store.dart'
    as _i30;
import '../ui/pages/main_page/wallet_page/withdraw_page/store/withdraw_page_store.dart'
    as _i25;
import '../ui/pages/pin_code_page/store/pin_code_store.dart' as _i33;
import '../ui/pages/profile_me_store/profile_me_store.dart' as _i35;
import '../ui/pages/restore_password_page/store.dart' as _i20;
import '../ui/pages/sign_in_page/store/sign_in_store.dart' as _i23;
import '../ui/pages/sign_up_page/choose_role_page/store/choose_role_store.dart'
    as _i8;
import '../ui/pages/sign_up_page/generate_wallet/create_wallet_store.dart'
    as _i12;
import '../ui/pages/sign_up_page/store/sign_up_store.dart' as _i24;
import '../web3/service/client_service.dart' as _i29;

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
    gh.factory<_i7.NotificationStore>(() => _i7.NotificationStore());
    gh.factory<_i8.ChooseRoleStore>(
        () => _i8.ChooseRoleStore(get<_i9.ApiProvider>()));
    gh.factory<_i10.CreateQuestStore>(
        () => _i10.CreateQuestStore(get<_i9.ApiProvider>()));
    gh.factory<_i11.CreateReviewStore>(
        () => _i11.CreateReviewStore(get<_i9.ApiProvider>()));
    gh.factory<_i12.CreateWalletStore>(
        () => _i12.CreateWalletStore(get<_i9.ApiProvider>()));
    gh.factory<_i13.DepositStore>(
        () => _i13.DepositStore(get<_i9.ApiProvider>()));
    gh.factory<_i14.DisputeStore>(
        () => _i14.DisputeStore(get<_i9.ApiProvider>()));
    gh.factory<_i15.EmployerStore>(
        () => _i15.EmployerStore(get<_i9.ApiProvider>()));
    gh.factory<_i16.MyDisputesStore>(
        () => _i16.MyDisputesStore(get<_i9.ApiProvider>()));
    gh.factory<_i17.OpenDisputeStore>(
        () => _i17.OpenDisputeStore(get<_i9.ApiProvider>()));
    gh.factory<_i18.QuestMapStore>(
        () => _i18.QuestMapStore(get<_i9.ApiProvider>()));
    gh.factory<_i19.RaiseViewStore>(
        () => _i19.RaiseViewStore(get<_i9.ApiProvider>()));
    gh.factory<_i20.RestorePasswordStore>(
        () => _i20.RestorePasswordStore(get<_i9.ApiProvider>()));
    gh.factory<_i21.SMSVerificationStore>(
        () => _i21.SMSVerificationStore(get<_i9.ApiProvider>()));
    gh.factory<_i22.SettingsPageStore>(
        () => _i22.SettingsPageStore(get<_i9.ApiProvider>()));
    gh.factory<_i23.SignInStore>(
        () => _i23.SignInStore(get<_i9.ApiProvider>()));
    gh.factory<_i24.SignUpStore>(
        () => _i24.SignUpStore(get<_i9.ApiProvider>()));
    gh.factory<_i25.WithdrawPageStore>(
        () => _i25.WithdrawPageStore(get<_i9.ApiProvider>()));
    gh.factory<_i26.WorkerStore>(
        () => _i26.WorkerStore(get<_i9.ApiProvider>()));
    gh.factory<_i27.ChatRoomStore>(() =>
        _i27.ChatRoomStore(get<_i9.ApiProvider>(), get<_i28.ChatStore>()));
    gh.singleton<_i29.ClientService>(_i29.ClientService());
    gh.singleton<_i30.TransferStore>(_i30.TransferStore());
    gh.singleton<_i9.ApiProvider>(_i9.ApiProvider(get<_i4.IHttpClient>()));
    gh.singleton<_i28.ChatStore>(_i28.ChatStore(get<_i9.ApiProvider>()));
    gh.singleton<_i31.FilterQuestsStore>(
        _i31.FilterQuestsStore(get<_i9.ApiProvider>()));
    gh.singleton<_i32.MyQuestStore>(_i32.MyQuestStore(get<_i9.ApiProvider>()));
    gh.singleton<_i33.PinCodeStore>(_i33.PinCodeStore(get<_i9.ApiProvider>()));
    gh.singleton<_i34.PortfolioStore>(
        _i34.PortfolioStore(get<_i9.ApiProvider>()));
    gh.singleton<_i35.ProfileMeStore>(
        _i35.ProfileMeStore(get<_i9.ApiProvider>()));
    gh.singleton<_i36.QuestsStore>(_i36.QuestsStore(get<_i9.ApiProvider>()));
    gh.singleton<_i37.TwoFAStore>(_i37.TwoFAStore(get<_i9.ApiProvider>()));
    gh.singleton<_i38.UserProfileStore>(
        _i38.UserProfileStore(get<_i9.ApiProvider>()));
    gh.singleton<_i39.WalletStore>(_i39.WalletStore(get<_i9.ApiProvider>()));
    return this;
  }
}
