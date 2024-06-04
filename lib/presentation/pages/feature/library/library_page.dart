import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_sharing_app/presentation/components/app_bar_actions.dart';
import 'package:video_sharing_app/presentation/pages/feature/library/components/view_history_item.dart';
import 'package:video_sharing_app/presentation/pages/feature/library/your_videos/your_videos_page.dart';
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
          SliverToBoxAdapter(
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
                              style:
                                  TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
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
                            color: Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Icon(Icons.access_time_filled_rounded, color: Theme.of(context).colorScheme.primary),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.playlistWatchLater,
                          style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(AppLocalizations.of(context)!.nVideos(23)),
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
                            color: Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Icon(Icons.thumb_up_rounded, color: Theme.of(context).colorScheme.primary),
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.playlistLikedVideos,
                          style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(AppLocalizations.of(context)!.nVideos(56)),
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
                            Asset.illustrationAuth,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: const Text(
                          'My Favorite Songs',
                          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(AppLocalizations.of(context)!.nVideos(88)),
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
