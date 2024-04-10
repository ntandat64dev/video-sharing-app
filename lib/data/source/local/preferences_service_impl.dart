import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_sharing_app/data/source/local/preferences_service.dart';
import 'package:video_sharing_app/domain/entity/user.dart';

const String _kFirstLaunch = 'is_first_launch';
const String _kUser = 'user';

class PreferencesServiceImpl implements PreferencesService {
  static PreferencesServiceImpl? _instance;
  static late SharedPreferences _prefs;
  static bool _isInit = false;

  PreferencesServiceImpl._();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isInit = true;
  }

  static PreferencesServiceImpl getInstance() {
    if (_isInit == false) throw Exception('SharedPreferences was not initialized!');
    _instance ??= PreferencesServiceImpl._();
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

  void _removeData(String key) => _prefs.remove(key);

  @override
  bool get isFirstLaunched => _getData(_kFirstLaunch) ?? false;

  @override
  set isFirstLaunched(bool value) => _setData(_kFirstLaunch, value);

  @override
  User? getUser() => _getData(_kUser) != null ? User.fromJson(jsonDecode(_getData(_kUser))) : null;

  @override
  void setUser(User user) => _setData(_kUser, jsonEncode(user.toJson()));

  @override
  void removeUser() => _removeData(_kUser);
}
