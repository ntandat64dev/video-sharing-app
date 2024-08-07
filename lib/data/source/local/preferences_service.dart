import 'package:shared_preferences/shared_preferences.dart';

const String _kToken = 'token';
const String _kUserId = 'user_id';
const String _kUserImageUrl = 'user_image_url';
const String _kFirstLaunch = 'is_first_launch';

class PreferencesService {
  PreferencesService._();
  static late SharedPreferences _prefs;

  static Future<PreferencesService> createAsync() async {
    _prefs = await SharedPreferences.getInstance();
    return PreferencesService._();
  }

  dynamic getData(String key, {String? defaultVal}) {
    var value = _prefs.get(key);
    return value ?? defaultVal;
  }

  void setData(String key, dynamic value) {
    if (value is String) {
      _prefs.setString(key, value);
    } else if (value is int) {
      _prefs.setInt(key, value);
    } else if (value is double) {
      _prefs.setDouble(key, value);
    } else if (value is bool) {
      _prefs.setBool(key, value);
    } else if (value is List<String>) {
      _prefs.setStringList(key, value);
    }
  }

  void _removeData(String key) => _prefs.remove(key);

  bool get isFirstLaunched => getData(_kFirstLaunch) ?? false;
  set isFirstLaunched(bool value) => setData(_kFirstLaunch, value);

  void setToken(String token) => setData(_kToken, token);
  String? getToken() => getData(_kToken);

  void setUserId(String userId) => setData(_kUserId, userId);
  String? getUserId() => getData(_kUserId);

  void setUserImageUrl(String userImageUrl) => setData(_kUserImageUrl, userImageUrl);
  String? getUserImageUrl() => getData(_kUserImageUrl);

  void clearUser() {
    _removeData(_kToken);
    _removeData(_kUserId);
  }
}
