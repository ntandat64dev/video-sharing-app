import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:video_sharing_app/data/repository_impl/follow_repository_impl.dart';
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
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
  static const followPageSize = 15;
  static const videoPageSize = 5;

  final VideoRepository videoRepository = VideoRepositoryImpl();
  final FollowRepository followRepository = FollowRepositoryImpl();

  PagingController<int, Follow>? followPagingController = PagingController(firstPageKey: 0);
  PagingController<int, Video>? videoPagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    followPagingController!.addPageRequestListener(fetchFollowPage);
    videoPagingController!.addPageRequestListener(fetchVideoPage);
  }

  @override
  void dispose() {
    followPagingController!.dispose();
    followPagingController = null;
    videoPagingController!.dispose();
    videoPagingController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
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
                    child: PagedListView<int, Follow>.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      scrollDirection: Axis.horizontal,
                      pagingController: followPagingController!,
                      builderDelegate: PagedChildBuilderDelegate(
                        itemBuilder: (context, follow, index) {
                          return SinkAnimated(
                            onTap: () {},
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: CachedNetworkImage(
                                    imageUrl: follow.userThumbnails![Thumbnail.kDefault]!.url,
                                    height: 72.0,
                                    width: 72.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(follow.username!)
                              ],
                            ),
                          );
                        },
                      ),
                      separatorBuilder: (context, index) => const SizedBox(width: 12.0),
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
          PagedSliverList<int, Video>(
            pagingController: videoPagingController!,
            builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, video, index) {
                return VideoCard(video: video);
              },
            ),
          ),
        ],
      ),
    );
  }

  void fetchVideoPage(int pageKey) async {
    final pageResponse = await videoRepository.getFollowingVideos(Pageable(page: pageKey, size: videoPageSize));
    final isLastPage = pageResponse.items.length < videoPageSize;
    if (isLastPage) {
      videoPagingController?.appendLastPage(pageResponse.items);
    } else {
      final nextPageKey = pageKey + pageResponse.items.length;
      videoPagingController?.appendPage(pageResponse.items, nextPageKey);
    }
  }

  void fetchFollowPage(int pageKey) async {
    final pageResponse = await followRepository.getFollows(Pageable(page: pageKey, size: followPageSize));
    final isLastPage = pageResponse.items.length < followPageSize;
    if (isLastPage) {
      followPagingController?.appendLastPage(pageResponse.items);
    } else {
      final nextPageKey = pageKey + pageResponse.items.length;
      followPagingController?.appendPage(pageResponse.items, nextPageKey);
    }
  }
}
