import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/presentation/components/app_bar_back_button.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/my_video_viewer.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/upload_page.dart';
import 'package:video_sharing_app/presentation/theme/dark_theme.dart';
import 'package:video_sharing_app/presentation/theme/theme_provider.dart';
import 'package:video_trimmer/video_trimmer.dart';

class VideoEditor extends StatefulWidget {
  const VideoEditor({
    super.key,
    required this.videoPath,
    required this.previousTheme,
  });

  final String videoPath;
  final ThemeMode previousTheme;

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
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: colorBackground,
        leading: appBarBackButton(context),
        title: Text(AppLocalizations.of(context)!.editVideoAppBarTitle),
        actions: [
          IconButton(
            onPressed: () async {
              await trimmer.saveTrimmedVideo(
                startValue: startValue,
                endValue: endValue,
                onSave: (outputPath) async {
                  if (outputPath != null && context.mounted) {
                    Provider.of<ThemeProvider>(context, listen: false).themeMode = widget.previousTheme;
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadPage(videoPath: outputPath),
                      ),
                    );
                    if (context.mounted) {
                      Provider.of<ThemeProvider>(context, listen: false).themeMode = ThemeMode.dark;
                    }
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: MyVideoViewer(trimmer: trimmer),
            ),
          ),
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: TrimViewer(
                showDuration: true,
                editorProperties: const TrimEditorProperties(
                  scrubberWidth: 8.0,
                  sideTapSize: 32,
                ),
                durationTextStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                trimmer: trimmer,
                viewerHeight: 60.0,
                viewerWidth: MediaQuery.of(context).size.width,
                onChangeStart: (value) => startValue = value,
                onChangeEnd: (value) => endValue = value,
                onChangePlaybackState: (value) => setState(() => isPlaying = value),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              icon: isPlaying
                  ? Icon(Icons.pause_rounded, size: 80.0, color: Theme.of(context).colorScheme.onBackground)
                  : Icon(Icons.play_arrow_rounded, size: 80.0, color: Theme.of(context).colorScheme.onBackground),
              onPressed: () async {
                bool playbackState = await trimmer.videoPlaybackControl(
                  startValue: startValue,
                  endValue: endValue,
                );
                setState(() => isPlaying = playbackState);
              },
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
