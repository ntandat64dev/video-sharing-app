import 'package:flutter/material.dart';
import 'package:video_sharing_app/data/source/local/preferences_service_impl.dart';
import 'package:video_sharing_app/presentation/app_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesServiceImpl.init();
  runApp(const AppRoot());
}
