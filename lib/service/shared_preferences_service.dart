import 'package:shared_preferences/shared_preferences.dart';

const String _kFirstLaunch = 'is_first_launch';
const String _kLoggedIn = 'is_logged_in';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static late SharedPreferences _prefs;

  SharedPreferencesService._();

  static Future<SharedPreferencesService> getInstance() async {
    _instance ??= SharedPreferencesService._();
    _prefs = await SharedPreferences.getInstance();
    return _instance!;
  }

  dynamic _getData(String key) {
    var value = _prefs.get(key);
    return value;
  }

  void _setData(String key, dynamic value) {
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

  bool get isFirstLaunched => _getData(_kFirstLaunch) ?? false;
  set isFirstLaunched(bool value) => _setData(_kFirstLaunch, value);

  bool get isLoggedIn => _getData(_kLoggedIn) ?? false;
  set isLoggedIn(bool value) => _setData(_kLoggedIn, value);
}
