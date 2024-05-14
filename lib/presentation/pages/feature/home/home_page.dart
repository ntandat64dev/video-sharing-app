import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/components/filter_item.dart';
import 'package:video_sharing_app/presentation/components/video_card.dart';
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
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final videos = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                leading: Icon(Icons.videocam, size: 32.0, color: Theme.of(context).colorScheme.primary),
                titleSpacing: 0.0,
                title: const Text('MeTube'),
                actions: [
                  IconButton(onPressed: () => onUploadClicked(context), icon: const Icon(Icons.add)),
                  IconButton(
                    onPressed: () {},
                    icon: const Badge(
                      label: Text('2'),
                      child: Icon(Icons.notifications_rounded),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: SizedBox(
                    height: kToolbarHeight,
                    child: Column(
                      children: [
                        Expanded(
                          child: FutureBuilder(
                            future: videoRepository.getVideoCategories(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                              final hashtags = snapshot.data!;
                              return ListView.separated(
                                separatorBuilder: (context, index) => const SizedBox(width: 8.0),
                                scrollDirection: Axis.horizontal,
                                itemCount: hashtags.length + 1,
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                itemBuilder: (context, index) => FilterItem(
                                  onSelected: (value) {},
                                  text: index == 0 ? AppLocalizations.of(conatext)!.filterAll : hashtags[index - 1],
                                  isActive: index == 0,
                                ),
                              );
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
        },
      ),
    );
  }

  void onUploadClicked(context) async {
    final picker = ImagePicker();
    final file = await picker.pickVideo(source: ImageSource.gallery);
    if (file != null && mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => VideoEditor(videoPath: file.path)));
    }
  }
}
