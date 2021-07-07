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
import '../ui/pages/main_page/create_quest_page/store/create_quest_store.dart'
    as _i8;
import '../ui/pages/main_page/quest_page/store/quests_store.dart' as _i11;
import '../ui/pages/main_page/settings_page/settings_page_employer/store/settings_store.dart'
    as _i12;
import '../ui/pages/profile_me_store/profile_me_store.dart' as _i10;
import '../ui/pages/sign_in_page/store/sign_in_store.dart' as _i13;
import '../ui/pages/sign_up_page/choose_role_page/store/choose_role_store.dart'
    as _i3;
import '../ui/pages/sign_up_page/store/sign_up_store.dart' as _i14;
import '../utils/set_environment.dart' as _i7;

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
    gh.factory<_i3.ChooseRoleStore>(() => _i3.ChooseRoleStore());
    gh.factory<_i4.IHttpClient>(() => _i5.TestHttpClient(),
        registerFor: {_test});
    gh.factory<_i6.LogService>(() => _i6.LogServiceDev(),
        registerFor: {_dev, _test});
    gh.factory<_i6.LogService>(() => _i6.LogServiceProd(),
        registerFor: {_prod});
    gh.factory<_i7.SetEnvironment>(() => _i7.SetEnvironment());
    gh.factory<_i8.CreateQuestStore>(
        () => _i8.CreateQuestStore(get<_i9.ApiProvider>()));
    gh.factory<_i10.ProfileMeStore>(
        () => _i10.ProfileMeStore(get<_i9.ApiProvider>()));
    gh.factory<_i11.QuestsStore>(
        () => _i11.QuestsStore(get<_i9.ApiProvider>()));
    gh.factory<_i12.SettingsPageStore>(
        () => _i12.SettingsPageStore(get<_i9.ApiProvider>()));
    gh.factory<_i13.SignInStore>(
        () => _i13.SignInStore(get<_i9.ApiProvider>()));
    gh.factory<_i14.SignUpStore>(
        () => _i14.SignUpStore(get<_i9.ApiProvider>()));
    gh.singleton<_i9.ApiProvider>(_i9.ApiProvider(get<_i4.IHttpClient>()));
    return this;
  }
}
