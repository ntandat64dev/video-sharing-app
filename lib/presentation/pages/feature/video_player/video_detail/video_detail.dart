import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:video_sharing_app/domain/enum/rating.dart';
import 'package:video_sharing_app/domain/repository/comment_repository.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/domain/repository/video_repository.dart';
import 'package:video_sharing_app/presentation/components/custom_text_field.dart';
import 'package:video_sharing_app/presentation/components/sink_animated.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/video_detail/video_detail_provider.dart';
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
                            video.likeCount.toString(),
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
                            video.dislikeCount.toString(),
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
                            CupertinoIcons.bookmark,
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
              onTap: () {},
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
                      ElevatedButton(
                        onPressed: () => provider.followUser(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Text(
                          follow != null
                              ? AppLocalizations.of(context)!.followedButton
                              : AppLocalizations.of(context)!.followButton,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      )
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
                          '${video.commentCount}',
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
                  imageUrl: video.userImageUrl!,
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
