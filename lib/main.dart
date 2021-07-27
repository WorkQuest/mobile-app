import 'package:app/utils/storage.dart';
import 'package:app/work_quest_app.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'di/injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  injectDependencies(env: Environment.test);
  runApp(WorkQuestApp(await Storage.readRefreshToken() != null));
}
