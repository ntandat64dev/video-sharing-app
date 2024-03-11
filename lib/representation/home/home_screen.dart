import 'package:flutter/material.dart';
import 'package:video_sharing_app/data/video_repository.dart';
import 'package:video_sharing_app/domain/video.dart';
import 'package:video_sharing_app/representation/home/video_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final VideoRepository videoRepository = VideoRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Video>>(
      future: videoRepository.getVideos(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final video = snapshot.data![index];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => VideoDetail(video: video))),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: FadeInImage.assetNetwork(
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: 'assets/gifs/placeholder.gif',
                              image: video.thumbnail),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                                backgroundImage: NetworkImage('https://sm.ign.com/ign_nordic/cover/a/avatar-gen/avatar-generations_prsz.jpg')),
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
              });
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
