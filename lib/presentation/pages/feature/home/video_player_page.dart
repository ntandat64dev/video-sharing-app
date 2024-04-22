import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';
import 'package:video_sharing_app/data/repository_impl/comment_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';
import 'package:video_sharing_app/domain/repository/comment_repository.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/pages/feature/home/components/comment_item.dart';
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
  final CommentRepository commentRepository = CommentRepositoryImpl();

  late Future<Video?> videoDetailFuture;
  late Future<VideoRating> videoRatingFuture;
  late Future<List<Video>> relatedVideosFuture;

  final commentController = TextEditingController();
  var isCommentFocus = false;
  final GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    relatedVideosFuture = videoRepository.getRelatedVideos(videoId: widget._video.id!);
  }

  @override
  Widget build(BuildContext context) {
    // When user do action rating, comment, etc. the call setState reloading future.
    videoDetailFuture = videoRepository.getVideoById(videoId: widget._video.id!);
    videoRatingFuture = videoRepository.getVideoRating(videoId: widget._video.id!);

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
              key: globalKey,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: FutureBuilder(
                  future: Future.wait([videoDetailFuture, videoRatingFuture]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null && snapshot.data!.length == 2) {
                      final video = snapshot.data![0] as Video;
                      final videoRating = snapshot.data![1] as VideoRating;
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title, views, tags
                            InkWell(
                              onTap: () {
                                // Show video details
                                showModalBottomSheet<void>(
                                  isScrollControlled: true,
                                  context: context,
                                  constraints: const BoxConstraints(maxWidth: double.infinity),
                                  builder: (context) => VideoDetail(
                                    video: widget._video,
                                    globalKey: globalKey,
                                  ),
                                );
                              },
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        video.title!,
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
                                        '${video.viewCount} views  ${timeago.format(video.publishedAt!)}  ${video.hashtags?.map((e) => '#${e.toLowerCase().replaceAll(' ', '')}').join(' ')}',
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        softWrap: false,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Actions
                            SingleChildScrollView(
                              padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final rating = videoRating.rating == Rating.like ? Rating.none : Rating.like;
                                      final result =
                                          await videoRepository.rateVideo(videoId: video.id!, rating: rating);
                                      if (result) setState(() => {});
                                    },
                                    icon: Icon(
                                      Icons.thumb_up,
                                      color: videoRating.rating == Rating.like
                                          ? Colors.red
                                          : Theme.of(context).colorScheme.primary,
                                    ),
                                    label: Text(
                                      video.likeCount.toString(),
                                      style: TextStyle(
                                        color: videoRating.rating == Rating.like
                                            ? Colors.red
                                            : Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final rating =
                                          videoRating.rating == Rating.dislike ? Rating.none : Rating.dislike;
                                      final result =
                                          await videoRepository.rateVideo(videoId: video.id!, rating: rating);
                                      if (result) setState(() => {});
                                    },
                                    icon: Icon(
                                      Icons.thumb_down,
                                      color: videoRating.rating == Rating.dislike
                                          ? Colors.red
                                          : Theme.of(context).colorScheme.primary,
                                    ),
                                    label: Text(
                                      video.dislikeCount.toString(),
                                      style: TextStyle(
                                        color: videoRating.rating == Rating.dislike
                                            ? Colors.red
                                            : Theme.of(context).colorScheme.primary,
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
                            Divider(
                              height: 1.0,
                              thickness: 0.6,
                              indent: 16.0,
                              endIndent: 16.0,
                              color: Theme.of(context).colorScheme.outlineVariant,
                            ),
                            // Channel, Subscribe button
                            InkWell(
                              onTap: () {},
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(video.channelImageUrl!),
                                            radius: 28.0,
                                          ),
                                          const SizedBox(width: 12.0),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                video.channelTitle!,
                                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(height: 4.0),
                                              Text(
                                                '86K subscribers',
                                                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                              ),
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
                            Divider(
                              height: 1.0,
                              thickness: 0.3,
                              indent: 16.0,
                              endIndent: 16.0,
                              color: Theme.of(context).colorScheme.outlineVariant,
                            ),
                            // Comments
                            InkWell(
                              onTap: () async {
                                // Show comments
                                if (!context.mounted) return;
                                showModalBottomSheet<void>(
                                  isScrollControlled: true,
                                  context: context,
                                  constraints: const BoxConstraints(maxWidth: double.infinity),
                                  builder: (context) => CommentDetail(
                                    video: video,
                                    globalKey: globalKey,
                                    onSentComment: () => setState(() => {}),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Comments ${video.commentCount}',
                                      style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                                    ),
                                    const Icon(Icons.arrow_downward),
                                  ],
                                ),
                              ),
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(video.channelImageUrl!),
                                radius: 24.0,
                              ),
                              title: Focus(
                                onFocusChange: (value) {
                                  setState(() {
                                    isCommentFocus = value;
                                  });
                                },
                                child: TextField(
                                  controller: commentController,
                                  cursorColor: Theme.of(context).colorScheme.primary,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    labelText: 'Add a comment...',
                                    fillColor: Theme.of(context).colorScheme.onInverseSurface,
                                    filled: true,
                                    suffixIcon: isCommentFocus
                                        ? IconButton(
                                            onPressed: () async {
                                              // Sent comment
                                              final comment = Comment.post(
                                                videoId: video.id!,
                                                authorId: null,
                                                text: commentController.text,
                                              );
                                              await commentRepository.postComment(comment: comment);
                                              setState(() {
                                                FocusScope.of(context).requestFocus(FocusNode());
                                                commentController.text = '';
                                              });
                                            },
                                            icon: const Icon(Icons.send),
                                            color: Theme.of(context).colorScheme.primary)
                                        : const Icon(null),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(48.0),
                                      borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.outline.withAlpha(30),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(48.0),
                                      borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.outline.withAlpha(30),
                                      ),
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
              ),
            )
          ],
        ),
      ),
    );
  }
}

