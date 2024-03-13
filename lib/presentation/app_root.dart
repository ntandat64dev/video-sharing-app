import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';
import 'package:video_sharing_app/presentation/routing_change_notifier.dart';
import 'package:video_sharing_app/presentation/theme/dark_theme.dart';
import 'package:video_sharing_app/presentation/theme/light_theme.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage(Asset.illustration2), context);
    return ChangeNotifierProvider(
      create: (context) => RoutingProvider(),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: Provider.of<RoutingProvider>(context).route,
      ),
    );
  }
}
