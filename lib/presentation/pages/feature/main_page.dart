import 'package:flutter/material.dart';
import 'package:video_sharing_app/presentation/pages/feature/home/home_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/notifications/notifications_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/profile/profile_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/shorts/shorts_page.dart';

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
        destinations: const [
          NavigationDestination(label: 'Home', icon: Icon(Icons.home)),
          NavigationDestination(label: 'Shorts', icon: Icon(Icons.videocam)),
          NavigationDestination(label: 'Notifications', icon: Icon(Icons.notifications)),
          NavigationDestination(label: 'Profile', icon: Icon(Icons.person)),
        ],
      ),
      body: const <Widget>[
        HomePage(),
        ShortsPage(),
        NotificationsPage(),
        ProfilePage(),
      ][_currentNavIndex],
    );
  }
}
