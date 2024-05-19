import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/repository/auth_repository.dart';
import 'package:video_sharing_app/domain/repository/notification_repository.dart';
import 'package:video_sharing_app/firebase_options.dart';
import 'package:video_sharing_app/service/notification_service.dart';

Future<void> messageHandler(RemoteMessage remoteMessage) async {
  final title = remoteMessage.data['title'] as String?;
  final body = remoteMessage.data['body'] as String?;
  final largeIcon = remoteMessage.data['large_icon'] as String?;
  final image = remoteMessage.data['image'] as String?;

  final notificationService = NotificationService();
  await notificationService.init();
  notificationService.showNotificationAndroid(
    title: title,
    body: body,
    largeIconUrl: largeIcon,
    imageUrl: image,
  );
}

Future<void> onRefreshToken(String newToken) async {
  if (getIt<AuthRepository>().wasUserLoggedIn()) {
    getIt<NotificationRepository>().registerMessageToken(newToken);
  }
}

Future<void> init() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(messageHandler);
  FirebaseMessaging.onMessage.listen(messageHandler);
  FirebaseMessaging.instance.onTokenRefresh.listen(onRefreshToken);
}

Future<String?> getToken() async => await FirebaseMessaging.instance.getToken();
