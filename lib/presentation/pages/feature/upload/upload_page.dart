import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key, required this.videoPath});

  final String videoPath;

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final VideoRepository _videoRepository = VideoRepositoryImpl();
  late VideoPlayerController _videoPlayerController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _initVideoPlayer = true;
  bool _processingVideo = false;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((value) => setState(() => _initVideoPlayer = false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('Add Details', style: TextStyle(fontWeight: FontWeight.w500)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: _initVideoPlayer
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            AspectRatio(
                              aspectRatio: MediaQuery.of(context).size.width / 250,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: VideoPlayer(_videoPlayerController),
                                ),
                              ),
                            ),
                            const ListTile(
                              leading: CircleAvatar(
                                  backgroundImage: NetworkImage('https://sm.ign.com/ign_nordic/cover/a/avatar-gen/avatar-generations_prsz.jpg')),
                              title: Text('Publisher'),
                            ),
                            const SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                controller: _titleController,
                                cursorColor: Theme.of(context).colorScheme.primary,
                                decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: 'Title (required)',
                                  fillColor: Theme.of(context).colorScheme.onInverseSurface,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                controller: _descriptionController,
                                minLines: 4,
                                maxLines: 5,
                                cursorColor: Theme.of(context).colorScheme.primary,
                                decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: 'Description',
                                  fillColor: Theme.of(context).colorScheme.onInverseSurface,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _processingVideo
                                ? const Center(child: CircularProgressIndicator())
                                : ElevatedButton(
                                    onPressed: _uploadVideo,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                      padding: const EdgeInsets.all(14.0),
                                    ),
                                    child: const Text('Upload video'),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _uploadVideo() async {
    setState(() => _processingVideo = true);
    await _videoRepository.uploadVideo(
      videoPath: widget.videoPath,
      title: _titleController.text,
      description: _descriptionController.text,
    );
    setState(() => Navigator.pop(context));
  }
}
