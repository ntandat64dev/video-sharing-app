import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/entity/page_response.dart';
import 'package:video_sharing_app/domain/entity/playlist.dart';
import 'package:video_sharing_app/domain/enum/rating.dart';
import 'package:video_sharing_app/domain/repository/comment_repository.dart';
import 'package:video_sharing_app/domain/repository/playlist_repository.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/components/bottom_sheet.dart';
import 'package:video_sharing_app/presentation/components/custom_text_field.dart';
import 'package:video_sharing_app/presentation/components/sink_animated.dart';
import 'package:video_sharing_app/presentation/pages/feature/library/library_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/user_info/user_info_page.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/provider/video_detail_provider.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/video_player_page.dart';

class VideoDetail extends StatefulWidget {
  const VideoDetail({
    super.key,
    required Function(SheetType type) onShowBottomSheet,
  }) : _onShowBottomSheet = onShowBottomSheet;

  final Function(SheetType type) _onShowBottomSheet;

  @override
  State<VideoDetail> createState() => _VideoDetailState();
}

class _VideoDetailState extends State<VideoDetail> {
  final userRepository = getIt<UserRepository>();
  final videoRepository = getIt<VideoRepository>();
  final commentRepository = getIt<CommentRepository>();
  final playlistRepository = getIt<PlaylistRepository>();