class VideoDetail extends StatefulWidget {
  const VideoDetail({super.key, required this.video, required this.globalKey});

  final Video video;
  final GlobalKey globalKey;

  @override
  State<VideoDetail> createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  @override
  Widget build(BuildContext context) {
    RenderBox box = widget.globalKey.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    final modelHeight = MediaQuery.of(context).size.height - position.dy;
    return Container(
      height: modelHeight,
      width: double.infinity,
      color: Theme.of(context).colorScheme.surface,
      child: Column(children: [
        const SizedBox(height: 6.0),
        Container(
          width: 50.0,
          height: 6.0,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        const SizedBox(height: 16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Descriptions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        Divider(
          height: 1.0,
          thickness: 0.3,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
        SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.video.title!,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            widget.video.likeCount.toString(),
                            style: const TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text('Likes'),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            widget.video.dislikeCount.toString(),
                            style: const TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text('Dislikes'),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            widget.video.viewCount.toString(),
                            style: const TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text('Views'),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            DateFormat.MMMd().format(widget.video.publishedAt!),
                            style: const TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(widget.video.publishedAt!.year.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: widget.video.hashtags!.isNotEmpty ? 48 : 0,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(width: 8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.video.hashtags!.length,
                    itemBuilder: (context, index) {
                      final tag = widget.video.hashtags![index];
                      return Text(
                        '#${tag.replaceAll(' ', '').toLowerCase()}',
                        style: TextStyle(color: Colors.blue.shade800),
                      );
                    },
                  ),
                ),
                widget.video.description != null
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(widget.video.description!),
                      )
                    : const SizedBox.shrink(),
                InkWell(
                  onTap: () {},
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(widget.video.channelImageUrl!),
                                radius: 28.0,
                              ),
                              const SizedBox(width: 12.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.video.channelTitle!,
                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    '86K subscribers',
                                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                  ),
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
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class CommentDetail extends StatefulWidget {
  const CommentDetail({super.key, required this.video, required this.globalKey, required this.onSentComment});

  final Video video;
  final GlobalKey globalKey;
  final VoidCallback onSentComment;

  @override
  State<CommentDetail> createState() => _CommentDetailState();
}

class _CommentDetailState extends State<CommentDetail> {
  final commentRepository = CommentRepositoryImpl();
  final commentController = TextEditingController();
  var isCommentFocus = false;

  late Future<List<Comment>> commentsFuture;

  @override
  Widget build(BuildContext context) {
    commentsFuture = commentRepository.getCommentsByVideoId(videoId: widget.video.id!);

    // Calculate modal height
    RenderBox box = widget.globalKey.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    final modelHeight = MediaQuery.of(context).size.height - position.dy;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Container(
        height: modelHeight,
        width: double.infinity,
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            const SizedBox(height: 6.0),
            Container(
              width: 50.0,
              height: 6.0,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Comments',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(onPressed: () {}, child: const Text('Top')),
                    const SizedBox(width: 8.0),
                    ElevatedButton(onPressed: () {}, child: const Text('Newest')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.video.channelImageUrl!),
                radius: 24.0,
              ),
              title: Focus(
                onFocusChange: (value) {
                  setState(() {
                    isCommentFocus = value;
                  });
                },
                child: TextField(
                  controller: commentController,
                  cursorColor: Theme.of(context).colorScheme.primary,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: 'Add a comment...',
                    fillColor: Theme.of(context).colorScheme.onInverseSurface,
                    filled: true,
                    suffixIcon: isCommentFocus
                        ? IconButton(
                            onPressed: () async {
                              // Sent comment
                              final comment = Comment.post(
                                videoId: widget.video.id!,
                                authorId: null,
                                text: commentController.text,
                              );
                              await commentRepository.postComment(comment: comment);
                              setState(() {
                                FocusScope.of(context).requestFocus(FocusNode());
                                commentController.text = '';
                              });
                              widget.onSentComment.call();
                            },
                            icon: const Icon(Icons.send),
                            color: Theme.of(context).colorScheme.primary)
                        : const Icon(null),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(48.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline.withAlpha(30),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(48.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.outline.withAlpha(30),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Divider(
              height: 1.0,
              thickness: 0.3,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            Expanded(
              child: FutureBuilder(
                future: commentsFuture,
                builder: (context, snapshot) {
                  return !(snapshot.hasData && snapshot.data!.isNotEmpty)
                      ? const Center(child: CircularProgressIndicator())
                      : DraggableScrollableSheet(
                          initialChildSize: 1,
                          builder: (context, scrollController) {
                            final comments = snapshot.data!;
                            // Temporary sort by newest.
                            comments.sort((a, b) => a.publishedAt!.isBefore(b.publishedAt!) ? 1 : -1);
                            return ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                return CommentItem(comment: comments[index]);
                              },
                            );
                          },
                        );
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
                                    _videoController.value.isPlaying
                                        ? _videoController.pause()
                                        : _videoController.play();
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
