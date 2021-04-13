import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate delegate = _AppLocalizationsDelegate();

  Map<String, dynamic> _localizedStrings;

  Future<bool> load() async {
    // Load the language JSON file from the "lang" folder.
    String jsonString = await rootBundle.loadString("lang/${locale.languageCode}.json");
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value);
    });

    return true;
  }

  // This method will be called from every widget witch needs a localized text.
  String translate(String key, List<String> arguments) {
    final keys = key.split(".").toSet();

    String localizedStr = getLocalizedStr(_localizedStrings, keys);

    if (arguments == null) {
      return localizedStr;
    }

    for (var argument in arguments) {
      localizedStr = localizedStr.replaceFirst("{}", argument);
    }

    return localizedStr;
  }

  String getLocalizedStr(
    Map<String, dynamic> localizedStrings,
    Set<String> keys,
  ) {
    /// Get value from "lang/en.json" and can be String or Map<String, dynamic> only.
    final dynamic localizedStrValue = localizedStrings[keys.first];

    if (localizedStrValue is String) {
      return localizedStrValue;
    }

    if (localizedStrValue is Map<String, dynamic>) {
      return getLocalizedStr(localizedStrValue, keys..remove(keys.first));
    }

    return keys.toString();
  }
}

// LocalizationsDelegate is a factory for a set of localized resources.
// In this case, the localized strings will be gotten in an AppLocalizations object.
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all supported language codes hear.
    return ["en", "ru"].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where he JSON loading actually runs.
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}

extension AppLocalizationsExtension on BuildContext {
  String translate(String key, {List<String> arguments}) {
    return AppLocalizations.of(this).translate(key, arguments) ?? key;
  }
}