  final commentController = TextEditingController();
  var isCommentFocus = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoDetailProvider>(
      builder: (context, provider, child) {
        if (!provider.isDetailLoaded) return const SizedBox.shrink();

        final video = provider.video;
        final videoRating = provider.videoRating;
        final follow = provider.follow;
        final user = provider.user;
        final containingPlaylistIds = provider.containingPlaylistIds;

        final Future<PageResponse<Playlist>> myPlaylistsFuture = playlistRepository.getMyPlaylists();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title, views, tags
            InkWell(
              onTap: () {
                provider.shouldLoadVideoDescription = true;
                widget._onShowBottomSheet(SheetType.videoDescription);
              },
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              video.title!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1.25,
                              ),
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down_rounded),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '${AppLocalizations.of(context)!.nViews(video.viewCount!.toInt())}  ${timeago.format(video.publishedAt!)}  ${video.hashtags?.map((e) => '#${e.toLowerCase().replaceAll(' ', '')}').join(' ')}',
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      )
                    ],
                  ),
                ),
              ),
            ),
            // Actions
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Like
                  SinkAnimated(
                    onTap: () => provider.rateVideo(Rating.like),
                    level: 0.1,
                    child: Container(
                      color: Colors.transparent,
                      width: 56.0,
                      height: 54.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            videoRating.rating == Rating.like
                                ? CupertinoIcons.hand_thumbsup_fill
                                : CupertinoIcons.hand_thumbsup,
                            size: 24.0,
                            color: videoRating.rating == Rating.like
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onBackground.withAlpha(230),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            AppLocalizations.of(context)!.n(video.likeCount!.toInt()),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: videoRating.rating == Rating.like
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onBackground.withAlpha(230),
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  // Dislike
                  SinkAnimated(
                    onTap: () => provider.rateVideo(Rating.dislike),
                    level: 0.1,
                    child: Container(
                      color: Colors.transparent,
                      width: 56.0,
                      height: 54.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            videoRating.rating == Rating.dislike
                                ? CupertinoIcons.hand_thumbsdown_fill
                                : CupertinoIcons.hand_thumbsdown,
                            size: 24.0,
                            color: videoRating.rating == Rating.dislike
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onBackground.withAlpha(230),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            AppLocalizations.of(context)!.n(video.dislikeCount!.toInt()),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: videoRating.rating == Rating.dislike
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onBackground.withAlpha(230),
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  // Share
                  SinkAnimated(
                    onTap: () {},
                    level: 0.1,
                    child: Container(
                      color: Colors.transparent,
                      width: 60.0,
                      height: 54.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.arrowshape_turn_up_right,
                            size: 24.0,
                            color: Theme.of(context).colorScheme.onBackground.withAlpha(230),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            AppLocalizations.of(context)!.shareButton,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground.withAlpha(230),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  // Download
                  SinkAnimated(
                    onTap: () {},
                    level: 0.1,
                    child: Container(
                      color: Colors.transparent,
                      width: 70.0,
                      height: 54.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.arrow_down_to_line_alt,
                            size: 24.0,
                            color: Theme.of(context).colorScheme.onBackground.withAlpha(230),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            AppLocalizations.of(context)!.downloadButton,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground.withAlpha(230),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  // Save
                  SinkAnimated(
                    onTap: () => showSaveVideoBottomSheet(
                      context: context,
                      myPlaylistsFuture: myPlaylistsFuture,
                      containingPlaylistIdsFuture: containingPlaylistIds,
                      videoId: video.id!,
                      refreshPlaylists: () => provider.refreshPlaylists(),
                    ),
                    level: 0.1,
                    child: Container(
                      color: Colors.transparent,
                      width: 60.0,
                      height: 54.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            containingPlaylistIds.isNotEmpty ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
                            size: 24.0,
                            color: Theme.of(context).colorScheme.onBackground.withAlpha(230),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            AppLocalizations.of(context)!.saveButton,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground.withAlpha(230),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 0.3,
              thickness: 0.3,
              indent: 16.0,
              endIndent: 16.0,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            // Channel, Follow button
            InkWell(
              onTap: () async {
                final isChangedFollow = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserInfoPage(userId: user.id)),
                );
                if (isChangedFollow) {
                  provider.refreshUserAndFollow();
                }
              },
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: CachedNetworkImage(
                              imageUrl: video.userImageUrl!,
                              fit: BoxFit.cover,
                              width: 56.0,
                              height: 56.0,
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.username!,
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                AppLocalizations.of(context)!.nFollowers(user.followerCount!.toInt()),
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ],
                      ),
                      userRepository.getMyId() == video.userId
                          ? const SizedBox.shrink()
                          : follow != null
                              ? SizedBox(
                                  width: 120.0,
                                  child: TextButton(
                                    onPressed: () => provider.followUser(),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.surface,
                                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                                      elevation: 8.0,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Theme.of(context).colorScheme.outlineVariant.withAlpha(100),
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(100.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
                                      child: Text(
                                        AppLocalizations.of(context)!.followingButton,
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: 120.0,
                                  child: TextButton(
                                    onPressed: () => provider.followUser(),
                                    style: TextButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.primary,
                                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                      elevation: 8.0,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          color: Theme.of(context).colorScheme.primary,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(100.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
                                      child: Text(
                                        AppLocalizations.of(context)!.followButton,
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                    ],
                  ),
                ),
              ),
            ),
            Divider(
              height: 0.3,
              thickness: 0.3,
              indent: 16.0,
              endIndent: 16.0,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            // Comments
            InkWell(
              onTap: () {
                provider.shouldLoadComments = true;
                widget._onShowBottomSheet(SheetType.comment);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.comments,
                          style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 6.0),
                        Text(
                          AppLocalizations.of(context)!.n(video.commentCount!.toInt()),
                          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.swap_vert_rounded,
                      color: Theme.of(context).colorScheme.onBackground.withAlpha(200),
                    ),
                  ],
                ),
              ),
            ),
            // Add comment
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: CachedNetworkImage(
                  imageUrl: userRepository.getMyImageUrl()!,
                  fit: BoxFit.cover,
                  width: 48.0,
                  height: 48.0,
                ),
              ),
              title: Focus(
                onFocusChange: (value) => setState(() => isCommentFocus = value),
                child: CustomTextField(
                  controller: commentController,
                  hintText: AppLocalizations.of(context)!.hintAddComment,
                  suffixIcon: isCommentFocus
                      ? IconButton(
                          onPressed: () async {
                            // Sent comment
                            await provider.sendComment(
                              Comment.post(
                                videoId: provider.video.id!,
                                text: commentController.text,
                                parentId: null,
                              ),
                            );
                            setState(() {
                              FocusScope.of(context).requestFocus(FocusNode());
                              commentController.text = '';
                            });
                          },
                          icon: const Icon(Icons.send_rounded),
                          color: Theme.of(context).colorScheme.primary)
                      : const Icon(null),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

void showSaveVideoBottomSheet({
  required BuildContext context,
  Future<PageResponse<Playlist>>? myPlaylistsFuture,
  List<String>? containingPlaylistIdsFuture,
  required String videoId,
  required void Function() refreshPlaylists,
}) async {
  final playlistRepository = getIt<PlaylistRepository>();

  myPlaylistsFuture ??= playlistRepository.getMyPlaylists();
  containingPlaylistIdsFuture ??= await playlistRepository.getPlaylistIdsContainingVideo(videoId);

  Set<String> oldIds = Set.from(containingPlaylistIdsFuture);
  Set<String> videoContainingPlaylistIds = Set.from(containingPlaylistIdsFuture);

  if (!context.mounted) return;

  showConsistentBottomSheet(
    context: context,
    height: 400,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context)!.saveVideoTo,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
            showNewPlaylistBottomSheet(
                context: context,
                onRefresh: (Playlist p) async {
                  final playlistItem = await playlistRepository.addPlaylistItem(playlistId: p.id!, videoId: videoId);
                  if (playlistItem != null) refreshPlaylists();
                });
          },
          child: Row(
            children: [
              Icon(CupertinoIcons.add, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 5.0),
              Text(
                AppLocalizations.of(context)!.playlistNew,
                style: TextStyle(
                    fontSize: 16.0, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        )
      ],
    ),
    negativeButton: bottomSheetNegativeButton(context: context),
    confirmButton: bottomSheetConfirmButton(
      onPressed: () async {
        final isSuccess = await playlistRepository.addPlaylistItems(
          videoId: videoId,
          oldIds: oldIds,
          newIds: videoContainingPlaylistIds,
        );
        if (isSuccess && context.mounted) {
          refreshPlaylists();
          Navigator.pop(context);
        }
      },
      context: context,
      text: AppLocalizations.of(context)!.saveButton,
    ),
    content: FutureBuilder(
      future: myPlaylistsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done || snapshot.data == null) {
          return const SizedBox.shrink();
        }
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  for (final (index, playlist) in snapshot.data!.items.indexed)
                    if (index != 1)
                      Builder(builder: (context) {
                        onChange() {
                          if (videoContainingPlaylistIds.contains(playlist.id!)) {
                            videoContainingPlaylistIds.remove(playlist.id!);
                          } else {
                            videoContainingPlaylistIds.add(playlist.id!);
                          }
                          setState(() {});
                        }

                        return InkWell(
                          onTap: onChange,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2.0, top: 6.0, right: 16.0, bottom: 6.0),
                            child: Row(
                              children: [
                                CupertinoCheckbox(
                                  value: videoContainingPlaylistIds.contains(playlist.id),
                                  onChanged: (value) => onChange(),
                                  activeColor: Theme.of(context).colorScheme.primary,
                                ),
                                Expanded(
                                  child: Text(
                                    !playlist.isDefaultPlaylist!
                                        ? playlist.title!
                                        : index == 0
                                            ? AppLocalizations.of(context)!.playlistWatchLater
                                            : AppLocalizations.of(context)!.playlistLikedVideos,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Icon(playlist.privacy == 'PRIVATE' ? Icons.lock_outline_rounded : Icons.public_rounded),
                              ],
                            ),
                          ),
                        );
                      })
                ],
              ),
            );
          },
        );
      },
    ),
  );
}
