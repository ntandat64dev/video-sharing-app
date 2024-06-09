import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/presentation/pages/feature/app_bar_provider.dart';
import 'package:video_sharing_app/presentation/pages/feature/following/following_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/home/home_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/library/library_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/profile/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            height: 0.8,
            thickness: 0.8,
            color: Theme.of(context).colorScheme.surfaceVariant,
          ),
          NavigationBar(
            onDestinationSelected: (index) => setState(() => _currentNavIndex = index),
            selectedIndex: _currentNavIndex,
            destinations: [
              NavigationDestination(
                label: AppLocalizations.of(context)!.home,
                icon: const Icon(CupertinoIcons.home),
              ),
              NavigationDestination(
                label: AppLocalizations.of(context)!.following,
                icon: const Icon(CupertinoIcons.person_2),
              ),
              NavigationDestination(
                label: AppLocalizations.of(context)!.library,
                icon: const Icon(CupertinoIcons.collections),
              ),
              NavigationDestination(
                label: AppLocalizations.of(context)!.profile,
                icon: const Icon(CupertinoIcons.person),
              ),
            ],
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (context) => AppBarProvider(),
        builder: (context, child) {
          return const <Widget>[
            HomePage(),
            FollowingPage(),
            LibraryPage(),
            ProfilePage(),
          ][_currentNavIndex];
        },
      ),
    );
  }
}
