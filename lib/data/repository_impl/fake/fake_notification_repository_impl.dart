import 'package:video_sharing_app/domain/entity/notification.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/repository/notification_repository.dart';

class FakeNotificationRepositoryImpl implements NotificationRepository {
  FakeNotificationRepositoryImpl() {
    for (int i = 0; i < 10; i++) {
      var notification = Notification(
        id: '12345678',
        publishedAt: DateTime.now(),
        thumbnails: {
          Thumbnail.kDefault: const Thumbnail(
            url: 'https://dummyimage.com/720x450/fff/aaa',
            width: 100,
            height: 100,
          ),
        },
        actorId: '12345678',
        actorImageUrl:
            'https://ui-avatars.com/api/?name=Fake+User&size=500&background=0D8ABC&color=fff&rouded=true&bold=true',
        recipientId: 'recipientId',
        message: 'user1 uploaded: Video title',
        isSeen: false,
        isRead: false,
        actionType: 1,
        objectType: 'video',
        objectId: '12345678',
      );
      notifications.add(notification);
    }
  }

  final notifications = <Notification>[];

  @override
  Future<bool> registerMessageToken(String token) async {
    return true;
  }

  @override
  Future<int> countUnseenNotifications() async {
    return 5;
  }

  @override
  Future<PageResponse<Notification>> getMyNotifications([Pageable? pageable]) async {
    return PageResponse(
      pageNumber: 0,
      pageSize: notifications.length,
      totalElements: notifications.length,
      totalPages: 1,
      items: notifications,
    );
  }

  @override
  Future<bool> readNotification(String id) async {
    return true;
  }
}
