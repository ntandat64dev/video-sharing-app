import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/domain/repository/preference_repository.dart';

const String kSettingTheme = 'theme';
const String kSettingLocale = 'locale';

class PreferenceRepositoryImpl implements PreferenceRepository {
  PreferenceRepositoryImpl({required PreferencesService pref}) : _prefs = pref;
  late final PreferencesService _prefs;

  @override
  dynamic getPreference(String key, [String? defaultValue]) => _prefs.getData(key, defaultVal: defaultValue);

  @override
  void setPreference<T>(String key, T value) => _prefs.setData(key, value);
}
