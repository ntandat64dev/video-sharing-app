import 'package:flutter/material.dart';
import 'package:video_sharing_app/representation/main_screen.dart';
import 'package:video_sharing_app/representation/themes/dark_theme.dart';
import 'package:video_sharing_app/representation/themes/light_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const MainScreen(),
    );
  }
}
