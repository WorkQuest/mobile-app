// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../http/api_provider.dart' as _i10;
import '../http/core/http_client.dart' as _i6;
import '../http/core/i_http_client.dart' as _i5;
import '../log_service.dart' as _i7;
import '../ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart'
    as _i27;
import '../ui/pages/main_page/chat_page/dispute_page/store/dispute_store.dart'
    as _i4;
import '../ui/pages/main_page/chat_page/store/chat_store.dart' as _i28;
import '../ui/pages/main_page/my_quests_page/store/my_quest_store.dart' as _i31;
import '../ui/pages/main_page/profile_details_page/portfolio_page/store/portfolio_store.dart'
    as _i33;
import '../ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/store/create_review_store.dart'
    as _i12;
import '../ui/pages/main_page/profile_details_page/user_profile_page/pages/store/user_profile_store.dart'
    as _i36;
import '../ui/pages/main_page/quest_details_page/employer/store/employer_store.dart'
    as _i15;
import '../ui/pages/main_page/quest_details_page/worker/store/worker_store.dart'
    as _i26;
import '../ui/pages/main_page/quest_page/create_quest_page/store/create_quest_store.dart'
    as _i11;
import '../ui/pages/main_page/quest_page/filter_quests_page/store/filter_quests_store.dart'
    as _i16;
import '../ui/pages/main_page/quest_page/notification_page/store/notification_store.dart'
    as _i8;
import '../ui/pages/main_page/quest_page/quest_list/store/quests_store.dart'
    as _i35;
import '../ui/pages/main_page/quest_page/quest_map/store/quest_map_store.dart'
    as _i17;
import '../ui/pages/main_page/raise_views_page/store/raise_views_store.dart'
    as _i18;
import '../ui/pages/main_page/settings_page/pages/2FA_page/2FA_store.dart'
    as _i24;
import '../ui/pages/main_page/settings_page/pages/SMS_verification_page/store/sms_verification_store.dart'
    as _i20;
import '../ui/pages/main_page/settings_page/store/settings_store.dart' as _i21;
import '../ui/pages/main_page/wallet_page/deposit_page/store/deposit_store.dart'
    as _i14;
import '../ui/pages/main_page/wallet_page/store/wallet_store.dart' as _i37;
import '../ui/pages/main_page/wallet_page/transfer_page/confirm_page/mobx/confirm_transfer_store.dart'
    as _i3;
import '../ui/pages/main_page/wallet_page/transfer_page/mobx/transfer_store.dart'
    as _i30;
import '../ui/pages/main_page/wallet_page/withdraw_page/store/withdraw_page_store.dart'
    as _i25;
import '../ui/pages/pin_code_page/store/pin_code_store.dart' as _i32;
import '../ui/pages/profile_me_store/profile_me_store.dart' as _i34;
import '../ui/pages/restore_password_page/store.dart' as _i19;
import '../ui/pages/sign_in_page/store/sign_in_store.dart' as _i22;
import '../ui/pages/sign_up_page/choose_role_page/store/choose_role_store.dart'
    as _i9;
import '../ui/pages/sign_up_page/generate_wallet/create_wallet_store.dart'
    as _i13;
import '../ui/pages/sign_up_page/store/sign_up_store.dart' as _i23;
import '../web3/service/client_service.dart' as _i29;

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
    gh.factory<_i4.DisputeStore>(() => _i4.DisputeStore());
    gh.factory<_i5.IHttpClient>(() => _i6.TestHttpClient(),
        registerFor: {_test});
    gh.factory<_i7.LogService>(() => _i7.LogServiceDev(),
        registerFor: {_dev, _test});
    gh.factory<_i7.LogService>(() => _i7.LogServiceProd(),
        registerFor: {_prod});
    gh.factory<_i8.NotificationStore>(() => _i8.NotificationStore());
    gh.factory<_i9.ChooseRoleStore>(
        () => _i9.ChooseRoleStore(get<_i10.ApiProvider>()));
    gh.factory<_i11.CreateQuestStore>(
        () => _i11.CreateQuestStore(get<_i10.ApiProvider>()));
    gh.factory<_i12.CreateReviewStore>(
        () => _i12.CreateReviewStore(get<_i10.ApiProvider>()));
    gh.factory<_i13.CreateWalletStore>(
        () => _i13.CreateWalletStore(get<_i10.ApiProvider>()));
    gh.factory<_i14.DepositStore>(
        () => _i14.DepositStore(get<_i10.ApiProvider>()));
    gh.factory<_i15.EmployerStore>(
        () => _i15.EmployerStore(get<_i10.ApiProvider>()));
    gh.factory<_i16.FilterQuestsStore>(
        () => _i16.FilterQuestsStore(get<_i10.ApiProvider>()));
    gh.factory<_i17.QuestMapStore>(
        () => _i17.QuestMapStore(get<_i10.ApiProvider>()));
    gh.factory<_i18.RaiseViewStore>(
        () => _i18.RaiseViewStore(get<_i10.ApiProvider>()));
    gh.factory<_i19.RestorePasswordStore>(
        () => _i19.RestorePasswordStore(get<_i10.ApiProvider>()));
    gh.factory<_i20.SMSVerificationStore>(
        () => _i20.SMSVerificationStore(get<_i10.ApiProvider>()));
    gh.factory<_i21.SettingsPageStore>(
        () => _i21.SettingsPageStore(get<_i10.ApiProvider>()));
    gh.factory<_i22.SignInStore>(
        () => _i22.SignInStore(get<_i10.ApiProvider>()));
    gh.factory<_i23.SignUpStore>(
        () => _i23.SignUpStore(get<_i10.ApiProvider>()));
    gh.factory<_i24.TwoFAStore>(() => _i24.TwoFAStore(get<_i10.ApiProvider>()));
    gh.factory<_i25.WithdrawPageStore>(
        () => _i25.WithdrawPageStore(get<_i10.ApiProvider>()));
    gh.factory<_i26.WorkerStore>(
        () => _i26.WorkerStore(get<_i10.ApiProvider>()));
    gh.factory<_i27.ChatRoomStore>(() =>
        _i27.ChatRoomStore(get<_i10.ApiProvider>(), get<_i28.ChatStore>()));
    gh.singleton<_i29.ClientService>(_i29.ClientService());
    gh.singleton<_i30.TransferStore>(_i30.TransferStore());
    gh.singleton<_i10.ApiProvider>(_i10.ApiProvider(get<_i5.IHttpClient>()));
    gh.singleton<_i28.ChatStore>(_i28.ChatStore(get<_i10.ApiProvider>()));
    gh.singleton<_i31.MyQuestStore>(_i31.MyQuestStore(get<_i10.ApiProvider>()));
    gh.singleton<_i32.PinCodeStore>(_i32.PinCodeStore(get<_i10.ApiProvider>()));
    gh.singleton<_i33.PortfolioStore>(
        _i33.PortfolioStore(get<_i10.ApiProvider>()));
    gh.singleton<_i34.ProfileMeStore>(
        _i34.ProfileMeStore(get<_i10.ApiProvider>()));
    gh.singleton<_i35.QuestsStore>(_i35.QuestsStore(get<_i10.ApiProvider>()));
    gh.singleton<_i36.UserProfileStore>(
        _i36.UserProfileStore(get<_i10.ApiProvider>()));
    gh.singleton<_i37.WalletStore>(_i37.WalletStore(get<_i10.ApiProvider>()));
    return this;
  }
}
