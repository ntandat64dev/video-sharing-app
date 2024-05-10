import 'package:flutter/material.dart';
import 'package:video_sharing_app/presentation/pages/feature/home/home_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/library/library_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/profile/profile_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/following/following_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) => setState(() => _currentNavIndex = index),
        selectedIndex: _currentNavIndex,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        destinations: [
          NavigationDestination(label: AppLocalizations.of(context)!.home, icon: const Icon(Icons.home)),
          NavigationDestination(label: AppLocalizations.of(context)!.following, icon: const Icon(Icons.group)),
          NavigationDestination(label: AppLocalizations.of(context)!.library, icon: const Icon(Icons.my_library_books)),
          NavigationDestination(label: AppLocalizations.of(context)!.profile, icon: const Icon(Icons.person)),
        ],
      ),
      body: const <Widget>[
        HomePage(),
        FollowingPage(),
        LibraryPage(),
        ProfilePage(),
      ][_currentNavIndex],
    );
  }
}
