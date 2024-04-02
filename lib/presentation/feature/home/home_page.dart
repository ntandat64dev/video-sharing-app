import 'package:flutter/material.dart';
import 'package:video_sharing_app/data/repository_impl/user_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/feature/home/video_player_page.dart';
import 'package:video_sharing_app/presentation/feature/upload/upload_page.dart';
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
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  leading: const Icon(Icons.videocam),
                  title: const Text('MeTube'),
                  titleSpacing: 0.0,
                  actions: [
                    IconButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UploadPage())),
                      icon: const Icon(Icons.add),
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: SizedBox(
                      height: kToolbarHeight - 16,
                      child: Column(
                        children: [
                          Expanded(
                            child: FutureBuilder(
                              future: userRepository.getHasgtags(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.separated(
                                    separatorBuilder: (context, index) => const SizedBox(width: 4.0),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data!.length + 1,
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    itemBuilder: (context, index) => ElevatedButton(
                                      onPressed: () {},
                                      child: index == 0 ? const Text('All') : Text(snapshot.data![index - 1]),
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
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final video = snapshot.data![index];
                    return GestureDetector(
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
                                  height: 250,
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
                                      Text(video.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16.0)),
                                      const Text('David  |  124K views  |  3 months ago', style: TextStyle(color: Colors.white70)),
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
}
