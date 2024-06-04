import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_trimmer/video_trimmer.dart';

class MyVideoViewer extends StatefulWidget {
  const MyVideoViewer({
    super.key,
    required this.trimmer,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(0.0),
  });

  final Trimmer trimmer;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsets padding;

  @override
  State<MyVideoViewer> createState() => _MyVideoViewerState();
}

class _MyVideoViewerState extends State<MyVideoViewer> {
  VideoPlayerController? get videoPlayerController => widget.trimmer.videoPlayerController;

  @override
  void initState() {
    widget.trimmer.eventStream.listen((event) {
      if (event == TrimmerEvent.initialized) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = videoPlayerController;
    return controller == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(0.0),
            child: Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: controller.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                        child: Container(
                          foregroundDecoration: BoxDecoration(
                            border: Border.all(
                              width: widget.borderWidth,
                              color: widget.borderColor,
                            ),
                          ),
                          child: VideoPlayer(controller),
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                      ),
              ),
            ),
          );
  }

  @override
  void dispose() {
    widget.trimmer.dispose();
    super.dispose();
  }
}
