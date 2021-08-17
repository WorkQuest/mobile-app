// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../http/api_provider.dart' as _i7;
import '../http/core/http_client.dart' as _i4;
import '../http/core/i_http_client.dart' as _i3;
import '../log_service.dart' as _i5;
import '../ui/pages/main_page/create_quest_page/store/create_quest_store.dart'
    as _i8;
import '../ui/pages/main_page/my_quests_page/store/my_quest_store.dart' as _i10;
import '../ui/pages/main_page/quest_page/quest_list/store/quests_store.dart'
    as _i12;
import '../ui/pages/main_page/quest_page/quest_map/store/quest_map_store.dart'
    as _i11;
import '../ui/pages/main_page/raise_views_page/store/raise_views_store.dart'
    as _i13;
import '../ui/pages/main_page/settings_page/SMS_verification_page/store/sms_verification_store.dart'
    as _i14;
import '../ui/pages/main_page/settings_page/store/settings_store.dart' as _i15;
import '../ui/pages/main_page/wallet_page/deposit_page/store/deposit_store.dart'
    as _i9;
import '../ui/pages/main_page/wallet_page/store/wallet_store.dart' as _i18;
import '../ui/pages/main_page/wallet_page/withdraw_page/store/withdraw_page_store.dart'
    as _i19;
import '../ui/pages/pin_code_page/store/pin_code_store.dart' as _i20;
import '../ui/pages/profile_me_store/profile_me_store.dart' as _i21;
import '../ui/pages/sign_in_page/store/sign_in_store.dart' as _i16;
import '../ui/pages/sign_up_page/choose_role_page/store/choose_role_store.dart'
    as _i6;
import '../ui/pages/sign_up_page/store/sign_up_store.dart' as _i17;

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
    gh.factory<_i3.IHttpClient>(() => _i4.TestHttpClient(),
        registerFor: {_test});
    gh.factory<_i5.LogService>(() => _i5.LogServiceDev(),
        registerFor: {_dev, _test});
    gh.factory<_i5.LogService>(() => _i5.LogServiceProd(),
        registerFor: {_prod});
    gh.factory<_i6.ChooseRoleStore>(
        () => _i6.ChooseRoleStore(get<_i7.ApiProvider>()));
    gh.factory<_i8.CreateQuestStore>(
        () => _i8.CreateQuestStore(get<_i7.ApiProvider>()));
    gh.factory<_i9.DepositStore>(
        () => _i9.DepositStore(get<_i7.ApiProvider>()));
    gh.factory<_i10.MyQuestStore>(
        () => _i10.MyQuestStore(get<_i7.ApiProvider>()));
    gh.factory<_i11.QuestMapStore>(
        () => _i11.QuestMapStore(get<_i7.ApiProvider>()));
    gh.factory<_i12.QuestsStore>(
        () => _i12.QuestsStore(get<_i7.ApiProvider>()));
    gh.factory<_i13.RaiseViewStore>(
        () => _i13.RaiseViewStore(get<_i7.ApiProvider>()));
    gh.factory<_i14.SMSVerificationStore>(
        () => _i14.SMSVerificationStore(get<_i7.ApiProvider>()));
    gh.factory<_i15.SettingsPageStore>(
        () => _i15.SettingsPageStore(get<_i7.ApiProvider>()));
    gh.factory<_i16.SignInStore>(
        () => _i16.SignInStore(get<_i7.ApiProvider>()));
    gh.factory<_i17.SignUpStore>(
        () => _i17.SignUpStore(get<_i7.ApiProvider>()));
    gh.factory<_i18.WalletStore>(
        () => _i18.WalletStore(get<_i7.ApiProvider>()));
    gh.factory<_i19.WithdrawPageStore>(
        () => _i19.WithdrawPageStore(get<_i7.ApiProvider>()));
    gh.singleton<_i7.ApiProvider>(_i7.ApiProvider(get<_i3.IHttpClient>()));
    gh.singleton<_i20.PinCodeStore>(_i20.PinCodeStore(get<_i7.ApiProvider>()));
    gh.singleton<_i21.ProfileMeStore>(
        _i21.ProfileMeStore(get<_i7.ApiProvider>()));
    return this;
  }
}
