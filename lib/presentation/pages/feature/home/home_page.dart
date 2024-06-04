import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/video.dart';
import 'package:video_sharing_app/domain/repository/notification_repository.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/components/app_bar_actions.dart';
import 'package:video_sharing_app/presentation/components/filter_item.dart';
import 'package:video_sharing_app/presentation/components/video_card.dart';
import 'package:video_sharing_app/presentation/pages/feature/upload/video_editor.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';
import 'package:video_sharing_app/presentation/theme/theme_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const pageSize = 5;

  final videoRepository = getIt<VideoRepository>();
  final notificationRepository = getIt<NotificationRepository>();

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
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            leading: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(Asset.logoLow, width: 34.0),
              ),
            ),
            titleSpacing: 6.0,
            title: const Text('MeTube'),
            actions: [
              IconButton(
                onPressed: () => onUploadClicked(context),
                icon: const Icon(CupertinoIcons.add),
              ),
              const NotificationButton(),
              const SearchButton(),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight - 8.0),
              child: SizedBox(
                height: kToolbarHeight - 8.0,
                child: FutureBuilder(
                  future: videoRepository.getVideoCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) return const SizedBox.expand();
                    final hashtags = snapshot.data!;
                    var activeIndex = 0;
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(width: 8.0),
                          scrollDirection: Axis.horizontal,
                          itemCount: hashtags.length + 1,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          itemBuilder: (context, index) => FilterItem(
                            onSelected: (value) {
                              setState(() => activeIndex = index);
                            },
                            text: index == 0 ? AppLocalizations.of(context)!.filterAll : hashtags[index - 1],
                            isActive: index == activeIndex,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          PagedSliverList<int, Video>(
            pagingController: pagingController!,
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

  void fetchPage(int page) async {
    final pageResponse = await videoRepository.getVideosByCategoryAll(Pageable(page: page, size: pageSize));
    final isLastPage = pageResponse.items.length < pageSize;
    if (isLastPage) {
      pagingController?.appendLastPage(pageResponse.items);
    } else {
      final nextPage = page + 1;
      pagingController?.appendPage(pageResponse.items, nextPage);
    }
  }

  void onUploadClicked(context) async {
    final picker = ImagePicker();
    final file = await picker.pickVideo(source: ImageSource.gallery);
    if (file != null && mounted) {
      final previousTheme = Provider.of<ThemeProvider>(context, listen: false).themeMode;
      Provider.of<ThemeProvider>(context, listen: false).themeMode = ThemeMode.dark;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoEditor(
            videoPath: file.path,
            previousTheme: previousTheme,
          ),
        ),
      );
      Provider.of<ThemeProvider>(context, listen: false).themeMode = previousTheme;
    }
  }
}
