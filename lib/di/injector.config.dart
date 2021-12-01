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
import '../ui/pages/main_page/chat_page/chat_room_page/store/chat_room_store.dart'
    as _i24;
import '../ui/pages/main_page/chat_page/dispute_page/store/dispute_store.dart'
    as _i3;
import '../ui/pages/main_page/chat_page/store/chat_store.dart' as _i25;
import '../ui/pages/main_page/my_quests_page/store/my_quest_store.dart' as _i26;
import '../ui/pages/main_page/profile_details_page/portfolio_page/store/portfolio_store.dart'
    as _i28;
import '../ui/pages/main_page/profile_details_page/user_profile_page/pages/create_review_page/store/create_review_store.dart'
    as _i10;
import '../ui/pages/main_page/quest_details_page/employer/store/employer_store.dart'
    as _i12;
import '../ui/pages/main_page/quest_details_page/worker/store/worker_store.dart'
    as _i23;
import '../ui/pages/main_page/quest_page/create_quest_page/store/create_quest_store.dart'
    as _i9;
import '../ui/pages/main_page/quest_page/quest_list/store/quests_store.dart'
    as _i30;
import '../ui/pages/main_page/quest_page/quest_map/store/quest_map_store.dart'
    as _i13;
import '../ui/pages/main_page/raise_views_page/store/raise_views_store.dart'
    as _i14;
import '../ui/pages/main_page/settings_page/pages/2FA_page/2FA_store.dart'
    as _i20;
import '../ui/pages/main_page/settings_page/pages/SMS_verification_page/store/sms_verification_store.dart'
    as _i16;
import '../ui/pages/main_page/settings_page/store/settings_store.dart' as _i17;
import '../ui/pages/main_page/wallet_page/deposit_page/store/deposit_store.dart'
    as _i11;
import '../ui/pages/main_page/wallet_page/store/wallet_store.dart' as _i21;
import '../ui/pages/main_page/wallet_page/withdraw_page/store/withdraw_page_store.dart'
    as _i22;
import '../ui/pages/pin_code_page/store/pin_code_store.dart' as _i27;
import '../ui/pages/profile_me_store/profile_me_store.dart' as _i29;
import '../ui/pages/restore_password_page/store.dart' as _i15;
import '../ui/pages/sign_in_page/store/sign_in_store.dart' as _i18;
import '../ui/pages/sign_up_page/choose_role_page/store/choose_role_store.dart'
    as _i7;
import '../ui/pages/sign_up_page/store/sign_up_store.dart' as _i19;

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
    gh.factory<_i3.DisputeStore>(() => _i3.DisputeStore());
    gh.factory<_i4.IHttpClient>(() => _i5.TestHttpClient(),
        registerFor: {_test});
    gh.factory<_i6.LogService>(() => _i6.LogServiceDev(),
        registerFor: {_dev, _test});
    gh.factory<_i6.LogService>(() => _i6.LogServiceProd(),
        registerFor: {_prod});
    gh.factory<_i7.ChooseRoleStore>(
        () => _i7.ChooseRoleStore(get<_i8.ApiProvider>()));
    gh.factory<_i9.CreateQuestStore>(
        () => _i9.CreateQuestStore(get<_i8.ApiProvider>()));
    gh.factory<_i10.CreateReviewStore>(
        () => _i10.CreateReviewStore(get<_i8.ApiProvider>()));
    gh.factory<_i11.DepositStore>(
        () => _i11.DepositStore(get<_i8.ApiProvider>()));
    gh.factory<_i12.EmployerStore>(
        () => _i12.EmployerStore(get<_i8.ApiProvider>()));
    gh.factory<_i13.QuestMapStore>(
        () => _i13.QuestMapStore(get<_i8.ApiProvider>()));
    gh.factory<_i14.RaiseViewStore>(
        () => _i14.RaiseViewStore(get<_i8.ApiProvider>()));
    gh.factory<_i15.RestorePasswordStore>(
        () => _i15.RestorePasswordStore(get<_i8.ApiProvider>()));
    gh.factory<_i16.SMSVerificationStore>(
        () => _i16.SMSVerificationStore(get<_i8.ApiProvider>()));
    gh.factory<_i17.SettingsPageStore>(
        () => _i17.SettingsPageStore(get<_i8.ApiProvider>()));
    gh.factory<_i18.SignInStore>(
        () => _i18.SignInStore(get<_i8.ApiProvider>()));
    gh.factory<_i19.SignUpStore>(
        () => _i19.SignUpStore(get<_i8.ApiProvider>()));
    gh.factory<_i20.TwoFAStore>(() => _i20.TwoFAStore(get<_i8.ApiProvider>()));
    gh.factory<_i21.WalletStore>(
        () => _i21.WalletStore(get<_i8.ApiProvider>()));
    gh.factory<_i22.WithdrawPageStore>(
        () => _i22.WithdrawPageStore(get<_i8.ApiProvider>()));
    gh.factory<_i23.WorkerStore>(
        () => _i23.WorkerStore(get<_i8.ApiProvider>()));
    gh.factory<_i24.ChatRoomStore>(() =>
        _i24.ChatRoomStore(get<_i8.ApiProvider>(), get<_i25.ChatStore>()));
    gh.singleton<_i8.ApiProvider>(_i8.ApiProvider(get<_i4.IHttpClient>()));
    gh.singleton<_i25.ChatStore>(_i25.ChatStore(get<_i8.ApiProvider>()));
    gh.singleton<_i26.MyQuestStore>(_i26.MyQuestStore(get<_i8.ApiProvider>()));
    gh.singleton<_i27.PinCodeStore>(_i27.PinCodeStore(get<_i8.ApiProvider>()));
    gh.singleton<_i28.PortfolioStore>(
        _i28.PortfolioStore(get<_i8.ApiProvider>()));
    gh.singleton<_i29.ProfileMeStore>(
        _i29.ProfileMeStore(get<_i8.ApiProvider>()));
    gh.singleton<_i30.QuestsStore>(_i30.QuestsStore(get<_i8.ApiProvider>()));
    return this;
  }
}
