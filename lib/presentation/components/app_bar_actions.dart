import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/presentation/pages/feature/app_bar_provider.dart';
import 'package:video_sharing_app/presentation/pages/feature/notifications/notifications_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/searching/search_page.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appBarProvider = Provider.of<AppBarProvider>(context);
    final unseen = appBarProvider.unseen;

    return IconButton(
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotificationsPage()),
        );
        appBarProvider.unseen = 0;
      },
      icon: unseen > 0
          ? Badge(
              label: Text(unseen.toString()),
              child: const Icon(CupertinoIcons.bell),
            )
          : const Icon(CupertinoIcons.bell),
    );
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchPage())),
      icon: const Icon(CupertinoIcons.search),
    );
  }
}

class MoreButon extends StatelessWidget {
  const MoreButon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(CupertinoIcons.ellipsis_circle),
    );
  }
}
