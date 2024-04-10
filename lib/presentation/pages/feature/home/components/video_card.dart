import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
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
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerPage(video: widget.video))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage.assetNetwork(
                  fadeInDuration: const Duration(milliseconds: 300),
                  fadeOutDuration: const Duration(milliseconds: 1),
                  height: videoThumbnailHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: Asset.placeholder,
                  image: widget.video.thumbnailUrl),
            ),
            const SizedBox(height: 16.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(backgroundImage: NetworkImage(widget.video.channel.pictureUrl)),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.video.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '${widget.video.channel.name}  ∙  ${widget.video.viewCount} views  ∙  ${timeago.format(widget.video.uploadDate)}',
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      )
                    ],
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
