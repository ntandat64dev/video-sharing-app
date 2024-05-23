import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/presentation/pages/feature/app_bar_provider.dart';
import 'package:video_sharing_app/presentation/pages/feature/notifications/notifications_page.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appBarProvider = Provider.of<AppBarProvider>(context);
    final unseen = appBarProvider.unseen;

    if (unseen > 0) {
      return IconButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationsPage()),
          );
          appBarProvider.unseen = 0;
        },
        icon: Badge(
          label: Text(unseen.toString()),
          child: const Icon(Icons.notifications_rounded),
        ),
      );
    } else {
      return IconButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationsPage()),
          );
          appBarProvider.unseen = 0;
        },
        icon: const Icon(Icons.notifications),
      );
    }
  }
}
