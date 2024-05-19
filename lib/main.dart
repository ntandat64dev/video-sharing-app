import 'package:flutter/material.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/presentation/app_root.dart';
import 'package:video_sharing_app/service/firebase_service.dart' as firebase_service;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependenciesForTest();
  firebase_service.init();
  runApp(const AppRoot());
}
