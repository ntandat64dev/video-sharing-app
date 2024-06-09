import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/notification.dart' as n;
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/repository/notification_repository.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/components/app_bar_actions.dart';
import 'package:video_sharing_app/presentation/components/app_bar_back_button.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/video_player_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  static const pageSize = 10;

  final notificationRepository = getIt<NotificationRepository>();
  final videoRepository = getIt<VideoRepository>();
  PagingController<int, n.Notification>? pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    pagingController!.addPageRequestListener(fetchPage);
  }

  @override
  void dispose() {
    pagingController!.dispose();
    pagingController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: appBarBackButton(context),
          title: Text(AppLocalizations.of(context)!.notificationsAppBarTitle),
          actions: const [
            MoreButon(),
          ],
        ),
        body: Center(
          child: PagedListView<int, n.Notification>(
            pagingController: pagingController!,
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) {
                return NotificationItem(
                  onTap: (notification) async {
                    if (notification.objectType == 'video') {
                      final video = await videoRepository.getVideoById(notification.objectId);
                      if (video != null && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerPage(video: video),
                            settings: const RouteSettings(name: videoPlayerRoute),
                          ),
                        );
                      }
                    }
                    if (notification.isRead == false) {
                      var isReadSuccess = await notificationRepository.readNotification(notification.id);
                      if (isReadSuccess) {
                        pagingController!.refresh();
                      }
                    }
                  },
                  notification: item,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void fetchPage(int page) async {
    final pageResponse = await notificationRepository.getMyNotifications(Pageable(page: page, size: pageSize));
    final isLastPage = pageResponse.items.length < pageSize;
    if (isLastPage) {
      pagingController?.appendLastPage(pageResponse.items);
    } else {
      final nextPage = page + 1;
      pagingController?.appendPage(pageResponse.items, nextPage);
    }
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.onTap,
    required this.notification,
  });

  final Function(n.Notification notification) onTap;
  final n.Notification notification;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(notification),
      child: Container(
        padding: const EdgeInsets.only(left: 16.0, top: 10.0, right: 16.0, bottom: 16.0),
        decoration: BoxDecoration(
          color: notification.isRead ? null : const Color.fromARGB(15, 0, 123, 255),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: CachedNetworkImage(
                  imageUrl: notification.actorImageUrl,
                  fit: BoxFit.cover,
                  width: 38.0,
                  height: 38.0,
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    timeago.format(notification.publishedAt),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            notification.thumbnails[Thumbnail.kDefault] != null
                ? Wrap(
                    children: [
                      const SizedBox(width: 6.0),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: CachedNetworkImage(
                            imageUrl: notification.thumbnails[Thumbnail.kDefault]!.url,
                            fit: BoxFit.cover,
                            width: 100.0,
                            height: 70.0,
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            const SizedBox(width: 6.0),
            InkWell(
              onTap: () {},
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.more_vert, size: 22.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
