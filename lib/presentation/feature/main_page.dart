import 'package:flutter/material.dart';
import 'package:video_sharing_app/presentation/feature/home/home_page.dart';
import 'package:video_sharing_app/presentation/feature/notifications/notifications_page.dart';
import 'package:video_sharing_app/presentation/feature/profile/profile_page.dart';
import 'package:video_sharing_app/presentation/feature/shorts/shorts_page.dart';

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
        HomePage(),
        ShortsPage(),
        NotificationsPage(),
        ProfilePage(),
      ][_currentNavIndex],
    );
  }
}
