import 'package:flutter/material.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/presentation/app_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependenciesForTest();
  runApp(const AppRoot());
}
