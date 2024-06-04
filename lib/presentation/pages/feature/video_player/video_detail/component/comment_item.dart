import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_sharing_app/di.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_sharing_app/domain/enum/rating.dart';
import 'package:video_sharing_app/domain/repository/user_repository.dart';
import 'package:video_sharing_app/presentation/components/bottom_sheet.dart';
import 'package:video_sharing_app/presentation/pages/feature/video_player/video_detail/video_detail_provider.dart';

class CommentItem extends StatefulWidget {
  const CommentItem({
    super.key,
    required Comment comment,
    required void Function() onReplyButtonClicked,
    required void Function() onShowRepliesClicked,
    required Future<bool> Function() onDelete,
    bool reply = false,
    bool isReply = false,
    required Rating rating,
  })  : _onReplyButtonClicked = onReplyButtonClicked,
        _onShowRepliesClicked = onShowRepliesClicked,
        _onDelete = onDelete,
        _comment = comment,
        _reply = reply,
        _isReply = isReply,
        _rating = rating;

  factory CommentItem.reply({
    required Comment comment,
    required Rating rating,
    required Future<bool> Function() onDelete,
  }) {
    return CommentItem(
      comment: comment,
      onReplyButtonClicked: () {},
      onShowRepliesClicked: () {},
      onDelete: onDelete,
      reply: true,
      rating: rating,
    );
  }

  factory CommentItem.isReply({
    required Comment comment,
    required void Function() onReplyButtonClicked,
    required Future<bool> Function() onDelete,
    required Rating rating,
  }) {
    return CommentItem(
      comment: comment,
      onReplyButtonClicked: onReplyButtonClicked,
      onShowRepliesClicked: () {},
      onDelete: onDelete,
      isReply: true,
      rating: rating,
    );
  }

  final void Function() _onReplyButtonClicked;
  final void Function() _onShowRepliesClicked;
  final Future<bool> Function() _onDelete;
  final Comment _comment;
  final bool _reply;
  final bool _isReply;
  final Rating _rating;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  final userRepository = getIt<UserRepository>();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget._isReply ? Theme.of(context).colorScheme.surfaceVariant : Theme.of(context).colorScheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.only(left: widget._reply ? 54.0 : 16.0, top: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: CachedNetworkImage(
                                imageUrl: widget._comment.authorProfileImageUrl!,
                                fit: BoxFit.cover,
                                width: 32.0,
                                height: 32.0,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  widget._comment.authorDisplayName!,
                                  style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 8.0),
                                const Text('∙'),
                                const SizedBox(width: 8.0),
                                Text(timeago.format(widget._comment.publishedAt!)),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 32.0,
                        height: 32.0,
                        child: IconButton(
                          onPressed: () {
                            if (userRepository.getMyId()! == widget._comment.authorId!) {
                              showConsistentBottomSheet(
                                context: context,
                                height: 175.0,
                                negativeButton: bottomSheetNegativeButton(context: context),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          final isDeleted = await widget._onDelete();
                                          if (isDeleted && context.mounted) {
                                            Navigator.pop(context);
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
                          },
                          icon: const Icon(Icons.more_vert),
                          iconSize: 20.0,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  // Content
                  Text(
                    widget._comment.text!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  // Actions
                  SizedBox(
                    height: 48.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        // Like button
                        TextButton.icon(
                          onPressed: () => Provider.of<VideoDetailProvider>(context, listen: false)
                              .rateComment(widget._comment, Rating.like),
                          icon: Icon(
                            widget._rating == Rating.like ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                            size: 20.0,
                            color: Theme.of(context).colorScheme.onBackground.withAlpha(220),
                          ),
                          label: Text(widget._comment.likeCount.toString()),
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.onBackground.withAlpha(220),
                          ),
                        ),
                        // Dislike button
                        TextButton.icon(
                          onPressed: () => Provider.of<VideoDetailProvider>(context, listen: false)
                              .rateComment(widget._comment, Rating.dislike),
                          icon: Icon(
                            widget._rating == Rating.dislike ? Icons.thumb_down_alt : Icons.thumb_down_alt_outlined,
                            size: 20.0,
                            color: Theme.of(context).colorScheme.onBackground.withAlpha(220),
                          ),
                          label: Text(widget._comment.dislikeCount.toString()),
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.onBackground.withAlpha(220),
                          ),
                        ),
                        // Reply button
                        widget._reply == true
                            ? const SizedBox.shrink()
                            : TextButton.icon(
                                onPressed: widget._onReplyButtonClicked,
                                icon: Icon(
                                  Icons.comment_outlined,
                                  size: 20.0,
                                  color: Theme.of(context).colorScheme.onBackground.withAlpha(220),
                                ),
                                label: Text(widget._comment.replyCount.toString()),
                                style: TextButton.styleFrom(
                                  foregroundColor: Theme.of(context).colorScheme.onBackground.withAlpha(220),
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Replies (if any)
          widget._reply || widget._comment.replyCount!.toInt() == 0 || widget._isReply
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(left: widget._reply ? 54.0 : 16.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(2.0),
                    onTap: widget._onShowRepliesClicked,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.nReplies(widget._comment.replyCount!.toInt()),
                        style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
