import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_sharing_app/domain/entity/video.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyVideoPlayer(video: widget._video),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title, views, tags
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget._video.title,
                              maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8.0),
                          const Text('145K views  1y ago  For a Big  #funny', style: TextStyle(color: Colors.white70))
                        ],
                      ),
                    ),
                    // Channel, Subscribe button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                  backgroundImage: NetworkImage(widget._video.user.photoUrl.isNotEmpty
                                      ? widget._video.user.photoUrl
                                      : 'https://sm.ign.com/ign_nordic/cover/a/avatar-gen/avatar-generations_prsz.jpg')),
                              const SizedBox(width: 16.0),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Remix Music', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text('89K'),
                                ],
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                            child: const Text('Subscribe'),
                          )
                        ],
                      ),
                    ),
                    // Actions
                    const SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: Column(children: [
                              Icon(Icons.thumb_up_outlined, size: 30),
                              SizedBox(height: 8.0),
                              Text('7.7K'),
                            ]),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: Column(children: [
                              Icon(Icons.thumb_down_outlined, size: 30),
                              SizedBox(height: 8.0),
                              Text('128'),
                            ]),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: Column(children: [
                              Icon(Icons.comment_outlined, size: 30),
                              SizedBox(height: 8.0),
                              Text('8K'),
                            ]),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: Column(children: [
                              Icon(Icons.share_outlined, size: 30),
                              SizedBox(height: 8.0),
                              Text('Share'),
                            ]),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: Column(children: [
                              Icon(Icons.download_outlined, size: 30),
                              SizedBox(height: 8.0),
                              Text('Download'),
                            ]),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                            child: Column(children: [
                              Icon(Icons.save_outlined, size: 30),
                              SizedBox(height: 8.0),
                              Text('Saved'),
                            ]),
                          )
                        ],
                      ),
                    ),
                    // Comments
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white10,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(left: 16.0, top: 12.0, right: 16.0, bottom: 16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Comments', style: TextStyle(fontSize: 15)),
                                  SizedBox(width: 8.0),
                                  Text('8K', style: TextStyle(color: Colors.white70)),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage('https://sm.ign.com/ign_nordic/cover/a/avatar-gen/avatar-generations_prsz.jpg'),
                                    maxRadius: 12,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text('Nhạc hay quá! Rất xinh đẹp, tuyệt vời!')
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Builder(builder: (context) {
                      final video = widget._video;
                      return Column(
                        children: [
                          for (var i = 0; i < 10; i++)
                            GestureDetector(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerPage(video: video))),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(video.thumbnailUrl, fit: BoxFit.cover),
                                    ),
                                    const SizedBox(height: 16.0),
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                            backgroundImage:
                                                NetworkImage('https://sm.ign.com/ign_nordic/cover/a/avatar-gen/avatar-generations_prsz.jpg')),
                                        const SizedBox(width: 16.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(video.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16.0)),
                                              const Text('David  |  124K views  |  3 months ago', style: TextStyle(color: Colors.white70)),
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                        ],
                      );
                    }),
                  ],
                ),
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
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isShowAction = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget._video.videoUrl));
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
              aspectRatio: MediaQuery.of(context).size.width / 250,
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
                                icon: Icon(_videoController.value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 54),
                              ),
                            ),
                          )
                        : Container(color: Colors.black.withAlpha(0)),
                  ),
                  VideoSlider(videoController: _videoController),
                ],
              ),
            )
          : const SizedBox(height: 250, child: Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))),
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
      height: 10,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          overlayShape: SliderComponentShape.noOverlay,
          trackHeight: 10,
          activeTrackColor: Colors.white,
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
