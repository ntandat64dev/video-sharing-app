abstract class PreferenceRepository {
  dynamic getPreference(String key, [String? defaultValue]);
  void setPreference<T>(String key, T value);
}
