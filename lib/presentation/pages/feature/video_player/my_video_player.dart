import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';
import 'package:video_sharing_app/presentation/shared/utils.dart';

const videoPlayerHeight = 200.0;

enum Mode { video, playlistItem }

class MyVideoPlayer extends StatefulWidget {
  const MyVideoPlayer({super.key, required this.video, this.onCompleted, this.refresh = false});

  final Video video;
  final void Function()? onCompleted;
  final bool refresh;

  @override
  State<MyVideoPlayer> createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  final videoRepository = getIt<VideoRepository>();

  VideoPlayerController? videoController;
  late Future<void> initializeVideoPlayerFuture;
  bool isShowAction = false;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    init();
    videoRepository.viewVideo(videoId: widget.video.id!);
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }

  void init() {
    videoController?.dispose();
    isShowAction = false;
    isCompleted = false;

    videoController = VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl!));
    initializeVideoPlayerFuture = videoController!.initialize();
    videoController!.play();

    videoController!.addListener(() {
      setState(() {});
      if (videoController!.value.isPlaying) {
        if (isCompleted) {
          isCompleted = false;
        }
      }
      if (videoController!.value.isCompleted) {
        if (!isCompleted) {
          widget.onCompleted?.call();
          isCompleted = true;
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant MyVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.refresh) {
      init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeVideoPlayerFuture,
      builder: (context, snapshot) => snapshot.connectionState == ConnectionState.done
          ? AspectRatio(
              aspectRatio: MediaQuery.of(context).size.width / videoPlayerHeight,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  VideoPlayer(videoController!),
                  GestureDetector(
                    onTap: () => setState(() => isShowAction = !isShowAction),
                    child: AnimatedOpacity(
                      duration: Durations.medium1,
                      opacity: isShowAction ? 1 : 0,
                      child: Container(
                        color: Colors.black.withAlpha(isShowAction ? 150 : 0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  actionButton(icon: CupertinoIcons.chevron_down),
                                  Row(
                                    children: [
                                      actionButton(icon: CupertinoIcons.stopwatch),
                                      actionButton(icon: Icons.cast_rounded),
                                      actionButton(icon: Icons.closed_caption_outlined, size: 22.0),
                                      actionButton(icon: CupertinoIcons.ellipsis_vertical),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  actionButton(icon: Icons.replay_10_rounded, size: 28.0),
                                  actionButton(icon: Icons.skip_previous_rounded, size: 28.0),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (isShowAction) {
                                          videoController!.value.isPlaying
                                              ? videoController!.pause()
                                              : videoController!.play();
                                        } else {
                                          setState(() => isShowAction = true);
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      videoController!.value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                      size: 54,
                                      color: Colors.white,
                                    ),
                                  ),
                                  actionButton(icon: Icons.skip_next_rounded, size: 28.0),
                                  actionButton(icon: Icons.forward_10_rounded, size: 28.0),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 8.0),
                              child: Column(
                                children: [
                                  VideoSlider(
                                    videoController: videoController!,
                                    enable: isShowAction,
                                  ),
                                  const SizedBox(height: 2.0),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0, right: 1.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${formatDuration(videoController!.value.position)} / ${formatDuration(videoController!.value.duration)}',
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: !isShowAction ? null : () {},
                                          child: const Icon(
                                            Icons.fullscreen_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  isShowAction ? const SizedBox.shrink() : UninteractSlider(videoController: videoController!),
                ],
              ),
            )
          : SizedBox(
              height: videoPlayerHeight,
              child: CachedNetworkImage(
                imageUrl: widget.video.thumbnails![Thumbnail.kDefault]!.url,
                fadeInDuration: const Duration(milliseconds: 300),
                fadeOutDuration: const Duration(milliseconds: 1),
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
    );
  }

  Widget actionButton({
    required IconData icon,
    double size = 20.0,
  }) =>
      Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: !isShowAction ? null : () {},
          child: InkWell(
            onTap: !isShowAction ? null : () {},
            borderRadius: BorderRadius.circular(100.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                size: size,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
}

class UninteractSlider extends StatelessWidget {
  const UninteractSlider({super.key, required this.videoController});

  final VideoPlayerController videoController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 3,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          overlayShape: SliderComponentShape.noOverlay,
          trackHeight: 3,
          activeTrackColor: Theme.of(context).colorScheme.primary,
          inactiveTrackColor: Colors.black26,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
          trackShape: const RectangularSliderTrackShape(),
        ),
        child: ValueListenableBuilder(
          valueListenable: videoController,
          builder: (context, value, child) {
            return GestureDetector(
              onTap: () {},
              child: Slider(
                min: 0,
                max: value.duration.inMilliseconds.toDouble(),
                value: value.position.inMilliseconds.toDouble(),
                onChanged: (val) {},
              ),
            );
          },
        ),
      ),
    );
  }
}

class VideoSlider extends StatelessWidget {
  const VideoSlider({super.key, required this.videoController, this.enable = true});

  final VideoPlayerController videoController;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          overlayShape: SliderComponentShape.noOverlay,
          trackHeight: 5,
          activeTrackColor: Theme.of(context).colorScheme.primary,
          inactiveTrackColor: Colors.grey.shade400,
          thumbColor: Colors.white,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
          trackShape: const RectangularSliderTrackShape(),
        ),
        child: ValueListenableBuilder(
          valueListenable: videoController,
          builder: (context, value, child) {
            return Slider(
              min: 0,
              max: value.duration.inMilliseconds.toDouble(),
              value: value.position.inMilliseconds.toDouble(),
              onChanged: enable ? (value) => videoController.seekTo(Duration(milliseconds: value.toInt())) : null,
              onChangeEnd: (value) => videoController.seekTo(Duration(milliseconds: value.toInt())),
            );
          },
        ),
      ),
    );
  }
}
