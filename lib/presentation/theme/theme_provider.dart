import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_sharing_app/data/repository_impl/preference_repository_impl.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/repository/preference_repository.dart';

class ThemeProvider extends ChangeNotifier {
  final _preferenceRepository = getIt<PreferenceRepository>();

  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    final mode = _preferenceRepository.getPreference(kSettingTheme, ThemeMode.system.name);
    _themeMode = mode == 'light'
        ? ThemeMode.light
        : mode == 'dark'
            ? ThemeMode.dark
            : ThemeMode.system;
  }

  void changeStatusBarColor(BuildContext context) {
    final platformBrightness = PlatformDispatcher.instance.platformBrightness;

    Brightness determineBrightness() {
      if (themeMode == ThemeMode.light) return Brightness.dark;
      if (themeMode == ThemeMode.dark) return Brightness.light;
      return platformBrightness == Brightness.dark ? Brightness.light : Brightness.dark;
    }

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).colorScheme.background,
        statusBarBrightness: determineBrightness(),
        statusBarIconBrightness: determineBrightness(),
      ),
    );
  }

  String getLocalizedThemeModeName(BuildContext context) {
    return _themeMode == ThemeMode.light
        ? AppLocalizations.of(context)!.light
        : _themeMode == ThemeMode.dark
            ? AppLocalizations.of(context)!.dark
            : AppLocalizations.of(context)!.system;
  }

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode value) {
    _themeMode = value;
    _preferenceRepository.setPreference(kSettingTheme, value.name);
    notifyListeners();
  }
}
