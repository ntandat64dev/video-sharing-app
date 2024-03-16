import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final VideoRepository _videoRepository = VideoRepositoryImpl();
  late VideoPlayerController _videoPlayerController;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late final String? _videoPath;
  bool _uploadingLocalVideo = true;
  bool _processingVideo = false;

  @override
  void initState() {
    super.initState();
    _openFilePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _uploadingLocalVideo
          ? const Center()
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
                                cursorColor: Colors.white54,
                                decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: 'Title (required)',
                                  fillColor: Colors.white10,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: const BorderSide(color: Colors.white24),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: const BorderSide(color: Colors.white24),
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
                                cursorColor: Colors.white54,
                                decoration: InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelText: 'Description',
                                  fillColor: Colors.white10,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: const BorderSide(color: Colors.white24),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: const BorderSide(color: Colors.white24),
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
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
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

  void _openFilePicker() async {
    var results = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );
    if (results != null && results.count > 0) {
      var videoPath = results.paths.first;
      if (videoPath == null) return;
      _videoPlayerController = VideoPlayerController.file(File(videoPath))
        ..initialize().then((value) => setState(() {
              _videoPath = videoPath;
              _uploadingLocalVideo = false;
            }));
    }
  }

  void _uploadVideo() async {
    setState(() => _processingVideo = true);
    if (_videoPath == null) return;
    bool result = await _videoRepository.upload(
      videoPath: _videoPath,
      title: _titleController.text,
      description: _descriptionController.text,
    );
    if (result == true) {
      setState(() => Navigator.pop(context));
    }
  }
}
