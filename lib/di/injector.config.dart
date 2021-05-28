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
import '../ui/pages/sign_in_page/store/sign_in_store.dart' as _i7;
import '../ui/pages/sign_up_page/choose_role_page/store/choose_role_store.dart'
    as _i3;
import '../ui/pages/sign_up_page/store/sign_up_store.dart' as _i9;

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
    gh.factory<_i6.SignInStore>(() => _i6.SignInStore(get<_i7.ApiProvider>()));
    gh.factory<_i8.SignUpStore>(() => _i8.SignUpStore(get<_i7.ApiProvider>()));
    gh.singleton<_i7.ApiProvider>(_i7.ApiProvider(get<_i3.IHttpClient>()));
    return this;
  }
}
