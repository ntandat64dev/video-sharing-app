import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';
import 'package:video_sharing_app/data/repository_impl/comment_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/follow_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/user_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/user.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/entity/video_rating.dart';
import 'package:video_sharing_app/domain/repository/comment_repository.dart';
import 'package:video_sharing_app/domain/repository/follow_repository.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/pages/feature/home/components/comment_item.dart';
import 'package:video_sharing_app/presentation/components/video_card.dart';
import 'package:video_sharing_app/presentation/pages/feature/home/provider/video_detail_provider.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key, required Video video}) : _video = video;

  final Video _video;

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  final VideoRepository videoRepository = VideoRepositoryImpl();
  final GlobalKey globalKey = GlobalKey();

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
              key: globalKey,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Video details
                      VideoDetail(
                        globalKey: globalKey,
                        video: widget._video,
                      ),
                      // Related videos
                      FutureBuilder(
                        future: videoRepository.getRelatedVideos(widget._video.id!),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return const SizedBox.shrink();
                          final relatedVideos = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: relatedVideos.length,
                            itemBuilder: (context, index) {
                              final relatedVideo = relatedVideos[index];
                              return VideoCard(video: relatedVideo);
                            },
                          );
                        },
                      )
                    ],
                  ),
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
  const VideoDetail({
    super.key,
    required GlobalKey globalKey,
    required Video video,
  })  : _video = video,
        _globalKey = globalKey;

  final GlobalKey _globalKey;
  final Video _video;

  @override
  State<VideoDetail> createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  final UserRepository userRepository = UserRepositoryImpl();
  final VideoRepository videoRepository = VideoRepositoryImpl();
  final CommentRepository commentRepository = CommentRepositoryImpl();

  final commentController = TextEditingController();
  var isCommentFocus = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VideoDetailProvider(widget._video),
      builder: (context, child) {
        return Consumer<VideoDetailProvider>(
          builder: (context, provider, child) {
            if (!provider.isDetailLoaded) return const SizedBox.shrink();

            final video = provider.video;
            final videoRating = provider.videoRating;
            final follow = provider.follow;
            final user = provider.user;

            return Column(
              children: [
                // Title, views, tags
                InkWell(
                  onTap: () {
                    // Show video description
                    showModalBottomSheet<void>(
                      isScrollControlled: true,
                      context: context,
                      constraints: const BoxConstraints(maxWidth: double.infinity),
                      builder: (context) => VideoDescription(
                        videoDetailProvider: provider,
                        video: video,
                        globalKey: widget._globalKey,
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
                        onPressed: () => provider.rateVideo(Rating.like),
                        icon: Icon(
                          Icons.thumb_up,
                          color: videoRating.rating == Rating.like ? Colors.red : Theme.of(context).colorScheme.primary,
                        ),
                        label: Text(
                          video.likeCount.toString(),
                          style: TextStyle(
                            color:
                                videoRating.rating == Rating.like ? Colors.red : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton.icon(
                        onPressed: () => provider.rateVideo(Rating.dislike),
                        icon: Icon(
                          Icons.thumb_down,
                          color:
                              videoRating.rating == Rating.dislike ? Colors.red : Theme.of(context).colorScheme.primary,
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
                // Channel, Follow button
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
                                backgroundImage: NetworkImage(video.userImageUrl!),
                                radius: 28.0,
                              ),
                              const SizedBox(width: 12.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    video.username!,
                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    '${user.followerCount} followers',
                                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => provider.followUser(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            ),
                            child: Text(follow != null ? 'Followed' : 'Follow'),
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
                        globalKey: widget._globalKey,
                        sendComment: provider.sendComment,
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
                // Add comment
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(video.userImageUrl!),
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
                                  await provider.sendComment(commentController.text);
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
              ],
            );
          },
        );
      },
    );
  }
}

class VideoDescription extends StatefulWidget {
  const VideoDescription({
    super.key,
    required Video video,
    required GlobalKey globalKey,
    required VideoDetailProvider videoDetailProvider,
  })  : _videoDetailProvider = videoDetailProvider,
        _globalKey = globalKey,
        _video = video;

  final VideoDetailProvider _videoDetailProvider;
  final Video _video;
  final GlobalKey _globalKey;

  @override
  State<VideoDescription> createState() => _VideoDescriptionState();
}

class _VideoDescriptionState extends State<VideoDescription> {
  final VideoRepository videoRepository = VideoRepositoryImpl();
  final UserRepository userRepository = UserRepositoryImpl();
  final FollowRepository followRepository = FollowRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    final video = widget._video;

    // Calculate modal height
    RenderBox box = widget._globalKey.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    final modelHeight = MediaQuery.of(context).size.height - position.dy;

    return FutureBuilder(
      future: Future.wait([
        followRepository.getFollowFor(video.userId!),
        userRepository.getUserInfo(userId: video.userId!),
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.length == 2) {
          final follow = snapshot.data![0] as Follow?;
          final user = snapshot.data![1] as User;
          return ListenableProvider.value(
            value: widget._videoDetailProvider,
            builder: (context, child) {
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
                          // Title
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              video.title!,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                          // Statistic
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      video.likeCount.toString(),
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
                                      video.dislikeCount.toString(),
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
                                      video.viewCount.toString(),
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
                                      DateFormat.MMMd().format(video.publishedAt!),
                                      style: const TextStyle(
                                        fontSize: 28.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(video.publishedAt!.year.toString()),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Hashtags
                          SizedBox(
                            height: video.hashtags!.isNotEmpty ? 48 : 0,
                            child: ListView.separated(
                              separatorBuilder: (context, index) => const SizedBox(width: 8.0),
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              scrollDirection: Axis.horizontal,
                              itemCount: video.hashtags!.length,
                              itemBuilder: (context, index) {
                                final tag = video.hashtags![index];
                                return Text(
                                  '#${tag.replaceAll(' ', '').toLowerCase()}',
                                  style: TextStyle(color: Colors.blue.shade800),
                                );
                              },
                            ),
                          ),
                          // Description (if any)
                          video.description != null
                              ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(video.description!),
                                )
                              : const SizedBox.shrink(),
                          // Channel info
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
                                          backgroundImage: NetworkImage(video.userImageUrl!),
                                          radius: 28.0,
                                        ),
                                        const SizedBox(width: 12.0),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              video.username!,
                                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4.0),
                                            Text(
                                              '${user.followerCount} followers',
                                              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await widget._videoDetailProvider.followUser();
                                        setState(() {});
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                      child: Text(follow != null ? 'Followed' : 'Follow'),
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
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class CommentDetail extends StatefulWidget {
  const CommentDetail({
    super.key,
    required Video video,
    required GlobalKey globalKey,
    required Future<void> Function(String) sendComment,
  })  : _sendComment = sendComment,
        _globalKey = globalKey,
        _video = video;

  final Video _video;
  final GlobalKey _globalKey;
  final Future<void> Function(String) _sendComment;

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
    // Calculate modal height
    RenderBox box = widget._globalKey.currentContext?.findRenderObject() as RenderBox;
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
                backgroundImage: NetworkImage(widget._video.userImageUrl!),
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
                              await widget._sendComment(commentController.text);
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
            const SizedBox(height: 16.0),
            Divider(
              height: 1.0,
              thickness: 0.3,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            Expanded(
              child: FutureBuilder(
                future: commentRepository.getCommentsByVideoId(widget._video.id!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return DraggableScrollableSheet(
                        initialChildSize: 1,
                        builder: (context, scrollController) {
                          final comments = snapshot.data!;
                          // Temporary sort by newest.
                          comments.sort((a, b) => a.publishedAt!.isBefore(b.publishedAt!) ? 1 : -1);
                          return ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) => CommentItem(comment: comments[index]),
                          );
                        },
                      );
                    } else {
                      return const Column(
                        children: [
                          SizedBox(height: 64.0),
                          Text(
                            'No comments yet',
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 8.0),
                          Text('Say something to start the conversation'),
                        ],
                      );
                    }
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

const videoPlayerRatio = 230.0;

class _MyVideoPlayerState extends State<MyVideoPlayer> {
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
              child: CachedNetworkImage(
                imageUrl: widget._video.thumbnails![Thumbnail.kDefault]!.url,
                fadeInDuration: const Duration(milliseconds: 300),
                fadeOutDuration: const Duration(milliseconds: 1),
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Image.asset(
                  Asset.placeholder,
                  height: videoPlayerRatio,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
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
