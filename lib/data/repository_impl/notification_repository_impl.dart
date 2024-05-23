import 'package:video_sharing_app/data/source/remote/notification_api.dart';
import 'package:video_sharing_app/domain/entity/notification.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl({required NotificationApi notificationApi}) : _notificationApi = notificationApi;

  late final NotificationApi _notificationApi;

  @override
  Future<bool> registerMessageToken(String token) async {
    try {
      await _notificationApi.registerMessageToken(token);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> unregisterMessageToken(String token) async {
    try {
      await _notificationApi.unregisterMessageToken(token);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<int> countUnseenNotifications() async {
    try {
      return await _notificationApi.countUnseenNotifications();
    } catch (e) {
      // Return -1 if error.
      return -1;
    }
  }

  @override
  Future<PageResponse<Notification>> getMyNotifications([Pageable? pageable]) async {
    try {
      return await _notificationApi.getMyNotifications(pageable ?? Pageable());
    } catch (e) {
      return PageResponse.empty();
    }
  }

  @override
  Future<bool> readNotification(String id) async {
    try {
      await _notificationApi.readNotification(id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
