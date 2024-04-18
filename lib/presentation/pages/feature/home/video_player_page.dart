import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/pages/feature/home/components/video_card.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({
    super.key,
    required Video video,
  }) : _video = video;

  final Video _video;

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  final VideoRepository videoRepository = VideoRepositoryImpl();

  late Future<VideoRating> videoRatingFuture;
  late Future<Comment?> topLevelCommentFuture;
  late Future<List<Video>> relatedVideosFuture;

  @override
  void initState() {
    super.initState();
    videoRatingFuture = videoRepository.getVideoRating(videoId: widget._video.id!);
    topLevelCommentFuture = videoRepository.getTopLevelComment(videoId: widget._video.id!);
    relatedVideosFuture = videoRepository.getRelatedVideos(videoId: widget._video.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Change status bar color to black.
      appBar: AppBar(
        toolbarHeight: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyVideoPlayer(video: widget._video),
            Expanded(
              child: FutureBuilder(
                future: Future.wait([videoRatingFuture, topLevelCommentFuture]),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null && snapshot.data!.length == 2) {
                    final videoRating = snapshot.data![0] as VideoRating;
                    final topLevelComment = snapshot.data![1] as Comment?;
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title, views, tags
                          InkWell(
                            onTap: () {},
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget._video.title!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        height: 1.25,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      '${widget._video.viewCount} views  ${timeago.format(widget._video.publishedAt!)}  ${widget._video.hashtags?.map((e) => '#${e.toLowerCase().replaceAll(' ', '')}').join(' ')}',
                                      maxLines: 1,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Channel, Subscribe button
                          InkWell(
                            onTap: () {},
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(backgroundImage: NetworkImage(widget._video.channelImageUrl!)),
                                        const SizedBox(width: 12.0),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(widget._video.channelTitle!, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                            Text('86K', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                      child: const Text('Subscribe'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Actions
                          SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    // TODO: Implement rating video
                                  },
                                  icon: Icon(
                                    Icons.thumb_up,
                                    color: videoRating.rating == Rating.like ? Colors.red : Theme.of(context).colorScheme.primary,
                                  ),
                                  label: Text(
                                    widget._video.likeCount.toString(),
                                    style: TextStyle(
                                      color: videoRating.rating == Rating.like ? Colors.red : Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    // TODO: Implement rating video
                                  },
                                  icon: Icon(
                                    Icons.thumb_down,
                                    color: videoRating.rating == Rating.dislike ? Colors.red : Theme.of(context).colorScheme.primary,
                                  ),
                                  label: Text(
                                    widget._video.dislikeCount.toString(),
                                    style: TextStyle(
                                      color: videoRating.rating == Rating.dislike ? Colors.red : Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.share),
                                  label: const Text('Share'),
                                ),
                                const SizedBox(width: 8.0),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.download),
                                  label: const Text('Download'),
                                ),
                                const SizedBox(width: 8.0),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.bookmark_outline),
                                  label: const Text('Save'),
                                ),
                              ],
                            ),
                          ),
                          // Comments
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Theme.of(context).colorScheme.outline.withAlpha(30),
                                  gradient: null,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0, top: 12.0, right: 16.0, bottom: 16.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Text('Comments', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                          const SizedBox(width: 8.0),
                                          Text(widget._video.commentCount.toString()),
                                        ],
                                      ),
                                      const SizedBox(height: 14.0),
                                      topLevelComment != null
                                          ? Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(widget._video.channelImageUrl!),
                                                  maxRadius: 16,
                                                ),
                                                const SizedBox(width: 8.0),
                                                Expanded(
                                                  child: Text(topLevelComment.text, maxLines: 2, overflow: TextOverflow.ellipsis),
                                                )
                                              ],
                                            )
                                          : Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(widget._video.channelImageUrl!),
                                                  maxRadius: 16,
                                                ),
                                                const SizedBox(width: 16.0),
                                                Expanded(
                                                  child: InkWell(
                                                    borderRadius: BorderRadius.circular(16.0),
                                                    onTap: () {},
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context).colorScheme.outline.withAlpha(40),
                                                        borderRadius: BorderRadius.circular(16.0),
                                                      ),
                                                      child: Text(
                                                        'Add a comment...',
                                                        style: TextStyle(fontSize: 13.0, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Related videos
                          FutureBuilder(
                            future: relatedVideosFuture,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final relatedVideos = snapshot.data!;
                                return ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: relatedVideos.length,
                                    itemBuilder: (context, index) {
                                      final relatedVideo = relatedVideos[index];
                                      return VideoCard(video: relatedVideo);
                                    });
                              } else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            },
                          )
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyVideoPlayer extends StatefulWidget {
  const MyVideoPlayer({
    super.key,
    required Video video,
  }) : _video = video;

  final Video _video;

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  static const videoPlayerRatio = 230.0;

  final VideoRepository videoRepository = VideoRepositoryImpl();

  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isShowAction = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget._video.videoUrl!));
    _initializeVideoPlayerFuture = _videoController.initialize();
    _videoController.play();
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) => snapshot.connectionState == ConnectionState.done
          ? AspectRatio(
              aspectRatio: MediaQuery.of(context).size.width / videoPlayerRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  VideoPlayer(_videoController),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isShowAction = !_isShowAction;
                      });
                    },
                    child: _isShowAction
                        ? Container(
                            color: Colors.black.withAlpha(100),
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _videoController.value.isPlaying ? _videoController.pause() : _videoController.play();
                                  });
                                },
                                icon: Icon(
                                  _videoController.value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  size: 64,
                                  color: Colors.white.withAlpha(220),
                                ),
                              ),
                            ),
                          )
                        : Container(color: Colors.black.withAlpha(0)),
                  ),
                  VideoSlider(videoController: _videoController),
                ],
              ),
            )
          : SizedBox(
              height: videoPlayerRatio,
              child: Container(color: Theme.of(context).colorScheme.outline),
            ),
    );
  }
}

class VideoSlider extends StatefulWidget {
  const VideoSlider({
    super.key,
    required VideoPlayerController videoController,
  }) : _videoController = videoController;

  final VideoPlayerController _videoController;

  @override
  State<VideoSlider> createState() => _VideoSliderState();
}

class _VideoSliderState extends State<VideoSlider> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 3,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          overlayShape: SliderComponentShape.noOverlay,
          trackHeight: 3,
          activeTrackColor: Colors.red,
          inactiveTrackColor: Colors.black26,
          thumbColor: Colors.red,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
          trackShape: const RectangularSliderTrackShape(),
        ),
        child: ValueListenableBuilder(
          valueListenable: widget._videoController,
          builder: (context, value, child) {
            return GestureDetector(
              onTap: () {},
              child: Slider(
                min: 0,
                max: value.duration.inMilliseconds.toDouble(),
                value: value.position.inMilliseconds.toDouble(),
                onChanged: (val) {},
                onChangeEnd: (value) => widget._videoController.seekTo(Duration(milliseconds: value.toInt())),
              ),
            );
          },
        ),
      ),
    );
  }
}
