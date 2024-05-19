import 'package:video_sharing_app/domain/repository/preference_repository.dart';

const String kSettingTheme = 'theme';
const String kSettingLocale = 'locale';

class FakePreferenceRepositoryImpl implements PreferenceRepository {

  @override
  dynamic getPreference(String key, [String? defaultValue]) => defaultValue;

  @override
  void setPreference<T>(String key, T value) {}
}
