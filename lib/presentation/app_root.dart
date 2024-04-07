import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
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
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: Provider.of<ThemeProvider>(context).themeMode,
        home: Builder(
          builder: (context) {
            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: Theme.of(context).colorScheme.surface,
                statusBarBrightness: MediaQuery.of(context).platformBrightness == Brightness.dark ? Brightness.light : Brightness.dark,
                statusBarIconBrightness: MediaQuery.of(context).platformBrightness == Brightness.dark ? Brightness.light : Brightness.dark,
              ),
            );
            return Provider.of<RouteProvider>(context).route;
          },
        ),
      ),
    );
  }
}
