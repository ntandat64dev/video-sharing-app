import 'package:video_sharing_app/domain/entity/notification.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';

abstract class NotificationRepository {
  Future<bool> registerMessageToken(String token);

  Future<bool> readNotification(String id);

  Future<int> countUnseenNotifications();

  Future<PageResponse<Notification>> getMyNotifications([Pageable? pageable]);
}
