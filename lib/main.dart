import 'package:flutter/material.dart';
import 'package:video_sharing_app/data/source/local/shared_preferences_service.dart';
import 'package:video_sharing_app/presentation/app_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();
  runApp(const AppRoot());
}
