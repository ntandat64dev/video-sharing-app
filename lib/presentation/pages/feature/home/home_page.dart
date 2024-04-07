import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_sharing_app/data/repository_impl/user_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/pages/feature/home/video_player_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/upload_page.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserRepository userRepository = UserRepositoryImpl();
  final VideoRepository videoRepository = VideoRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<Video>>(
        future: videoRepository.getVideos(userRepository.getLoggedUser()!.id),
        builder: (conatext, snapshot) {
          if (snapshot.hasData) {
            final videos = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: const Icon(Icons.videocam),
                  title: const Text('MeTube', style: TextStyle(fontWeight: FontWeight.w500)),
                  titleSpacing: 0.0,
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
                              future: userRepository.getHasgtags(),
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
                    return InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerPage(video: video))),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: FadeInImage.assetNetwork(
                                  fadeInDuration: const Duration(milliseconds: 300),
                                  fadeOutDuration: const Duration(milliseconds: 1),
                                  height: 220,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: Asset.placeholder,
                                  image: video.thumbnailUrl),
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(backgroundImage: NetworkImage(video.channel.pictureUrl)),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              video.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        '${video.channel.name}  ∙  ${video.viewCount} views  ∙  ${timeago.format(video.uploadDate)}',
                                        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
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
      var videoPath = results.paths.first;
      if (videoPath == null) return;
      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPage(videoPath: videoPath)));
      }
    }
  }
}
