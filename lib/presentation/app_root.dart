import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/presentation/locale_provider.dart';
import 'package:video_sharing_app/presentation/route_provider.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';
import 'package:video_sharing_app/presentation/theme/dark_theme.dart';
import 'package:video_sharing_app/presentation/theme/light_theme.dart';
import 'package:video_sharing_app/presentation/theme/theme_provider.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage(Asset.illustration2), context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RouteProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: Provider.of<ThemeProvider>(context).themeMode,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('vi'),
        ],
        locale: Provider.of<LocaleProvider>(context).locale,
        home: Builder(
          builder: (context) {
            // Adjust status bar color.
            final platformBrightness = MediaQuery.of(context).platformBrightness;
            final theme = Provider.of<ThemeProvider>(context, listen: false).themeMode;
            final statusBarBrightness = theme == ThemeMode.light
                ? Brightness.dark
                : theme == ThemeMode.dark
                    ? Brightness.light
                    : platformBrightness == Brightness.dark
                        ? Brightness.light
                        : Brightness.dark;
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: Theme.of(context).colorScheme.surface,
                statusBarBrightness: statusBarBrightness,
                statusBarIconBrightness: statusBarBrightness,
              ),
            );
            return Provider.of<RouteProvider>(context).route;
          },
        ),
      ),
    );
  }
}
