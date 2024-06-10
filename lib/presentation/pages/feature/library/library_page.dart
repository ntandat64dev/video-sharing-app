import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/playlist.dart';
import 'package:video_sharing_app/domain/entity/thumbnail.dart';
import 'package:video_sharing_app/domain/repository/playlist_repository.dart';
import 'package:video_sharing_app/presentation/components/app_bar_actions.dart';
import 'package:video_sharing_app/presentation/components/bottom_sheet.dart';
import 'package:video_sharing_app/presentation/components/custom_text_field.dart';
import 'package:video_sharing_app/presentation/pages/feature/library/components/view_history_item.dart';
import 'package:video_sharing_app/presentation/pages/feature/library/playlist/add_playlist_description.dart';
import 'package:video_sharing_app/presentation/pages/feature/library/playlist/playlist_items_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/library/your_videos/your_videos_page.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final playlistRepository = getIt<PlaylistRepository>();
  final refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(Asset.logoLow, width: 34.0),
              ),
            ),
            titleSpacing: 6.0,
            title: Text(AppLocalizations.of(context)!.library),
            floating: true,
            actions: const [
              NotificationButton(),
              SearchButton(),
            ],
          ),
          SliverFillRemaining(
            child: SmartRefresher(
              controller: refreshController,
              onRefresh: () async {
                setState(() {});
                refreshController.refreshCompleted();
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // View history
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.viewHistory,
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
                      height: 190.0,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(width: 12.0),
                        itemCount: 5,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return const ViewHistoryItem();
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
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const YourVideosPage()),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Theme.of(context).colorScheme.primaryContainer,
                            ),
                            child: Icon(Icons.play_circle_rounded, color: Theme.of(context).colorScheme.primary),
                          ),
                          title: Text(
                            AppLocalizations.of(context)!.yourVideosListTile,
                            style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
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
                              color: Theme.of(context).colorScheme.primaryContainer,
                            ),
                            child: Icon(Icons.download_rounded, color: Theme.of(context).colorScheme.primary),
                          ),
                          title: Text(
                            AppLocalizations.of(context)!.downloads,
                            style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
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
                    StatefulBuilder(
                      builder: (context, setStatePlaylists) {
                        return FutureBuilder(
                          future: playlistRepository.getMyPlaylists(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState != ConnectionState.done) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 48.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            if (snapshot.data == null) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 48.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0, right: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.playlists,
                                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                                          child: Text(
                                            AppLocalizations.of(context)!.recentlyAdded,
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
                                // New playlist
                                InkWell(
                                  onTap: () => showNewPlaylistBottomSheet(
                                      context: context, onRefresh: (Playlist p) => setStatePlaylists(() {})),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: ListTile(
                                      leading: Container(
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color: Theme.of(context).colorScheme.primaryContainer,
                                        ),
                                        child: Icon(Icons.add_rounded, color: Theme.of(context).colorScheme.primary),
                                      ),
                                      title: Text(
                                        AppLocalizations.of(context)!.playlistNew,
                                        style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                for (final (index, playlist) in snapshot.data!.items.indexed)
                                  InkWell(
                                    onLongPress: () {
                                      if (playlist.isDefaultPlaylist!) return;
                                      showPlaylistOptionBottomSheet(
                                        playlist: playlist,
                                        onRefresh: () => setStatePlaylists(() {}),
                                      );
                                    },
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlaylistItemsPage(
                                            playlist: playlist,
                                            defaultType: playlist.isDefaultPlaylist! ? index : null,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: ListTile(
                                        leading: playlist.isDefaultPlaylist!
                                            ? Container(
                                                padding: const EdgeInsets.all(12.0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100),
                                                  color: Theme.of(context).colorScheme.primaryContainer,
                                                ),
                                                child: Icon(
                                                    index == 0
                                                        ? Icons.access_time_filled_rounded
                                                        : Icons.thumb_up_rounded,
                                                    color: Theme.of(context).colorScheme.primary),
                                              )
                                            : ClipRRect(
                                                borderRadius: BorderRadius.circular(16.0),
                                                child: playlist.thumbnails![Thumbnail.kDefault]?.url != null
                                                    ? CachedNetworkImage(
                                                        imageUrl: playlist.thumbnails![Thumbnail.kDefault]!.url,
                                                        fadeInDuration: const Duration(milliseconds: 300),
                                                        fadeOutDuration: const Duration(milliseconds: 1),
                                                        width: 50.0,
                                                        height: 50.0,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Container(
                                                        color: Theme.of(context).colorScheme.primary.withAlpha(200),
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child: Center(
                                                          child: Text(
                                                            playlist.title![0],
                                                            style: TextStyle(
                                                              fontSize: 20.0,
                                                              color: Theme.of(context).colorScheme.onPrimary,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                        title: Text(
                                          !playlist.isDefaultPlaylist!
                                              ? playlist.title!
                                              : index == 0
                                                  ? AppLocalizations.of(context)!.playlistWatchLater
                                                  : AppLocalizations.of(context)!.playlistLikedVideos,
                                          style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(AppLocalizations.of(context)!.nVideos(playlist.itemCount!)),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showPlaylistOptionBottomSheet({
    required Playlist playlist,
    void Function()? onRefresh,
  }) =>
      showConsistentBottomSheet(
        context: context,
        height: 230.0,
        negativeButton: bottomSheetNegativeButton(context: context),
        content: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  showEditPlaylistBottomSheet(
                    playlist: playlist,
                    onRefresh: onRefresh,
                  );
                },
                child: ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: Text(AppLocalizations.of(context)!.edit),
                ),
              ),
              InkWell(
                onTap: () async {
                  final isSuccess = await playlistRepository.deletePlaylistById(playlist.id!);
                  if (isSuccess) {
                    onRefresh?.call();
                    if (mounted && context.mounted) Navigator.pop(context);
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

  void showEditPlaylistBottomSheet({
    required Playlist playlist,
    void Function()? onRefresh,
  }) {
    final titleController = TextEditingController(text: playlist.title);
    var finalDescription = playlist.description;
    var finalPrivacy = playlist.privacy!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      builder: (context) => GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: StatefulBuilder(
            builder: (context, setStateSheet) {
              return Column(
                children: [
                  const SizedBox(height: 12.0),
                  Container(
                    width: 38.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: DraggableScrollableSheet(
                      initialChildSize: 1,
                      minChildSize: 0.0,
                      builder: (context, scrollController) {
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.editPlaylist,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                                    ),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(100.0),
                                      onTap: () => Navigator.pop(context),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.close_rounded),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Divider(
                                height: 0.0,
                                thickness: 0.5,
                                color: Theme.of(context).colorScheme.outlineVariant,
                              ),
                              // Thumbnail
                              if (playlist.thumbnails![Thumbnail.kDefault]?.url != null)
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(24.0),
                                    child: CachedNetworkImage(imageUrl: playlist.thumbnails![Thumbnail.kDefault]!.url),
                                  ),
                                ),
                              const SizedBox(height: 8.0),
                              // Edit title
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  AppLocalizations.of(context)!.title,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: CustomTextField(
                                  controller: titleController,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              // Edit description
                              InkWell(
                                onTap: () async {
                                  final description = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddPlaylistDescription(text: finalDescription),
                                    ),
                                  );
                                  if (description != null) {
                                    setStateSheet(() => finalDescription = description);
                                  }
                                },
                                child: finalDescription == null || finalDescription!.isEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            const Icon(CupertinoIcons.text_alignright),
                                            const SizedBox(width: 14.0),
                                            Text(
                                              AppLocalizations.of(context)!.addDescription,
                                              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(top: 2.0),
                                              child: Icon(CupertinoIcons.text_alignright),
                                            ),
                                            const SizedBox(width: 12.0),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    AppLocalizations.of(context)!.description,
                                                    style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                                                  ),
                                                  Text(
                                                    finalDescription!,
                                                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                              ),
                              // Edit privacy
                              InkWell(
                                onTap: () async {
                                  final privacy = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      var privacy = finalPrivacy;
                                      return StatefulBuilder(
                                        builder: (context, setStateDialog) {
                                          return AlertDialog(
                                            backgroundColor: Theme.of(context).colorScheme.surface,
                                            surfaceTintColor: Colors.transparent,
                                            title: Text(AppLocalizations.of(context)!.privacy),
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                            ),
                                            contentPadding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
                                            actionsPadding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
                                            actions: [
                                              // Cancel button
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text(
                                                  AppLocalizations.of(context)!.cancel,
                                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                              // Ok button
                                              TextButton(
                                                onPressed: () => Navigator.pop(context, privacy),
                                                child: Text(
                                                  AppLocalizations.of(context)!.ok,
                                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                privacyItem(
                                                  onTap: () => setStateDialog(() => privacy = 'PRIVATE'),
                                                  context: context,
                                                  icon: const Icon(Icons.lock_outline_rounded),
                                                  title: AppLocalizations.of(context)!.private,
                                                  subTitle: AppLocalizations.of(context)!.privacyPrivateSubtext,
                                                  selected: privacy == 'PRIVATE',
                                                ),
                                                privacyItem(
                                                  onTap: () => setStateDialog(() => privacy = 'PUBLIC'),
                                                  context: context,
                                                  icon: const Icon(Icons.public_rounded),
                                                  title: AppLocalizations.of(context)!.public,
                                                  subTitle: AppLocalizations.of(context)!.privacyPublicSubtext,
                                                  selected: privacy == 'PUBLIC',
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                  if (privacy != null) {
                                    setStateSheet(() => finalPrivacy = privacy);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 2.0),
                                        child: Icon(CupertinoIcons.lock),
                                      ),
                                      const SizedBox(width: 12.0),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.privacy,
                                              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              finalPrivacy == 'PRIVATE'
                                                  ? AppLocalizations.of(context)!.private
                                                  : AppLocalizations.of(context)!.public,
                                              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Negative button
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: bottomSheetNegativeButton(context: context),
                          ),
                        ),
                        // Confirm button
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: bottomSheetConfirmButton(
                              onPressed: () async {
                                playlist.title = titleController.text;
                                playlist.description = finalDescription;
                                playlist.privacy = finalPrivacy;
                                final updatedPlaylist = await playlistRepository.updatePlaylist(playlist);
                                if (updatedPlaylist != null) {
                                  onRefresh?.call();
                                  if (context.mounted) Navigator.pop(context);
                                }
                              },
                              context: context,
                              text: AppLocalizations.of(context)!.update,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

void showNewPlaylistBottomSheet({required BuildContext context, void Function(Playlist)? onRefresh}) {
  final titleController = TextEditingController();
  final privacyController = TextEditingController(text: AppLocalizations.of(context)!.private);
  var finalPrivacy = 'private';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32.0),
        topRight: Radius.circular(32.0),
      ),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SizedBox(
              height: 390.0,
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 12.0),
                  Container(
                    width: 38.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          AppLocalizations.of(context)!.playlistNew,
                          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(
                        height: 0.0,
                        thickness: 0.5,
                        indent: 16.0,
                        endIndent: 16.0,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.playlistTitle,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            CustomTextField(
                              controller: titleController,
                            ),
                            const SizedBox(height: 15.0),
                            Text(
                              AppLocalizations.of(context)!.privacy,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            CustomTextField(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    var privacy = finalPrivacy;
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          backgroundColor: Theme.of(context).colorScheme.surface,
                                          surfaceTintColor: Colors.transparent,
                                          title: Text(AppLocalizations.of(context)!.privacy),
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                                          ),
                                          contentPadding: const EdgeInsets.only(top: 16.0, bottom: 4.0),
                                          actionsPadding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 8.0),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text(
                                                AppLocalizations.of(context)!.cancel,
                                                style: const TextStyle(fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                finalPrivacy = privacy;
                                                privacyController.text = privacy == 'private'
                                                    ? AppLocalizations.of(context)!.private
                                                    : AppLocalizations.of(context)!.public;
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!.ok,
                                                style: const TextStyle(fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              privacyItem(
                                                onTap: () => setState(() => privacy = 'private'),
                                                context: context,
                                                icon: const Icon(Icons.lock_outline_rounded),
                                                title: AppLocalizations.of(context)!.private,
                                                subTitle: AppLocalizations.of(context)!.privacyPrivateSubtext,
                                                selected: privacy == 'private',
                                              ),
                                              privacyItem(
                                                onTap: () => setState(() => privacy = 'public'),
                                                context: context,
                                                icon: const Icon(Icons.public_rounded),
                                                title: AppLocalizations.of(context)!.public,
                                                subTitle: AppLocalizations.of(context)!.privacyPublicSubtext,
                                                selected: privacy == 'public',
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              controller: privacyController,
                              readOnly: true,
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                size: 20.0,
                              ),
                              suffixIcon: const Icon(
                                CupertinoIcons.chevron_right,
                                size: 20.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: bottomSheetNegativeButton(context: context),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: bottomSheetConfirmButton(
                              onPressed: () async {
                                final createdPlaylist = await getIt<PlaylistRepository>().createPlaylist(
                                  Playlist.post(
                                    title: titleController.text,
                                    description: null,
                                    userId: null,
                                    privacy: finalPrivacy,
                                  ),
                                );
                                if (createdPlaylist != null) {
                                  onRefresh?.call(createdPlaylist);
                                  if (context.mounted) Navigator.pop(context);
                                }
                              },
                              context: context,
                              text: AppLocalizations.of(context)!.create,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget privacyItem({
  void Function()? onTap,
  required BuildContext context,
  required Widget icon,
  required String title,
  required String subTitle,
  bool selected = false,
}) =>
    Material(
      color: selected
          ? Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(40)
          : Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: icon,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subTitle,
                      style: TextStyle(color: Theme.of(context).colorScheme.onBackground.withAlpha(200)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
