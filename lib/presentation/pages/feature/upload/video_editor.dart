import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/upload_page.dart';
import 'package:video_trimmer/video_trimmer.dart';

class VideoEditor extends StatefulWidget {
  const VideoEditor({super.key, required this.videoPath});

  final String videoPath;

  @override
  State<VideoEditor> createState() => _VideoEditorState();
}

class _VideoEditorState extends State<VideoEditor> {
  final Trimmer trimmer = Trimmer();

  double startValue = 0.0;
  double endValue = 0.0;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    trimmer.loadVideo(videoFile: File(widget.videoPath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Edit Video',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await trimmer.saveTrimmedVideo(
                startValue: startValue,
                endValue: endValue,
                onSave: (outputPath) {
                  if (outputPath != null && context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadPage(videoPath: outputPath)),
                    );
                  }
                },
              );
            },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(child: VideoViewer(trimmer: trimmer)),
          Center(
            child: TrimViewer(
              trimmer: trimmer,
              viewerHeight: 50.0,
              viewerWidth: MediaQuery.of(context).size.width,
              onChangeStart: (value) => startValue = value,
              onChangeEnd: (value) => endValue = value,
              onChangePlaybackState: (value) => setState(() => isPlaying = value),
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              icon: isPlaying
                  ? const Icon(Icons.pause, size: 80.0, color: Colors.white)
                  : const Icon(Icons.play_arrow, size: 80.0, color: Colors.white),
              onPressed: () async {
                bool playbackState = await trimmer.videoPlaybackControl(
                  startValue: startValue,
                  endValue: endValue,
                );
                setState(() => isPlaying = playbackState);
              },
            ),
          )
        ],
      ),
    );
  }
}
