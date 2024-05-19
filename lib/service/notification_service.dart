import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

const androidNotificationChannelId = 'vs_channel_id';
const androidNotificationChannelName = 'Video Sharing Channel';

class NotificationService {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Create Android notification channel if it doesn't already exist.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            androidNotificationChannelId,
            androidNotificationChannelName,
            importance: Importance.max,
          ),
        );
  }

  void showNotificationAndroid({
    String? title,
    String? body,
    String? largeIconUrl,
    String? imageUrl,
  }) async {
    AndroidBitmap<Object>? largeIcon;
    if (largeIconUrl != null) {
      Uint8List largeIconBytes = await getImageBytes(largeIconUrl);
      largeIcon = ByteArrayAndroidBitmap(largeIconBytes);
    }

    StyleInformation? styleInformation;
    if (imageUrl != null) {
      Uint8List imageBytes = await getImageBytes(imageUrl);
      styleInformation = BigPictureStyleInformation(ByteArrayAndroidBitmap(imageBytes));
    }

    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(1000),
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidNotificationChannelId,
          androidNotificationChannelName,
          importance: Importance.max,
          priority: Priority.high,
          largeIcon: largeIcon,
          styleInformation: styleInformation,
        ),
      ),
    );
  }

  Future<Uint8List> getImageBytes(String imageUrl) async {
    var response = await http.get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }
}
