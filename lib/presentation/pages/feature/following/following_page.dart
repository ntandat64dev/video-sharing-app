import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_sharing_app/data/repository_impl/follow_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/follow_repository.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/components/filter_item.dart';
import 'package:video_sharing_app/presentation/components/sink_animated.dart';
import 'package:video_sharing_app/presentation/components/video_card.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  final VideoRepository videoRepository = VideoRepositoryImpl();
  final FollowRepository followRepository = FollowRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future: Future.wait([
          followRepository.getFollows(),
          videoRepository.getVideosByCategoryAll(),
        ]),
        builder: (context, snapshot) {
          if (!(snapshot.hasData && snapshot.data!.length == 2)) {
            return const Center(child: CircularProgressIndicator());
          }
          final follows = snapshot.data![0] as List<Follow>;
          final videos = snapshot.data![1] as List<Video>;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(AppLocalizations.of(context)!.following),
                floating: true,
                leading: Icon(Icons.videocam, size: 32.0, color: Theme.of(context).colorScheme.primary),
                titleSpacing: 0.0,
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
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(240),
                  child: Column(
                    children: [
                      // Followings
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.followings,
                              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            InkWell(
                              onTap: () {},
                              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                                child: Text(
                                  AppLocalizations.of(context)!.viewAll,
                                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 110.0,
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(width: 12.0),
                          itemCount: follows.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final follow = follows[index];
                            return SinkAnimated(
                                onTap: () {},
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(follow.userThumbnails![Thumbnail.kDefault]!.url),
                                      radius: 36.0,
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(follow.username!)
                                  ],
                                ));
                          },
                        ),
                      ),
                      // Filters
                      SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              children: [
                                FilterItem(
                                  onSelected: (value) {},
                                  text: AppLocalizations.of(context)!.filterAll,
                                  isActive: true,
                                ),
                                const SizedBox(width: 10.0),
                                FilterItem(
                                  onSelected: (value) {},
                                  text: AppLocalizations.of(context)!.filterToday,
                                ),
                                const SizedBox(width: 10.0),
                                FilterItem(
                                  onSelected: (value) {},
                                  text: AppLocalizations.of(context)!.filterVideos,
                                ),
                                const SizedBox(width: 10.0),
                                FilterItem(
                                  onSelected: (value) {},
                                  text: AppLocalizations.of(context)!.filterShorts,
                                ),
                                const SizedBox(width: 10.0),
                                FilterItem(
                                  onSelected: (value) {},
                                  text: AppLocalizations.of(context)!.filterLive,
                                ),
                                const SizedBox(width: 10.0),
                                FilterItem(
                                  onSelected: (value) {},
                                  text: AppLocalizations.of(context)!.filterPosts,
                                ),
                                const SizedBox(width: 10.0),
                                FilterItem(
                                  onSelected: (value) {},
                                  text: AppLocalizations.of(context)!.filterContinueWatching,
                                ),
                                const SizedBox(width: 10.0),
                                FilterItem(
                                  onSelected: (value) {},
                                  text: AppLocalizations.of(context)!.filterUnwatched,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList.builder(itemBuilder: (context, index) => VideoCard(video: videos[index]))
            ],
          );
        },
      ),
    );
  }
}
