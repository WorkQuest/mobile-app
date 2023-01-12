import 'package:injectable/injectable.dart';

import 'di/injector.dart';

void println(String text, {String? tag}) {
  getIt.get<LogService>()._log(text);
}

@Injectable(as: LogService, env: [Environment.dev, Environment.test])
class LogServiceDev extends LogService {
  LogServiceDev() : super(Environment.dev);
}

@Injectable(as: LogService, env: [Environment.prod])
class LogServiceProd extends LogService {
  LogServiceProd() : super(Environment.prod);
}

abstract class LogService {
  final String _env;

  LogService(@factoryParam this._env);

  void _log(String text, [String? tag]) {
    if (_env != Environment.prod) {
      tag == null ? print(text) : print("$tag => $text");
    }
  }
}
