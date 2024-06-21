import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/pageable.dart';
import 'package:video_sharing_app/domain/entity/playlist.dart';
import 'package:video_sharing_app/domain/entity/playlist_item.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/repository/playlist_repository.dart';
import 'package:video_sharing_app/presentation/components/app_bar_actions.dart';
import 'package:video_sharing_app/presentation/components/app_bar_back_button.dart';
import 'package:video_sharing_app/presentation/components/bottom_sheet.dart';
import 'package:video_sharing_app/presentation/components/duration_chip.dart';
import 'package:video_sharing_app/presentation/components/sink_animated.dart';
import 'package:video_sharing_app/presentation/pages/feature/library/playlist/playlist_player_page.dart';

class PlaylistItemsPage extends StatefulWidget {
  const PlaylistItemsPage({super.key, required this.playlist, required this.defaultType});

  final Playlist playlist;
  final int? defaultType;

  @override
  State<PlaylistItemsPage> createState() => _PlaylistItemsPageState();
}

class _PlaylistItemsPageState extends State<PlaylistItemsPage> {
  final pageSize = 10000;
  final playlistRepository = getIt<PlaylistRepository>();
  final pagingController = PagingController<int, PlaylistItem>(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener(fetchPlaylistItemsPage);
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: appBarBackButton(context),
              titleSpacing: 0.0,
              title: Text(
                widget.defaultType == null
                    ? widget.playlist.title!
                    : widget.defaultType == 0
                        ? AppLocalizations.of(context)!.playlistWatchLater
                        : AppLocalizations.of(context)!.playlistLikedVideos,
              ),
              floating: true,
              actions: const [
                SearchButton(),
                MoreButon(),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(115),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          // Play button
                          Expanded(
                            child: SinkAnimated(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlaylistPlayer(
                                      playlist: widget.playlist,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(200.0),
                                  border: Border.all(width: 2.0, color: Theme.of(context).colorScheme.primary),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.play_circle_fill_rounded,
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          AppLocalizations.of(context)!.play,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context).colorScheme.onPrimary,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          // Shuffle
                          Expanded(
                            child: SinkAnimated(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlaylistPlayer(
                                      playlist: widget.playlist,
                                      shuffle: true,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  borderRadius: BorderRadius.circular(200.0),
                                  border: Border.all(width: 2.0, color: Theme.of(context).colorScheme.primary),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          CupertinoIcons.shuffle,
                                          size: 23.0,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          AppLocalizations.of(context)!.shuffle,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // Edit button
                              if (widget.defaultType == null)
                                InkWell(
                                  borderRadius: BorderRadius.circular(100.0),
                                  onTap: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(CupertinoIcons.square_pencil_fill),
                                  ),
                                ),
                              // Download button
                              InkWell(
                                borderRadius: BorderRadius.circular(100.0),
                                onTap: () {},
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(CupertinoIcons.arrow_down_to_line),
                                ),
                              ),
                              if (widget.defaultType == null)
                                // Share button
                                InkWell(
                                  borderRadius: BorderRadius.circular(100.0),
                                  onTap: () {},
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(CupertinoIcons.paperplane),
                                  ),
                                ),
                              const SizedBox(width: 16.0),
                              Text(
                                widget.defaultType == null
                                    ? AppLocalizations.of(context)!.nVideos(widget.playlist.itemCount!)
                                    : widget.defaultType == 0
                                        ? AppLocalizations.of(context)!.nUnwatchedVideos(widget.playlist.itemCount!)
                                        : AppLocalizations.of(context)!.nLikedVideos(widget.playlist.itemCount!),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          // Sort by
                          Builder(builder: (context) {
                            var state = 0;
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return GestureDetector(
                                  onTap: () => setState(() => state = state == 0 ? 1 : 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.searchSortBy,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Icon(
                                        state == 0 ? CupertinoIcons.chevron_down : CupertinoIcons.chevron_up,
                                        size: 20.0,
                                        color: Theme.of(context).colorScheme.primary,
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          })
                        ],
                      ),
                    ),
                    const SizedBox(height: 6.0),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: FutureBuilder(
                future: playlistRepository.getPlaylistById(widget.playlist.id!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done || snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final playlist = snapshot.data!;

                  return PagedListView<int, PlaylistItem>(
                    pagingController: pagingController,
                    builderDelegate: PagedChildBuilderDelegate(
                      noItemsFoundIndicatorBuilder: (context) => Material(
                        child: Column(
                          children: [
                            const SizedBox(height: 16.0),
                            Text(
                              AppLocalizations.of(context)!.playlistNoVideos,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (context, item, index) {
                        return Material(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlaylistPlayer(
                                    playlist: widget.playlist,
                                    initIndex: index,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0, bottom: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.drag_handle_rounded),
                                        const SizedBox(width: 10.0),
                                        Column(
                                          children: [
                                            const SizedBox(height: 4.0),
                                            Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(16.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: item.thumbnails![Thumbnail.kDefault]!.url,
                                                    fit: BoxFit.cover,
                                                    width: 120.0,
                                                    height: 90.0,
                                                  ),
                                                ),
                                                DurationChip(isoDuration: item.duration!),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 16.0),
                                        Expanded(
                                          child: SizedBox(
                                            height: 90.0,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.title!,
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  item.videoOwnerUsername!,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    customBorder: const CircleBorder(),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(Icons.more_vert, size: 18.0),
                                    ),
                                    onTap: () => showOptionBottomSheet(context, playlist: playlist, playlistItem: item),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void fetchPlaylistItemsPage(int page) async {
    final pageResponse = await playlistRepository.getPlaylistItemByPlaylistId(
      widget.playlist.id!,
      Pageable(page: page, size: pageSize),
    );
    final isLastPage = pageResponse.items.length < pageSize;
    if (isLastPage) {
      pagingController.appendLastPage(pageResponse.items);
    } else {
      final nextPage = page + 1;
      pagingController.appendPage(pageResponse.items, nextPage);
    }
  }

  void showOptionBottomSheet(
    context, {
    required Playlist playlist,
    required PlaylistItem playlistItem,
  }) =>
      showConsistentBottomSheet(
        context: context,
        height: 230.0,
        negativeButton: bottomSheetNegativeButton(context: context),
        content: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  final isSuccessful = await playlistRepository.removePlaylistItem(
                    playlistId: playlist.id!,
                    videoId: playlistItem.videoId!,
                  );
                  if (isSuccessful) {
                    setState(() {});
                    pagingController.refresh();
                    Navigator.pop(context);
                  }
                },
                child: ListTile(
                  leading: const Icon(CupertinoIcons.trash),
                  title: Text(AppLocalizations.of(context)!.removeFrom(playlist.title!)),
                ),
              ),
              InkWell(
                onTap: () async {},
                child: ListTile(
                  leading: const Icon(CupertinoIcons.arrowshape_turn_up_right),
                  title: Text(AppLocalizations.of(context)!.shareButton),
                ),
              ),
            ],
          ),
        ),
      );
}
