import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_sharing_app/data/repository_impl/preference_repository_impl.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/repository/preference_repository.dart';

class LocaleProvider extends ChangeNotifier {
  final _preferenceRepository = getIt<PreferenceRepository>();

  late Locale _locale;

  LocaleProvider() {
    final code = _preferenceRepository.getPreference(kSettingLocale, 'en');
    _locale = Locale(code);
  }

  String getLocalizedLocaleName(BuildContext context) {
    return _locale == const Locale('en') ? AppLocalizations.of(context)!.langEn : AppLocalizations.of(context)!.langVi;
  }

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!AppLocalizations.supportedLocales.contains(locale)) return;
    _locale = locale;
    _preferenceRepository.setPreference(kSettingLocale, locale.languageCode);
    notifyListeners();
  }
}
