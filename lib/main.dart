import 'package:app/work_quest_app.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import 'di/injector.dart';

void main() {
  injectDependencies(env: Environment.test);
  runApp(WorkQuestApp());
}
