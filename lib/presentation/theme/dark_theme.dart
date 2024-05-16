import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFF141218),
  appBarTheme: const AppBarTheme(
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500, color: Color(0xFFE6E0E9)),
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFD0BCFF),
    onPrimary: Color(0xFF381E72),
    primaryContainer: Color(0xFF4F378B),
    onPrimaryContainer: Color(0xFFEADDFF),
    inversePrimary: Color(0xFF6750A4),
    secondary: Color(0xFFCCC2DC),
    onSecondary: Color(0xFF332D41),
    secondaryContainer: Color(0xFF4A4458),
    onSecondaryContainer: Color(0xFFE8DEF8),
    surface: Color(0xFF141218),
    onSurface: Color(0xFFE6E0E9),
    inverseSurface: Color(0xFFE6E0E9),
    onInverseSurface: Color(0xFF322F35),
    onSurfaceVariant: Color(0xFFCAC4D0),
    background: Color(0xFF141218),
    onBackground: Color(0xFFE6E0E9),
    outline: Color(0xFF938F99),
    outlineVariant: Color(0xFF49454F),
    scrim: Color(0xFF000000),
    shadow: Color(0xFF000000),
    tertiary: Color(0xFFEFB8C8),
    onTertiary: Color(0xFF492532),
    tertiaryContainer: Color(0xFF633B48),
    onTertiaryContainer: Color(0xFFFFD8E4),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFF9DEDC),
  ),
);

mixin labelStyle {}
