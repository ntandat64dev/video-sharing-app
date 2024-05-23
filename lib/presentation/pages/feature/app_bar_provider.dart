import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/repository/notification_repository.dart';

class AppBarProvider extends ChangeNotifier with WidgetsBindingObserver {
  final notificationRepository = getIt<NotificationRepository>();
  int _unseen = 0;

  AppBarProvider() {
    loadUnseenNotification();
    WidgetsBinding.instance.addObserver(this);
    FirebaseMessaging.onMessage.listen((_) =>loadUnseenNotification());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    loadUnseenNotification();
  }

  void loadUnseenNotification() async {
    final value = await notificationRepository.countUnseenNotifications();
    unseen = value;
  }

  int get unseen => _unseen;
  set unseen(value) {
    _unseen = value;
    notifyListeners();
  }
}
