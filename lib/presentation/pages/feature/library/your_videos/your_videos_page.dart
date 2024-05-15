import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_sharing_app/data/repository_impl/video_repository_impl.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/components/app_bar_back_button.dart';
import 'package:video_sharing_app/presentation/components/bottom_sheet.dart';
import 'package:video_sharing_app/presentation/components/filter_item.dart';
import 'package:video_sharing_app/presentation/pages/feature/home/video_player_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/library/your_videos/provider/your_videos_provider.dart';
import 'package:video_sharing_app/presentation/pages/feature/library/your_videos/update_video_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/set_privacy_page.dart';

class YourVideosPage extends StatefulWidget {
  const YourVideosPage({super.key});

  @override
  State<YourVideosPage> createState() => _YourVideosPageState();
}

class _YourVideosPageState extends State<YourVideosPage> {
  static const pageSize = 10;

  final VideoRepository videoRepository = VideoRepositoryImpl();
  PagingController<int, Video>? pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    pagingController!.addPageRequestListener(fetchPage);
  }

  @override
  void dispose() {
    pagingController!.dispose();
    pagingController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: appBarBackButton(context),
          title: Text(AppLocalizations.of(context)!.yourVideosAppBarTitle),
        ),
        body: ChangeNotifierProvider(
          create: (context) => YourVideosProvider(pagingController!),
          builder: (context, child) {
            return Consumer<YourVideosProvider>(
              builder: (context, provider, child) {
                return CustomScrollView(
                  slivers: [
                    // Filters
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      titleSpacing: 0.0,
                      floating: true,
                      title: SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                                FilterItem(
                                  onSelected: (value) {},
                                  text: AppLocalizations.of(context)!.filterVideos,
                                  isActive: true,
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Videos list
                    PagedSliverList<int, Video>(
                      pagingController: pagingController!,
                      builderDelegate: PagedChildBuilderDelegate(
                        itemBuilder: (context, item, index) {
                          return YourVideoItem(video: item);
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void fetchPage(int pageKey) async {
    final pageResponse = await videoRepository.getMyVideos(Pageable(page: pageKey, size: pageSize));
    final isLastPage = pageResponse.items.length < pageSize;
    if (isLastPage) {
      pagingController?.appendLastPage(pageResponse.items);
    } else {
      final nextPageKey = pageKey + pageResponse.items.length;
      pagingController?.appendPage(pageResponse.items, nextPageKey);
    }
  }
}

class YourVideoItem extends StatelessWidget {
  YourVideoItem({super.key, required this.video});

  final Video video;
  final VideoRepository videoRepository = VideoRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerPage(video: video),
            settings: const RouteSettings(name: videoPlayerRoute),
          ),
        );
      },
      onLongPress: () => showOptionBottomSheet(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: CachedNetworkImage(
                imageUrl: video.thumbnails![Thumbnail.kDefault]!.url,
                fit: BoxFit.cover,
                width: 100.0,
                height: 100.0,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          video.title!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(Icons.more_vert, size: 22.0),
                        ),
                        onTap: () => showOptionBottomSheet(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    '${AppLocalizations.of(context)!.nViews(video.viewCount!.toInt())}  ∙  ${timeago.format(video.publishedAt!)}',
                  ),
                  const SizedBox(height: 8.0),
                  Icon(
                    video.privacy!.toLowerCase() == Privacy.private.name ? Icons.lock_rounded : Icons.public,
                    size: 16.0,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showOptionBottomSheet(context) => showConsistentBottomSheet(
        context: context,
        height: 230.0,
        negativeButton: bottomSheetNegativeButton(context: context),
        content: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  Navigator.pop(context);
                  final isUpdateSuccess = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateVideoPage(video: video)),
                  ) as bool?;
                  if (isUpdateSuccess != null && isUpdateSuccess) {
                    Provider.of<YourVideosProvider>(context, listen: false).reload();
                  }
                },
                child: ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: Text(AppLocalizations.of(context)!.edit),
                ),
              ),
              InkWell(
                onTap: () async {
                  final isDeleteSuccess = await videoRepository.deleteVideoById(video.id!);
                  if (isDeleteSuccess) {
                    Navigator.pop(context);
                    Provider.of<YourVideosProvider>(context, listen: false).reload();
                  }
                },
                child: ListTile(
                  leading: const Icon(Icons.delete_outline_rounded),
                  title: Text(AppLocalizations.of(context)!.delete),
                ),
              ),
            ],
          ),
        ),
      );
}
