import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  set themeMode(vale) {
    _themeMode = vale;
    notifyListeners();
  }
}
