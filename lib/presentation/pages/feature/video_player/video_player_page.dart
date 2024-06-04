import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/components/video_card.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/my_video_player.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/video_detail/comment_sheet.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/video_detail/video_description_sheet.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/video_detail/video_detail.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/video_detail/video_detail_provider.dart';
import 'package:video_sharing_app/presentation/theme/theme_provider.dart';

const videoPlayerRoute = 'video_player_route';

enum SheetType { videoDescription, comment }

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key, required Video video}) : _video = video;

  final Video _video;

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  static const relatedVideoPageSize = 10;
  final videoRepository = getIt<VideoRepository>();
  PagingController<int, Video>? relatedVideoPagingController = PagingController(firstPageKey: 0);

  final videoDescriptionSheetController = DraggableScrollableController();
  final commentSheetController = DraggableScrollableController();

  var showingReplies = false;

  @override
  void initState() {
    super.initState();
    relatedVideoPagingController!.addPageRequestListener(fetchRelatedVideoPage);
  }

  @override
  void dispose() {
    relatedVideoPagingController!.dispose();
    relatedVideoPagingController = null;
    videoDescriptionSheetController.dispose();
    commentSheetController.dispose();
    super.dispose();
  }

  void showSheet(SheetType type, snapPoint) {
    final controller = type == SheetType.videoDescription ? videoDescriptionSheetController : commentSheetController;
    controller.animateTo(
      snapPoint,
      duration: Durations.medium1,
      curve: Curves.linearToEaseOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Change status bar color to black for only this page.
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        if (videoDescriptionSheetController.size > 0.2) {
          videoDescriptionSheetController.animateTo(0.0, duration: Durations.medium1, curve: Curves.linearToEaseOut);
          return;
        }

        if (commentSheetController.size > 0.2 && showingReplies == false) {
          commentSheetController.animateTo(0.0, duration: Durations.medium1, curve: Curves.linearToEaseOut);
          return;
        }

        if (commentSheetController.size < 0.2 && showingReplies == false) {
          // Reset theme
          Provider.of<ThemeProvider>(context, listen: false).changeStatusBarColor(context);
          Navigator.pop(context);
        }
      },
      child: ChangeNotifierProvider(
        create: (context) => VideoDetailProvider(widget._video),
        builder: (context, child) {
          return Scaffold(
            body: SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double snapPoint = 1 - videoPlayerHeight / constraints.maxHeight;
                    return Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyVideoPlayer(video: widget._video),
                            Expanded(
                              child: CustomScrollView(
                                slivers: [
                                  SliverToBoxAdapter(
                                    child: VideoDetail(
                                      onShowBottomSheet: (type) => showSheet(type, snapPoint),
                                    ),
                                  ),
                                  PagedSliverList<int, Video>(
                                    pagingController: relatedVideoPagingController!,
                                    builderDelegate: PagedChildBuilderDelegate(
                                      itemBuilder: (context, item, index) => VideoCard(video: item),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Video description.
                        modalSheet(
                          sheetController: videoDescriptionSheetController,
                          title: AppLocalizations.of(context)!.descriptions,
                          snapPoint: snapPoint,
                          child: const VideoDescriptionSheet(),
                        ),
                        // Comments.
                        CommentSheet(
                          snapPoint: snapPoint,
                          sheetController: commentSheetController,
                          showingReplies: (value) => showingReplies = value,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void fetchRelatedVideoPage(int page) async {
    final pageResponse = await videoRepository.getRelatedVideos(
      widget._video.id!,
      Pageable(page: page, size: relatedVideoPageSize),
    );
    final isLastPage = pageResponse.items.length < relatedVideoPageSize;
    if (isLastPage) {
      relatedVideoPagingController?.appendLastPage(pageResponse.items);
    } else {
      final nextPage = page + 1;
      relatedVideoPagingController?.appendPage(pageResponse.items, nextPage);
    }
  }
}

Widget modalSheet({
  required DraggableScrollableController sheetController,
  required String title,
  required double snapPoint,
  required Widget child,
}) {
  return DraggableScrollableSheet(
    controller: sheetController,
    expand: true,
    snap: true,
    snapSizes: [snapPoint],
    initialChildSize: 0.0,
    minChildSize: 0.0,
    maxChildSize: 1.0,
    builder: (context, scrollController) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 72.0,
              titleSpacing: 0.0,
              pinned: true,
              automaticallyImplyLeading: false,
              title: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    Container(
                      width: 42.0,
                      height: 4.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                          InkWell(
                            borderRadius: BorderRadius.circular(100.0),
                            onTap: () {
                              sheetController.animateTo(
                                0.0,
                                duration: Durations.medium1,
                                curve: Curves.linearToEaseOut,
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.close_rounded),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1.0),
                child: Divider(
                  height: 1.0,
                  thickness: 0.5,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
            SliverFillRemaining(child: child),
          ],
        ),
      );
    },
  );
}
