import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/presentation/pages/feature/home/video_player_page.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';

class VideoCard extends StatefulWidget {
  const VideoCard({super.key, required this.video});

  final Video video;

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  static const videoThumbnailHeight = 220.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final route = MaterialPageRoute(
          builder: (context) => VideoPlayerPage(video: widget.video),
          settings: const RouteSettings(name: 'video_player_route'),
        );
        if (ModalRoute.of(context)?.settings.name == 'video_player_route') {
          Navigator.pushReplacement(context, route);
        } else {
          Navigator.push(context, route);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: FadeInImage.assetNetwork(
                  fadeInDuration: const Duration(milliseconds: 300),
                  fadeOutDuration: const Duration(milliseconds: 1),
                  height: videoThumbnailHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: Asset.placeholder,
                  image: widget.video.thumbnails![Thumbnail.kDefault]!.url),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 16.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(widget.video.channelImageUrl!),
                            radius: 22.0,
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.video.title!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          height: 1.25,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        'BBC Learning  ∙  ${widget.video.viewCount} views  ∙  ${timeago.format(widget.video.publishedAt!)}',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                          height: 1.25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // More button
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20.0),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
