import 'package:app/utils/storage.dart';
import 'package:app/work_quest_app.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'di/injector.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  injectDependencies(env: Environment.test);
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        child: WorkQuestApp(await Storage.toLoginCheck()),
        supportedLocales: [Locale('en', 'US'), Locale('ru', 'RU'), Locale('ar','SA')],
        path: 'assets/lang',
        ),
  );
}
