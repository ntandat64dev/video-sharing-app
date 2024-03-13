import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_sharing_app/domain/entity/user.dart';

const String _kFirstLaunch = 'is_first_launch';
const String _kUser = 'user';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static late SharedPreferences _prefs;
  static bool _isInit = false;

  SharedPreferencesService._();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isInit = true;
  }

  static SharedPreferencesService getInstance() {
    if (_isInit == false) throw Exception('SharedPreferences was not initialized!');
    _instance ??= SharedPreferencesService._();
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

  User? getUser() => _getData(_kUser) != null ? User.fromJson(jsonDecode(_getData(_kUser))) : null;
  void setUser(User user) => _setData(_kUser, jsonEncode(user.toJson()));
}
