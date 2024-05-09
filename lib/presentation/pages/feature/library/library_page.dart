import 'package:flutter/material.dart';
import 'package:video_sharing_app/presentation/components/sink_animated.dart';
import 'package:video_sharing_app/presentation/pages/feature/library/your_videos_page.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Icon(Icons.videocam, size: 32.0, color: Theme.of(context).colorScheme.primary),
            titleSpacing: 0.0,
            title: const Text('Library'),
            floating: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Badge(
                  label: Text('2'),
                  child: Icon(Icons.notifications_rounded),
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            ],
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // View history
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('History', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                        Text('View All', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 180.0,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(width: 12.0),
                      itemCount: 5,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return SinkAnimated(
                          onTap: () {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Image.asset(
                                  Asset.placeholder,
                                  fit: BoxFit.cover,
                                  height: 110,
                                  width: 150,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Watch later',
                                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500)),
                                      Text('Private')
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(
                    height: 32.0,
                    thickness: 0.5,
                    indent: 16.0,
                    endIndent: 16.0,
                    color: Theme.of(context).colorScheme.outline.withAlpha(80),
                  ),
                  // Your videos
                  InkWell(
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const YourVideosPage())),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context).colorScheme.primary.withAlpha(100),
                          ),
                          child: Icon(Icons.play_circle, color: Theme.of(context).colorScheme.primary),
                        ),
                        title: const Text(
                          'Your videos',
                          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  // Downloads
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context).colorScheme.primary.withAlpha(100),
                          ),
                          child: Icon(Icons.download, color: Theme.of(context).colorScheme.primary),
                        ),
                        title: const Text(
                          'Downloads',
                          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 32.0,
                    thickness: 0.5,
                    indent: 16.0,
                    endIndent: 16.0,
                    color: Theme.of(context).colorScheme.outline.withAlpha(80),
                  ),
                  // Playlists
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Playlists', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                        Text('View All', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                  ),
                  // New playlist
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context).colorScheme.primary.withAlpha(100),
                          ),
                          child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                        ),
                        title: const Text(
                          'New Playlist',
                          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  // Watch later
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context).colorScheme.primary.withAlpha(100),
                          ),
                          child: Icon(Icons.access_time_filled, color: Theme.of(context).colorScheme.primary),
                        ),
                        title: const Text(
                          'Watch Later',
                          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text('23 videos'),
                      ),
                    ),
                  ),
                  // Liked videos
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Theme.of(context).colorScheme.primary.withAlpha(100),
                          ),
                          child: Icon(Icons.thumb_up, color: Theme.of(context).colorScheme.primary),
                        ),
                        title: const Text(
                          'Liked Videos',
                          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text('127 videos'),
                      ),
                    ),
                  ),
                  // My playlists
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.asset(
                            Asset.illustration4,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: const Text(
                          'My Favorite Songs',
                          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text('56 videos'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
