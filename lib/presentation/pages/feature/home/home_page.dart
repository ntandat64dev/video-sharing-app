import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/pages/feature/home/components/video_card.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/video_editor.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final VideoRepository videoRepository = VideoRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<Video>>(
        future: videoRepository.getVideosByCategoryAll(),
        builder: (conatext, snapshot) {
          if (snapshot.hasData) {
            final videos = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: Icon(Icons.videocam, color: Theme.of(context).colorScheme.primary),
                  title: const Text('MeTube'),
                  actions: [
                    IconButton(onPressed: () => onUploadClicked(context), icon: const Icon(Icons.add)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: SizedBox(
                      height: kToolbarHeight - 8.0,
                      child: Column(
                        children: [
                          Expanded(
                            child: FutureBuilder(
                              future: videoRepository.getVideoCategories(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final hashtags = snapshot.data!;
                                  return ListView.separated(
                                    separatorBuilder: (context, index) => const SizedBox(width: 4.0),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: hashtags.length + 1,
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                    itemBuilder: (context, index) => ElevatedButton(
                                      onPressed: () {},
                                      child: index == 0 ? const Text('All') : Text(hashtags[index - 1]),
                                    ),
                                  );
                                } else {
                                  return const Center(child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverList.builder(
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    return VideoCard(video: video);
                  },
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void onUploadClicked(context) async {
    var results = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );
    if (results != null && results.count > 0) {
      var videoPath = results.paths.single;
      if (videoPath == null) return;
      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => VideoEditor(videoPath: videoPath)));
      }
    }
  }
}
