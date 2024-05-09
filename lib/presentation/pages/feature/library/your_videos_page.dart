import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/components/app_bar_back_button.dart';
import 'package:video_sharing_app/presentation/components/filter_item.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/set_privacy_page.dart';

class YourVideosPage extends StatefulWidget {
  const YourVideosPage({super.key});

  @override
  State<YourVideosPage> createState() => _YourVideosPageState();
}

class _YourVideosPageState extends State<YourVideosPage> {
  final VideoRepository videoRepository = VideoRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: appBarBackButton(context),
          title: const Text('Your videos'),
        ),
        body: Column(
          children: [
            // Filters
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(6.0),
                        child: Ink(
                          height: 36.0,
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: const Center(child: Icon(Icons.filter_list)),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      FilterItem(onSelected: (value) {}, text: 'Videos', isActive: true),
                      const SizedBox(width: 10.0),
                      FilterItem(onSelected: (value) {}, text: 'Shorts'),
                      const SizedBox(width: 10.0),
                      FilterItem(onSelected: (value) {}, text: 'Live'),
                    ],
                  ),
                ),
              ),
            ),
            // Your videos
            Expanded(
              child: FutureBuilder(
                future: videoRepository.getMyVideos(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  var videos = snapshot.data!;
                  return ListView.builder(
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      return VideoItem(video: videos[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoItem extends StatelessWidget {
  const VideoItem({super.key, required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                video.thumbnails![Thumbnail.kDefault]!.url,
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title!,
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text('${video.viewCount} views  ∙  ${timeago.format(video.publishedAt!)}'),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Icon(
                    video.privacy!.toLowerCase() == Privacy.private.name ? Icons.lock_rounded : Icons.public,
                    size: 16.0,
                  )
                ],
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
          ],
        ),
      ),
    );
  }
}
