import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const colorBackground = Color(0xFF000000);
const colorOnBackground = Color(0xFFFFFFFF);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: colorBackground,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ),
    surfaceTintColor: Colors.transparent,
    backgroundColor: colorBackground,
    titleTextStyle: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w500, color: colorOnBackground),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFF181A20),
    surfaceTintColor: colorBackground,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: colorBackground,
    surfaceTintColor: colorBackground,
    indicatorColor: const Color(0xFFFF4D67),
    iconTheme: MaterialStateProperty.resolveWith((Set<MaterialState> states) => states.contains(MaterialState.selected)
        ? const IconThemeData(color: colorOnBackground)
        : IconThemeData(color: colorOnBackground.withAlpha(180))),
    labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) => states.contains(MaterialState.selected)
          ? const TextStyle(color: colorOnBackground)
          : TextStyle(color: colorOnBackground.withAlpha(180)),
    ),
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFFF4D67),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF2a1e25),
    onPrimaryContainer: Color(0xFFFF4D67),
    secondary: Color(0xFFCCC2DC),
    onSecondary: Color(0xFF332D41),
    secondaryContainer: Color(0xFF4A4458),
    onSecondaryContainer: Color(0xFFE8DEF8),
    tertiary: Color(0xFFEFB8C8),
    onTertiary: Color(0xFF492532),
    tertiaryContainer: Color(0xFF633B48),
    onTertiaryContainer: Color(0xFFFFD8E4),
    surface: Color(0xFF141218),
    onSurface: Color(0xFFE6E0E9),
    surfaceVariant: Color(0xFF282828),
    onSurfaceVariant: Color(0xFFE5E5E5),
    inverseSurface: Color(0xFF35383F),
    onInverseSurface: Color(0xFFFFFFFF),
    background: colorBackground,
    onBackground: colorOnBackground,
    outline: Color(0xFF938F99),
    outlineVariant: Color(0xFF49454F),
    scrim: Color(0xFF000000),
    shadow: Color(0xFF000000),
    error: Color(0xFFF85656),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFF9DEDC),
  ),
);
