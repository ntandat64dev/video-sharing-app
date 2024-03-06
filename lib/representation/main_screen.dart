import 'package:flutter/material.dart';
import 'package:video_sharing_app/representation/home/home_screen.dart';
import 'package:video_sharing_app/representation/notifications/notifications_screen.dart';
import 'package:video_sharing_app/representation/profile/profile_screen.dart';
import 'package:video_sharing_app/representation/shorts/shorts_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.videocam),
        title: const Text('MeTube'),
        titleSpacing: 0.0,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() => _currentNavIndex = index),
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentNavIndex,
        items: const [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'Shorts', icon: Icon(Icons.videocam)),
          BottomNavigationBarItem(label: 'Notifications', icon: Icon(Icons.notifications)),
          BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
        ],
      ),
      body: const <Widget>[
        HomeScreen(),
        ShortsScreen(),
        NotificationsScreen(),
        ProfileScreen(),
      ][_currentNavIndex],
    );
  }
}
