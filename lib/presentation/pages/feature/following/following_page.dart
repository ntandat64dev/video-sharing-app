import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/follow.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/follow_repository.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/components/app_bar_actions.dart';
import 'package:video_sharing_app/presentation/components/filter_item.dart';
import 'package:video_sharing_app/presentation/components/sink_animated.dart';
import 'package:video_sharing_app/presentation/components/video_card.dart';
import 'package:video_sharing_app/presentation/pages/feature/following/following_empty_page.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

enum Filter { all, today, videos, shorts, live, posts, continueWatching, unwatched }

class _FollowingPageState extends State<FollowingPage> {
  static const followPageSize = 15;
  static const videoPageSize = 5;

  final videoRepository = getIt<VideoRepository>();
  final followRepository = getIt<FollowRepository>();

  PagingController<int, Follow>? followPagingController = PagingController(firstPageKey: 0);
  PagingController<int, Video>? videoPagingController = PagingController(firstPageKey: 0);

  var filter = Filter.all;

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
    return FutureBuilder(
      future: followRepository.getFollows(Pageable(size: 1)),
      builder: (context, snapshot) {
        final isEmpty = snapshot.hasData && snapshot.data!.items.isEmpty;
        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(AppLocalizations.of(context)!.following),
                floating: true,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Image.asset(Asset.logoLow, width: 34.0),
                  ),
                ),
                titleSpacing: 6.0,
                actions: const [
                  NotificationButton(),
                  SearchButton(),
                ],
                bottom: isEmpty
                    ? null
                    : PreferredSize(
                        preferredSize: const Size.fromHeight(224),
                        child: Column(
                          children: [
                            // Followings
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, top: 0.0, bottom: 16.0, right: 8.0),
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
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
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
                                          Text(
                                            follow.username!,
                                            style: const TextStyle(fontWeight: FontWeight.w500),
                                          )
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
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                      child: Row(
                                        children: [
                                          FilterItem(
                                            onSelected: (value) {
                                              setState(() => filter = Filter.all);
                                            },
                                            text: AppLocalizations.of(context)!.filterAll,
                                            isActive: filter == Filter.all,
                                          ),
                                          const SizedBox(width: 10.0),
                                          FilterItem(
                                            onSelected: (value) {
                                              setState(() => filter = Filter.today);
                                            },
                                            text: AppLocalizations.of(context)!.filterToday,
                                            isActive: filter == Filter.today,
                                          ),
                                          const SizedBox(width: 10.0),
                                          FilterItem(
                                            onSelected: (value) {
                                              setState(() => filter = Filter.videos);
                                            },
                                            text: AppLocalizations.of(context)!.filterVideos,
                                            isActive: filter == Filter.videos,
                                          ),
                                          const SizedBox(width: 10.0),
                                          FilterItem(
                                            onSelected: (value) {
                                              setState(() => filter = Filter.shorts);
                                            },
                                            text: AppLocalizations.of(context)!.filterShorts,
                                            isActive: filter == Filter.shorts,
                                          ),
                                          const SizedBox(width: 10.0),
                                          FilterItem(
                                            onSelected: (value) {
                                              setState(() => filter = Filter.live);
                                            },
                                            text: AppLocalizations.of(context)!.filterLive,
                                            isActive: filter == Filter.live,
                                          ),
                                          const SizedBox(width: 10.0),
                                          FilterItem(
                                            onSelected: (value) {
                                              setState(() => filter = Filter.posts);
                                            },
                                            text: AppLocalizations.of(context)!.filterPosts,
                                            isActive: filter == Filter.posts,
                                          ),
                                          const SizedBox(width: 10.0),
                                          FilterItem(
                                            onSelected: (value) {
                                              setState(() => filter = Filter.continueWatching);
                                            },
                                            text: AppLocalizations.of(context)!.filterContinueWatching,
                                            isActive: filter == Filter.continueWatching,
                                          ),
                                          const SizedBox(width: 10.0),
                                          FilterItem(
                                            onSelected: (value) {
                                              setState(() => filter = Filter.unwatched);
                                            },
                                            text: AppLocalizations.of(context)!.filterUnwatched,
                                            isActive: filter == Filter.unwatched,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              isEmpty
                  ? const SliverFillRemaining(
                      hasScrollBody: false,
                      child: FollowingEmptyPage(),
                    )
                  : PagedSliverList<int, Video>(
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
      },
    );
  }

  void fetchVideoPage(int page) async {
    final pageResponse = await videoRepository.getFollowingVideos(Pageable(page: page, size: videoPageSize));
    final isLastPage = pageResponse.items.length < videoPageSize;
    if (isLastPage) {
      videoPagingController?.appendLastPage(pageResponse.items);
    } else {
      final nextPage = page + 1;
      videoPagingController?.appendPage(pageResponse.items, nextPage);
    }
  }

  void fetchFollowPage(int page) async {
    final pageResponse = await followRepository.getFollows(Pageable(page: page, size: followPageSize));
    final isLastPage = pageResponse.items.length < followPageSize;
    if (isLastPage) {
      followPagingController?.appendLastPage(pageResponse.items);
    } else {
      final nextPage = page + 1;
      followPagingController?.appendPage(pageResponse.items, nextPage);
    }
  }
}
