import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const colorBackground = Color(0xFFFFFFFF);
const colorOnBackground = Color(0xFF212121);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: colorBackground,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
    surfaceTintColor: Colors.transparent,
    backgroundColor: colorBackground,
    titleTextStyle: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500, color: colorOnBackground),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: colorBackground,
    surfaceTintColor: colorBackground,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: colorBackground,
    surfaceTintColor: colorBackground,
    indicatorColor: const Color(0xC0FF4D67),
    iconTheme: MaterialStateProperty.resolveWith((Set<MaterialState> states) => states.contains(MaterialState.selected)
        ? const IconThemeData(color: colorOnBackground)
        : IconThemeData(color: colorOnBackground.withAlpha(180))),
    labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) => states.contains(MaterialState.selected)
          ? const TextStyle(color: colorOnBackground)
          : TextStyle(color: colorOnBackground.withAlpha(180)),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF000000),
    contentTextStyle: TextStyle(color: Colors.white)
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFFF4D67),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFFE4E9),
    onPrimaryContainer: Color(0xFFFF4D67),
    secondary: Color(0xFF625B71),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFFFF1F3),
    onSecondaryContainer: Color(0xFF1D192B),
    tertiary: Color(0xFF7D5260),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFD8E4),
    onTertiaryContainer: Color(0xFF31111D),
    surface: Color(0xFFFBFAFA),
    onSurface: Color(0xFF1F1F1F),
    surfaceVariant: Color(0xFFEEEEEE),
    onSurfaceVariant: Color(0xFF1F1F1F),
    inverseSurface: Color(0xFFFFE4E9),
    onInverseSurface: Color(0xFFFF4D67),
    background: colorBackground,
    onBackground: colorOnBackground,
    outline: Color(0xFF7E7476),
    outlineVariant: Color(0xFFD0C4C8),
    scrim: Color(0xFF000000),
    shadow: Color(0xFF000000),
    error: Color(0xFFF85656),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),
  ),
);
