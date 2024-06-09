import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/playlist.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/playlist_repository.dart';
import 'package:video_sharing_app/presentation/components/sink_animated.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/my_video_player.dart';
import 'package:video_sharing_app/presentation/theme/theme_provider.dart';

class PlaylistPlayer extends StatefulWidget {
  const PlaylistPlayer({
    super.key,
    required this.playlist,
    this.shuffle = false,
    this.initIndex = 0,
  });

  final Playlist playlist;
  final bool shuffle;
  final int initIndex;

  @override
  State<PlaylistPlayer> createState() => _PlaylistPlayerState();
}

class _PlaylistPlayerState extends State<PlaylistPlayer> {
  final playlistRepository = getIt<PlaylistRepository>();
  final List<Video> videos = [];
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initIndex;
    playlistRepository.getPlaylistItemVideos(widget.playlist.id!, Pageable(size: 10000)).then((value) {
      setState(() {
        videos.addAll(value.items);
        if (widget.shuffle) videos.shuffle();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Change status bar color to black for only this page.
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Provider.of<ThemeProvider>(context, listen: false).changeStatusBarColor(context);
        Navigator.pop(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              videos.isEmpty
                  ? AspectRatio(
                      aspectRatio: MediaQuery.of(context).size.width / videoPlayerHeight,
                      child: Container(color: Colors.black),
                    )
                  : MyVideoPlayer(
                      refresh: true,
                      video: videos[currentIndex],
                      onCompleted: () {
                        if (currentIndex < videos.length - 1) {
                          setState(() => currentIndex++);
                        }
                      },
                    ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      toolbarHeight: 110.0,
                      automaticallyImplyLeading: false,
                      titleSpacing: 0.0,
                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          widget.playlist.title!,
                                          style: const TextStyle(fontSize: 18.0),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          '∙',
                                          style: TextStyle(
                                            fontSize: 25.0,
                                            color: Theme.of(context).colorScheme.onBackground.withAlpha(190),
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          '${currentIndex + 1}/${widget.playlist.itemCount}',
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            color: Theme.of(context).colorScheme.onBackground.withAlpha(190),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          widget.playlist.username!,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context).colorScheme.onBackground.withAlpha(200),
                                          ),
                                        ),
                                        const SizedBox(width: 8.0),
                                        Icon(
                                          widget.playlist.privacy! == 'PRIVATE'
                                              ? Icons.lock_rounded
                                              : Icons.public_rounded,
                                          size: 16.0,
                                          color: Theme.of(context).colorScheme.onBackground.withAlpha(180),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0, right: 4.0),
                                child: InkWell(
                                  onTap: () {
                                    Provider.of<ThemeProvider>(context, listen: false).changeStatusBarColor(context);
                                    Navigator.pop(context);
                                  },
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(CupertinoIcons.clear),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              const SizedBox(width: 8.0),
                              InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(4.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.repeat_rounded,
                                    color: Theme.of(context).colorScheme.onBackground.withAlpha(200),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(4.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.shuffle_rounded,
                                    color: Theme.of(context).colorScheme.onBackground.withAlpha(200),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    videos.isEmpty
                        ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
                        : SliverList.builder(
                            itemCount: videos.length,
                            itemBuilder: (context, index) {
                              final video = videos[index];
                              return Material(
                                color: currentIndex == index ? Theme.of(context).colorScheme.surfaceVariant : null,
                                child: InkWell(
                                  onTap: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0, bottom: 12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.drag_handle_rounded),
                                              const SizedBox(width: 10.0),
                                              Column(
                                                children: [
                                                  const SizedBox(height: 4.0),
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(16.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl: video.thumbnails![Thumbnail.kDefault]!.url,
                                                      fit: BoxFit.cover,
                                                      width: 120.0,
                                                      height: 90.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(width: 16.0),
                                              Expanded(
                                                child: SizedBox(
                                                  height: 90.0,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        video.title!,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        video.username!,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(fontSize: 13.0),
                                                      ),
                                                      Text(
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        '${AppLocalizations.of(context)!.nViews(video.viewCount!.toInt())} ∙ ${timeago.format(video.publishedAt!)}',
                                                        style: const TextStyle(fontSize: 12.0),
                                                      ),
                                                      const SizedBox(height: 8.0),
                                                      Row(
                                                        children: [
                                                          const SizedBox(width: 2.0),
                                                          SinkAnimated(
                                                            onTap: () {},
                                                            child: Icon(
                                                              Icons.thumb_up_outlined,
                                                              size: 18.0,
                                                              color: Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground
                                                                  .withAlpha(200),
                                                            ),
                                                          ),
                                                          const SizedBox(width: 20.0),
                                                          SinkAnimated(
                                                            onTap: () {},
                                                            child: Icon(
                                                              Icons.thumb_down_outlined,
                                                              size: 18.0,
                                                              color: Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground
                                                                  .withAlpha(200),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          customBorder: const CircleBorder(),
                                          child: const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(Icons.more_vert, size: 18.0),
                                          ),
                                          onTap: () {},
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
