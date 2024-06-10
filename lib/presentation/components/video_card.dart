import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/presentation/components/bottom_sheet.dart';
import 'package:video_sharing_app/presentation/components/duration_chip.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/my_video_player.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/video_detail/video_detail.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/video_player_page.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final route = MaterialPageRoute(
          builder: (context) => VideoPlayerPage(video: video),
          settings: const RouteSettings(name: videoPlayerRoute),
        );
        if (ModalRoute.of(context)?.settings.name == videoPlayerRoute) {
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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: CachedNetworkImage(
                    imageUrl: video.thumbnails![Thumbnail.kDefault]!.url,
                    fadeInDuration: const Duration(milliseconds: 300),
                    fadeOutDuration: const Duration(milliseconds: 1),
                    height: videoPlayerHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                      Asset.placeholder,
                      height: videoPlayerHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                DurationChip(isoDuration: video.duration!),
              ],
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: CachedNetworkImage(
                              imageUrl: video.userImageUrl!,
                              fadeInDuration: const Duration(milliseconds: 300),
                              fadeOutDuration: const Duration(milliseconds: 1),
                              fit: BoxFit.cover,
                              width: 46.0,
                              height: 46.0,
                            ),
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
                                        video.title!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          height: 1.25,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        '${video.username}  ∙  ${AppLocalizations.of(context)!.nViews(video.viewCount!.toInt())}  ∙  ${timeago.format(video.publishedAt!)}',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onBackground.withAlpha(200),
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
                    onPressed: () => showOptionBottomSheet(context, video: video),
                    icon: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).colorScheme.onBackground.withAlpha(200),
                      size: 20.0,
                    ),
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

void showOptionBottomSheet(BuildContext context, {required Video video}) => showConsistentBottomSheet(
      context: context,
      height: 230.0,
      negativeButton: bottomSheetNegativeButton(context: context),
      content: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
                showSaveVideoBottomSheet(
                  context: context,
                  videoId: video.id!,
                  refreshPlaylists: () {},
                );
              },
              child: ListTile(
                leading: const Icon(CupertinoIcons.trash),
                title: Text(AppLocalizations.of(context)!.saveToPlaylist),
              ),
            ),
            InkWell(
              onTap: () async {},
              child: ListTile(
                leading: const Icon(CupertinoIcons.arrowshape_turn_up_right),
                title: Text(AppLocalizations.of(context)!.shareButton),
              ),
            ),
          ],
        ),
      ),
    );
