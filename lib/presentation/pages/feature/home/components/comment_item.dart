import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_sharing_app/domain/entity/comment.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentItem extends StatefulWidget {
  const CommentItem({super.key, required Comment comment}) : _comment = comment;

  final Comment _comment;

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
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
                            Text(
                              widget._comment.authorDisplayName!,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(width: 8.0),
                            Text(timeago.format(widget._comment.publishedAt!)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 32.0,
                        height: 32.0,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert),
                          iconSize: 16.0,
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
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.thumb_up_alt_outlined, size: 16.0),
                          label: Text(widget._comment.likeCount.toString()),
                          style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.thumb_down_alt_outlined, size: 16.0),
                          label: Text(widget._comment.likeCount.toString()),
                          style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.comment_outlined, size: 16.0),
                          label: Text(widget._comment.likeCount.toString()),
                          style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Replies (if any)
          widget._comment.replyCount!.toInt() > 0
              ? Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(2.0),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${widget._comment.replyCount} replies',
                          style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.w500)),
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
